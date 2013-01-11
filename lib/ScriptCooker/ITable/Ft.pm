# ------------------------------------------------------------
# Copyright (c) 2011, BV Associates. Tous droits reserves.
# ------------------------------------------------------------
#
# $Revision: 455 $
#
# ------------------------------------------------------------
#
# Description : Module Ft
# Date :        26/06/2011
# Auteur :      V. Bauchart
# Projet :      I-TOOLS
#
# ------------------------------------------------------------
#
# HISTORIQUE
# 27/07/2012 - T. ZUMBIEHL (BV Associates)
# Remplacement ITOOLS_COMPAT par IT20_COMPLIANT
#
# ------------------------------------------------------------

# Declaration du package
package ScriptCooker::ITable::Ft;

our $VERSION=2.1.0;

# -------
# Imports systemes
# -------
use strict;
use Fcntl qw(:DEFAULT :flock);

use Carp qw( croak carp );
my $package=__PACKAGE__;
$Carp::Internal{$package} = 1;

# -------
# Imports libs
# -------
use ScriptCooker::Log   2.1.0 qw($logger _t);
use ScriptCooker::Utils 2.1.0;

# on demand
use autouse 'File::Spec:Functions' => qw(splitpath);

####################################################
## Decalaration de classe
####################################################

# Heritage
use ScriptCooker::ITable::ITools_interface 2.1.0;
use base qw{ScriptCooker::ITable::ITools_interface};

# Declaration des attributs
use fields qw{ 
    row_number
    select_descriptor
    select_filename
    all_rows
    distinct_query_field
    condition_rpn
    lock_persistent
};

####################################################
## Constructeur
####################################################


# ------------------------------------------
# Nom : Ft::open
#
# Description :
# Constructeur de la classe Ft
#
# Arguments :
#   - table_name : nom de la table a ouvrir
#
# Retourne :
#   - un objet de type Ft
# ------------------------------------------
#override ITools_interface::open
sub open {
    my $self = shift;

    # mandatory parameter
    if (@_ < 1) {
        croak ("'new' take 1 argument")
    }   
    
    # creer nouvel objet si non-hérité
    $self=fields::new($self) if ! ref $self;

    # call the base constructor
    $self->SUPER::open(@_);

    # initialisation des attributs

    # contient le flux de lecture 
    $self->{select_descriptor} = undef;
    $self->{select_filename}   = undef;

    # contient les donnees triee en memoire
    $self->{all_rows} = [];

    # contient les query_field dejà rencontres
    $self->{distinct_query_field} = {};

    # contient l'arbre des conditions en Notation Polonaise Inversee (RPN)
    # Ex: [ "100", "Error", "=", "110", "Error", ">", "OR" ]
    $self->{condition_rpn} = [];
    
    # contient le numero de ligne actuel
    # contient undef si plus de donnee
    $self->{row_number} = undef;

    # garde le verrou posé tant que unlock() n'a pas ete appelé
    $self->{lock_persistent} = undef;
    
    return $self;
}

####################################################
## Methodes privees
####################################################



# ------------------------------------------
# Nom : Ft::_open_table_file
#
# Description :
# Methode en charge de l'ouverture du flux de donnee
# Met a jour l'attribut $self->{select_descriptor}
# Pose un verrou partagé si O_RDONLY
# Pose un verrou exclusif si O_RDWR
#
# Arguments :
#   - mode : flag O_RDONLY (defaut) ou O_RDWR
#
# ------------------------------------------
sub _open_table_file {
    my $self=shift;
    
    my $mode=shift;
    $mode = O_RDONLY if not $mode;

    my $lock_mode;
    if ( ($mode & O_RDWR) ) {

        # le fichier doit être ouvert en écriture pour LOCK_EX !
        $lock_mode=LOCK_EX;
    }
    else {
        # en lecture, un verrou partagé suffit
        $lock_mode=LOCK_SH;
    }
    
    # verification
    if ( $self->{select_descriptor} ) {
        croak(_t("Le fichier de la table [_1] est déjà ouvert",$self->table_name()));
    }
    
    # recupere le chemin de la table
    my $table_file = $self->definition()->file();
    
    if ( defined $table_file && $table_file eq '-' ) {
        # affecte directement l'entree standard comme descripteur
        $self->{select_descriptor} = *STDIN;
        $self->{select_filename}   = '-';
    }
    elsif ( not $table_file) {

        if ( ! $self->definition()->command() ) {
            croak(_t("fichier tab ou command manquant pour [_1]",$self->table_name()));
        }
        
        my $command = $self->definition()->command();
        # interprets vars
        $command =~s/\$\{(\w+)\}/$ENV{$1}/g;
        $command =~s/\$(\w+)/$ENV{$1}/g;
        $command =~s/%(\w+)%/$ENV{$1}/g;
        
        my $command_pipe;
        # CORE::open pour eviter le conflit de nom avec Ft::open !
        CORE::open ( $command_pipe, "$command |")
            or die (_t("Probleme a l'execution de la commande [_1] : [_2]",$command,$!));
        
        $self->{select_descriptor}=$command_pipe;
        $self->{select_filename}  =$command;
    }
    else {
        
        if ( not -e $table_file) {

            if ( ($mode & O_RDWR) && $self->definition->{text_definition}->{FILE} ) {
                # le fichier sera créé avec open()
                $mode = $mode | O_CREAT;
            }
            else {
                croak(_t("fichier tab introuvable : [_1]",$table_file));
            }
        }
        
        $logger->debug(_t("Ouverture du fichier [_1] (table [_2])",$table_file,$self->table_name));
        
        ##remplace ouverture simple par idiome Perl de lock
        #open( my $table_fh, "+< $table_file")
        sysopen($self->{select_descriptor}, $table_file, $mode)
            or die (_t("Impossible d'ouvrir le fichier [_1] : [_2]",$table_file,$!));
        
        $self->{select_filename}  =$table_file;

        {
            # lock exclusif avec timeout (voir perldoc perlipc)

            # start timeout
            local $SIG{ALRM}=sub { croak(_t("Le delai maximum d'attente de deverouillage a ete atteint")); };
            alarm 5;

            if ( $^O eq "MSWin32" ) {
                
                # Windows empeche "alarm" de fonctionner en mode bloquant
                # On utilise donc une boucle en mode non-bloquant
                # Attention : précis à +/- 1s, et on perd également l'eventuel message d'erreur
                while (! flock($self->{select_descriptor}, $lock_mode | LOCK_NB) ) {
                    sleep 1;
                }
            }
            else {
                flock($self->{select_descriptor}, $lock_mode)
                    or die (_t("Impossible de poser un verrou sur [_1] : [_2]",$self->{select_filename},$!));
            }

            # stoppe timeout
            alarm 0;
        }

        # TODO utile?
        seek($self->{select_descriptor}, 0, 0)
            or die (_t("Impossible de se positioner au debut du fichier [_1] : [_2]",$table_file,$!));
        
        # autoflush $table_fh (idiome Perl)
        # TODO utile?
        #my $stdout = select($table_fh); # STDOUT -> $table_fh
        #$| = 1;                         # autoflush STDOUT
        #select ($stdout);               # restore STDOUT
        
    }

    return;
}

# ------------------------------------------
# Nom : Ft::_write_table_file
#
# Description :
# Methode en charge de l'ecriture dans la table
#
# Arguments :
#   - @content : liste de donnee a ecrire dans le fichier
# ------------------------------------------
sub _write_table_file {
    my $self=shift;
    
    my @content=@_;

    if ( not $self->{select_descriptor} ) {
        croak(_t("Le fichier de la table [_1] n'est pas ouvert",$self->{select_filename}));
    }

    print { $self->{select_descriptor} } @content
        or die (_t("Impossible d'ecrire dans la table [_1] : [_2]",$self->{select_filename},$!));

    return;
}

# ------------------------------------------
# Nom : Ft::_empty_table_file
#
# Description :
# Vide completement le fichier de la table
#
# ------------------------------------------
sub _empty_table_file {
    my $self=shift;

    if ( not $self->{select_descriptor} ) {
        croak(_t("Le fichier de la table [_1] n'est pas ouvert",$self->table_name()));
    }

    # vide la table
    truncate($self->{select_descriptor}, 0)
        or die (_t("Impossible de vider le fichier [_1] : [_2]",$self->{select_filename},$!));
    # retour au debut
    seek($self->{select_descriptor}, 0, 0)
        or die (_t("Impossible de se positionner au debut de la table [_1] : [_2]",$self->{select_filename},$!));

    return;
}

# ------------------------------------------
# Nom : Ft::_close_table_file
#
# Description :
# Ferme le descripteur de fichier en cours
#
# ------------------------------------------
sub _close_table_file {
    my $self=shift;
    
    if ( $self->{lock_persistent} ) {

        # si le lock doit être conservé, on se contente de rembobiner
        seek($self->{select_descriptor}, 0, 0)
            or die (_t("Impossible de se positioner au debut du fichier [_1] : [_2]",$self->{select_filename},$!));
    }
    else {
        if ( not $self->{select_descriptor} ) {
            croak(_t("Le fichier de la table [_1] n'est pas ouvert",$self->table_name()));
        }
        elsif ( $self->{select_filename} ne "-" ) {

            if ( ! close($self->{select_descriptor}) ) {
                if ( $? ) {
                    die (_t("La commande [_1] a retourner le code retour : [_2]",$self->{select_filename},$!));
                }
                else {
                    die (_t("Impossible de fermer le fichier [_1] : [_2]",$self->{select_filename},,$!));
                }
            }
        }

        $self->{select_descriptor} = undef;
        $self->{select_filename}   = undef;
    }

    return;
}

# ------------------------------------------
# Nom : Ft::_sysread_line
#
# Description :
# Lit une ligne du descripteur de fichier
#
# Retourne :
#   scalaire : ligne lue sur $self->{select_descriptor}
# ------------------------------------------
sub _sysread_line {
    my $self=shift;

    if ( not $self->{select_descriptor} ) {
        croak(_t("Le fichier de la table [_1] n'est pas ouvert",$self->table_name()));
    }

    # Si le fichier n'est pas l'entree standard, on le traite de facon traditionnelle
    if ( $self->{select_filename} ne "-" ) {
        return readline($self->{select_descriptor});
    }

    # pas très propre mais nécéssaire car le Define a peut être lu trop de ligne
    my $read_data = shift @{ $self->{define_obj}->{read_ahead_data} };

    my $return_data;
    if ( $read_data) {
        $return_data = $read_data;
    }
    else {
        # Si le fichier est l'entree standard, il faut le lire caractere par caractere,
        #   sinon le systeme va buffuriser trop de lignes, qui ne seront plus disponibles
        #   a l'appel suivant

        my $raw_line="";

        while (1) {
            my $char;

            my $read_result=sysread( $self->{select_descriptor}, $char, 1);
            if ( ! defined $read_result ) {
                die(_t("Impossible de lire le fichier [_1] : [_2]", $self->{select_descriptor}, $!));
            }
            elsif( ! $read_result ) {
                # EOF
                last;
            }
            elsif ( $char eq "\n" ) {
                # stoppe la boucle si on rencontre une fin de ligne

                $raw_line.=$char;
                last;
            }
            else {
                # concatene le caractere et continue
                $raw_line.=$char;
            }
        }

        $return_data = $raw_line;
    }

    return $return_data;
}

# ------------------------------------------
# Nom : Ft::_get_file_row
#
# Description :
# Renvoie la prochaine ligne de la table sous forme d'une référence
#   vers un dictionnaire de type COLONNE => VALEUR
#
# Arguments :
#   - keepall = renvoie aussi les lignes vides et de commentaires comme 
#       des scalaires texte
#       (principalement utilisé pour garder toutes les lignes pendant un update)
#
# Retourne :
#   scalaire : reference vers un hash de type colonne => valeur
#   scalaire : texte si commentaire ou ligne vide (voir option keepall)
# ------------------------------------------
sub _get_file_row {
    my $self=shift;

    my $keepall=shift;

    # echappe les caractere regexp
    my $separator=quotemeta($self->{define_obj}->separator());


    my $row_hash_ref;

    # boucle principale
    READ_ROW:
    while ( my $select_output= $self->_sysread_line() ) {

        if ( ! defined $select_output) {
            # plus rien a lire, on retourne undef
            last READ_ROW;
        }

        # nettoyage des commentaires
        if ( ! $keepall && ! $self->{define_obj}->command() ) {
            # nettoye les commentaires de fin de ligne
            # sauf si c'est une COMMAND
            $select_output =~ s/(\w)\s*#.*$/$1/;  
        }

        # on passe les lignes vides ou commençant par un commentaire
        if ( $select_output =~ /^(#|\s*$)/ ) {
        
            if ( $keepall ) {

                # pas de reference, on renvoie directement le texte
                $row_hash_ref=$select_output;
                last READ_ROW;
            }
            else {
                # suivant !
                next READ_ROW;
            }
        }
        else {


            # nettoyage des caractères de fin de ligne
            chomp $select_output;

            my @row_array;
            if ( $ENV{IT20_COMPLIANT} ) {

                # decoupage selon le separateur de la table
                @row_array=split( /$separator/ ,$select_output, -1);

                # sans requete de colonne, le split ne découpe
                # que les champs nécéssaires, même s'il y a trop de separateurs
                if ( ! $self->{modified_query_field} ) {
                    my $split_limit = @{ $self->{query_field} };

                    #trop de champs par rapport au nombre de demandé
                    if ( @row_array > $split_limit) {

                        # on reforme le dernier champs avec les champs en trop
                        my @last_fields;
                        foreach ( $split_limit..@row_array) {
                            unshift @last_fields, pop @row_array;
                        }

                        my $sep = $self->{define_obj}->separator();
                        push @row_array, join($sep, @last_fields);
                    }
                }
            }
            else {
                # decoupage selon le separateur de la table
                # sauf s'il est échappé par \
                @row_array=split( /(?<!\\)$separator/ ,$select_output);

                # supprime les echappements de separateurs
                foreach ( @row_array ) {
                    s/[\\]($separator)/$1/g;
                }
            }

            # On suppose que les données ont bien les champs indiqués
            # dans la definition !
            foreach my $field ( $self->field() ) {
                
                # on depile la premiere colonne
                my $value = shift @row_array;

                # si pas de donnee, on initialise à la chaine vide
                #   Peut se produire s'il manque des colonnes
                if ( ! defined $value ) {
                    $value = "";
                }

                # affecte le hash
                $row_hash_ref->{$field} = $value;

            }

            # la condition correspond, on arrete la boucle
            last READ_ROW;
        }
    }


    return $row_hash_ref;
}


# ------------------------------------------
# Nom : Ft::_sort_array
#
# Description :
# Lance le tri sur les donnees en memoire dans $self->{all_rows}
# Tri selon les colonnes de la requete
#
# ------------------------------------------
sub _sort_array {
    my $self=shift;
    
    # fabrication des operations de tris
    my @sort_operations;
    foreach my $sort_clause ( $self->query_sort() ) {

        # Decoupage si format : COLONNE DESC|ASC
        my ($field,$order) = ( $sort_clause =~ /^(.+)\s+(DESC|ASC)$/ );

        # sinon format : COLONNE
        $field = $sort_clause if ! $field;


        # comparaison alphabetique par defaut
        #TODO utiliser Ft::_compare_values();
        my $operator="cmp";
        if (  defined $self->{define_obj}->{size}->{$field}) {

            # comparaison numerique pour le type numerique et pourcentage
            $operator='<=>' if $self->{define_obj}->{size}->{$field} =~ /[np]$/;
        }
        else {
            die(_t("Impossible de trouver la taille du champs [_1]",$field));
        }

        # preparation du texte pour le "eval"
        $field =~ s/}/\}/g;

        if (defined $order && uc($order) eq 'DESC') {
            push @sort_operations,
                "\$_[1]->{ q{$field} } $operator \$_[0]->{ q{$field} }";
        }
        else {
            push @sort_operations,
                "\$_[0]->{ q{$field} } $operator \$_[1]->{ q{$field} }";
        }
    }

    # fabrication d'une fonction regroupant les operations de comparaison
    # utilisation exceptionnelle et encadree de eval($chaine) !
    my $generated_sub = eval( "sub {". join(' || ', @sort_operations)."}" );

    if (! defined $generated_sub ) {
        die (_t("Exception pendant la generation de la fonction de tri : [_1]",$@));
    }

    # lancement du tri effectif
    @{ $self->{all_rows} } = sort {
                                      $generated_sub->($a,$b)
                                  } @{ $self->{all_rows} };

    return;
}


# ------------------------------------------
# Nom : Ft::_get_sorted_row
#
# Description :
# Renvoie la prochaine ligne en prenant en compte le tri et les conditions
# Si un tri est activé, toutes les lignes selectionnées sont lues et triées en mémoire
# Sinon renvoie simplement la prochaine ligne selectionnée
#
# Retourne :
#   scalaire : reference vers un hash de type colonne => valeur
# ------------------------------------------
sub _get_sorted_row {
    my $self = shift;
    
    my %row_hash;

    # si il y a un tri a faire, il faut stocker tout en mémoire
    if ( $self->query_sort() || $self->query_reverse() ) {

        # si des donnees ont deja ete envoyees, la table est deja en mémoire
        if ( defined $self->{row_number} ) {

            # on recupere directement de la memoire
            my $temp_hash;
            if ( $self->query_reverse() ) {
                # si tri inverse, on dépile par la droite
                $temp_hash = pop @{ $self->{all_rows} };
            }
            else {
                # si tri normal, on dépile par la gauche
                $temp_hash = shift @{ $self->{all_rows} };
            }

            if ( ! $temp_hash ) {
                # il n'y a plus de donnee, on reset le compteur
                undef $self->{row_number};
            }
            else {
                # On renvoie une ligne
                %row_hash = %{ $temp_hash };
            }
            # on ne va pas plus loin
        }

        # aucune donne n'a encore ete lu, il faut mettre la table en mémoire
        else {

            # on stocke dans un tableau les lignes validant les conditions
            while ( defined ( my $row_hash_ref=$self->_get_file_row())) {

                if ( $self->match_query_condition($row_hash_ref) ) {

                    push @{ $self->{all_rows} }, $row_hash_ref;
                }
            }

            # s'il y a des donnes a traiter
            if ( @{ $self->{all_rows} } ) {

                if ( $self->query_sort() ) {
                    # lancement du tri
                    $self->_sort_array();
                }
    
                # On renvoie la première ligne
                my $temp_hash;
                if ( $self->query_reverse() ) {
                    $temp_hash = pop @{ $self->{all_rows} };
                }
                else {
                    $temp_hash = shift @{ $self->{all_rows} };
                }
                %row_hash = %{ $temp_hash };
                $self->{row_number}=0;
            }

        }
    }

    # pas de tri, on lit une ligne et on renvoie
    else {

        # prochaine ligne validant la condition
        while ( defined ( my $row_hash_ref=$self->_get_file_row())) {

            if ( $self->match_query_condition($row_hash_ref) ) {

                %row_hash=%{$row_hash_ref};
                last;
            }
        }
    }

    
    return %row_hash;
}

# ------------------------------------------
# Nom : Ft::_updateall_rows
#
# Description :
# Effectue une mise à jour de ligne sur la structure memoire de la table
# stockée dans $self->{all_rows}, avec un hash passé en parametre.
# La ligne mise à jour est celle contenant la clef du hash
#
# Arguments:
#   - ligne à mettre à jour sous forme d'un hash COLONNE => VALEUR

# Retourne :
#   scalaire : nombre de lignes modifiées
#       renvoie undef si la clef n'a pas été trouvée
# ------------------------------------------
sub _updateall_rows {
    my $self = shift;

    my %row = @_;


    my $update_key;
    my @key = $self->{define_obj}->key();
    # cherche si clef déjà présente
    ROW:
    foreach my $line_hash ( @{ $self->{all_rows} } ) {

        # on ne recherche que dans les reference (pas les commentaires)
        if (ref $line_hash) {

            # si la ligne ne satisfait pas les conditions, on passe
            if ( ! $self->match_query_condition($line_hash) ) {
                next ROW;
            }
        
            my $keys_matched=0;
            my @key_value;
            
            # sur chaque ligne, verifie toutes les clefs
            foreach my $key_field ( @key ) {

                my $size = $self->field_size($key_field);

                if ( 0 == $self->_compare_values ($size,
                                    $line_hash->{$key_field},
                                    $row{$key_field} )) 
                {
                    $keys_matched++;
                }
            }
            
            # si on a trouvé toutes les clefs, on met à jour
            if ( $keys_matched == @key ) {
                
                # on est en mode mise à jour
                if ( ! defined $update_key ) {
                    $update_key=0;
                }
                
                FIELD:
                foreach my $set_field ( keys %row ) {
                
                    # gère les cas ou la valeur est undef
                    # normalement pas nécéssaire
                    my $defined_vars=0;
                    $defined_vars++ if defined $line_hash->{$set_field};
                    $defined_vars++ if defined $row{$set_field};
                    
                    my $touched=0;
                    if ( $defined_vars != 0) {
                        # au moins 1 des 2 est défini
                        
                        if ( $defined_vars != 2
                            or $line_hash->{$set_field} ne $row{$set_field} )
                        {
                            $logger->debug("update $set_field : $line_hash->{$set_field} = $row{$set_field} ");
                            # 1 des 2 n'est pas défini ou les 2 sont differents
                            $line_hash->{$set_field} = $row{$set_field};
                            
                            # valeur modifiée
                            $touched++;
                        }
                    }
                    if ( $touched ) {
                        $update_key++;
                    }
                }
                
                # une clef est unique, on sort de la boucle
                #NOTE on continue car la table peut etre incohérente
                #last ROW if $keys_matched;
            }
        }
    }

    return $update_key;
}


# ------------------------------------------
# Nom : Ft::_writeall_rows
#
# Description :
# Effectue une mise à jour de ligne sur la structure memoire de la table
# stockée dans $self->{all_rows}, avec un hash passé en parametre.
# La ligne mise à jour est celle contenant la clef du hash
#
# Arguments:
#   - ligne à mettre à jour sous forme d'un hash COLONNE => VALEUR

# Retourne :
#   scalaire : nombre de mise à jour effectuée
#       renvoie undef si la clef n'a pas été trouvée
# ------------------------------------------
sub _writeall_rows {
    my $self = shift;

    # retransforme les hash en texte
    #NOTE on aurai pu directement transformer le $self->{all_rows} pour
    #   économiser de la mémoire, mais ce n'aurait pas été propre...
    my @table_lines;
    foreach my $row ( @{ $self->{all_rows} } ) {
        # si c'est une référence, ce sont des données
        if (ref $row) {
            # transforme le hash en tableau
            my %row_hash = %{ $row };
            my @fields = @row_hash{ $self->field() };
            
            # transforme les undef en chaine vide
            map {$_='' if not defined $_} @fields;
            
            # tranforme les champs en ligne
            my $line = join( $self->output_separator , @fields );
            
            # supprime et recree fin de ligne au cas où
            chomp $line;
            $line.="\n";

            push @table_lines, $line;
        }
        # sinon, on garde tel quel
        else {
            push @table_lines, $row;
        }
    }

    # réécrit entierment le fichier avec la table modifiée
    $self->_empty_table_file();
    
    $logger->debug("Reecriture complete du fichier (".@table_lines." lignes)");
    $self->_write_table_file( @table_lines );

    return;
}

# ------------------------------------------
# Nom : Ft::_set_default_values
#
# Description :
#   Ajoute des valeurs par defaut aux colonnes vides
#
# Arguments:
#   - ligne à mettre à jour sous forme d'un hash COLONNE => VALEUR
#
# Retourne :
# ------------------------------------------
sub _set_default_values {
    my $self = shift;

    my $row_ref = shift;

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
    my $date_norm=sprintf("%04d%02d%02d%02d%02d%02d",
                                            $year+1900,
                                            $mon+1,
                                            $mday,
                                            $hour,
                                            $min,
                                            $sec,
                         );

    foreach my $field ( keys %{ $row_ref } ) {

        if ( ! $row_ref->{$field} ) {

            my $field_size = $self->field_size($field);

           $row_ref->{$field} =  
                ( $field_size =~ /[npb]$/ )?0:
                ( $field_size =~ /[d]$/   )?$date_norm:
                "";
        }
    }

    return;
}

# ------------------------------------------
# Nom : Ft::_compare_values
#
# Description :
#   Compare de 2 valeurs d'une taille de colonne
#
# Arguments:
#   - Taille (champs de definition SIZE)
#   - Valeur1
#   - Valeur2
#
# Retourne :
#   - scalaire :
#       0  si Valeur1 = Valeur2
#       1  si Valeur1 > Valeur2
#       -1 si Valeur1 < Valeur2
# ------------------------------------------
sub _compare_values {
    my $self = shift;

    my $size = shift;
    my $value1= shift;
    my $value2= shift;

    if ( ! defined $value2 || $size !~ /^\d+\w$/ ) {
        croak(_t("usage : [_1]",'_compare_values($size,$value1,$value2)'));
    }

    if ( $size =~ /[nd]$/ ) {
        # desactive alertes si type comparaison avec des donnees non numeriques
        no warnings qw(numeric);

        return $value1 <=> $value2;
    }
    elsif ( $size =~ /[p]$/ ) {
        $value1 =~ s/%$//;
        $value2 =~ s/%$//;

        # desactive alertes si type comparaison avec des donnees non numeriques
        no warnings qw(numeric);

        return $value1 <=> $value2;
    }
    elsif ( $size =~ /[b]$/ ) {
        # petite transformation des valeurs acceptee
        if ( $value1 !~ s/^[OoYy1]$/1/ ) {
            # faux si non reconnu
            $value1 = 0;
        }
        if ( $value2 !~ s/^[OoYy1]$/1/ ) {
            $value2 = 0;
            }

        return $value1 <=> $value2;
    }
    else {
        return $value1 cmp $value2;
    }
}

####################################################
# public methods
####################################################


# ------------------------------------------
# Nom : Ft::lock_table
#
# Description :
#   Ouvre le fichier correspondant à la table et 
#   pose un verrou exclusif
#
# ------------------------------------------
sub lock_table {
    my $self=shift;

    # indique aux autres méthode de ne pas retirer le LOCK
    $self->{lock_persistent}=1;

    $self->_open_table_file(O_RDWR);

    return;
}

# ------------------------------------------
# Nom : Ft::unlock_table
#
# Description :
#   Retire explicitement le verrou sur la table et
#   ferme le descripteur de fichier
#
# ------------------------------------------
sub unlock_table {
    my $self=shift;

    # indique aux autres méthode que le lock n'est plus permanent
    $self->{lock_persistent}=undef;

    # force la fermeture du fichier
    $self->close();

    return;
}

# ------------------------------------------
# Nom : Ft::match_query_condition
#
# Description :
#
# Arguments :
#   row_ref : reference vers un hash de type colonne => valeur
# Retourne :
#   scalaire : vrai si le hash valide la condition, faux sinon
# ------------------------------------------
sub match_query_condition {
    my $self=shift;

    my $row_ref=shift;

    if (! defined $row_ref ) {
        die ('usage: match_query_condition($row_ref)');
    }

    # pas de condition : toujours vrai
    if ( ! @{ $self->{condition_rpn} } ) {
        return 1;
    }

    # pile d'argument utilisÃe pour l'interpretation du RPN
    my @argument_stack;
    foreach my $instruction ( @{ $self->{condition_rpn} } ) {

        if ( ! ref ($instruction) ) {
            # ajoute la valeur sur la pile d'arguments
            push @argument_stack, $instruction;
        }
        else {
            # operateur sur la pile

            if ( ref($instruction) eq 'SCALAR' ) {
                # c'est un operateur
                my $text_instruction = ${$instruction};

                if ( $text_instruction eq 'VALUE' ) {

                    # operateur unaire
                    my $value = pop @argument_stack;
                    
                    # operateur noop

                    # ajoute la valeur la pile
                    push @argument_stack, $value;
                }
                # operateur FIELD
                elsif ( $text_instruction eq 'FIELD' ) {

                    # operateur unaire
                    my $field = pop @argument_stack;

                    # ajoute la valeur du champ sur la pile
                    push @argument_stack, $row_ref->{$field};
                }
                # operateur .FIELD
                elsif ( $text_instruction eq '.FIELD' ) {

                    # operateur unaire
                    my $field = pop @argument_stack;

                    # retire le '.' marquant la presence d'un nom de colonne
                    $field =~ s/^\.//;

                    # ajoute la valeur du champ sur la pile
                    push @argument_stack, $row_ref->{$field};
                }

                # operateur de comparaison type/op
                elsif ( $text_instruction =~ /^(\w+)(=|!=|>|>=|<|<=)$/ ) {
                    my $op_type = $1;
                    my $op      = $2;


                    # operateur binaire
                    my $val1 = pop @argument_stack;
                    my $val2 = pop @argument_stack;

                    # comparaison effective
                    my $result;
                    if ( $op_type eq 'num' ) {

                        # desactive alertes si type comparaison avec des donnees non numeriques
                        no warnings qw(numeric);

                        # 2,00 -> 2.00
                        $val1 =~ s/,/./;
                        $val2 =~ s/,/./;

                        $result=
                            ( $op eq '='  )? $val1 == $val2:
                            ( $op eq '!=' )? $val1 != $val2:
                            ( $op eq '>'  )? $val1 >  $val2:
                            ( $op eq '>=' )? $val1 >= $val2:
                            ( $op eq '<'  )? $val1 <  $val2:
                            ( $op eq '<=' )? $val1 <= $val2:
                            0;
                    }
                    elsif (  $op_type eq 'str' ) {

                        $result=
                            ( $op eq '='  )? $val1 eq $val2:
                            ( $op eq '!=' )? $val1 ne $val2:
                            ( $op eq '>'  )? $val1 gt $val2:
                            ( $op eq '>=' )? $val1 ge $val2:
                            ( $op eq '<'  )? $val1 lt $val2:
                            ( $op eq '<=' )? $val1 le $val2:
                            0;
                    }
                    elsif (  $op_type eq 'bool' ) {

                        # petite transformation des valeurs acceptee
                        if ( $val1 !~ s/^[OoYy1]$/1/ ) {
                            # faux si non reconnu
                            $val1 = 0;
                        }
                        if ( $val2 !~ s/^[OoYy1]$/1/ ) {
                            $val2 = 0;
                        }

                        $result=
                            ( $op eq '='  )? $val1 == $val2:
                            ( $op eq '!=' )? $val1 != $val2:
                            ( $op eq '>'  )? $val1 >  $val2:
                            ( $op eq '>=' )? $val1 >= $val2:
                            ( $op eq '<'  )? $val1 <  $val2:
                            ( $op eq '<=' )? $val1 <= $val2:
                            0;
                    }

                    # ajoute le resultat sur la pile des arguments
                    push @argument_stack, $result;
                }
                elsif ( $text_instruction eq 'OR' ) {

                    # operateur binaire
                    my $val1 = pop @argument_stack;
                    my $val2 = pop @argument_stack;

                    my $result= $val1 || $val2;

                    # ajoute le resultat sur la pile des arguments
                    push @argument_stack, $result;
                }
                elsif ( $text_instruction eq 'AND' ) {

                    # operateur binaire
                    my $val1 = pop @argument_stack;
                    my $val2 = pop @argument_stack;

                    my $result= $val1 && $val2;

                    # ajoute le resultat sur la pile des arguments
                    push @argument_stack, $result;
                }
                # idem avec ~
                elsif ( $text_instruction eq '~' ) {
                    my $val1 = pop @argument_stack;
                    my $val2 = pop @argument_stack;

                    # echappe d'eventuels caracteres regexp
                    $val2 = quotemeta($val2);
                    my $result= ($val1 =~ /$val2/);

                    push @argument_stack, $result;
                }
                # idem avec !~
                elsif ( $text_instruction eq '!~' ) {
                    my $val1 = pop @argument_stack;
                    my $val2 = pop @argument_stack;

                    # echappe d'eventuels caracteres regexp
                    $val2 = quotemeta($val2);
                    my $result= ($val1 !~ /$val2/);

                    push @argument_stack, $result;
                }
                else {
                    die(_t("Operateur [_1] non reconnu", $text_instruction));
                }
            }
            elsif ( ref($instruction) eq 'CODE' ) {
                #TODO si $instruction est une fonction
                $instruction->(\@argument_stack, $row_ref);
            }   
        }
    }
    
    # assertion de verification
    if ( @argument_stack > 1 ) {
        die(_t("Erreur lors du calcul des conditions"));
    }

    # le resultat final se trouve dans la pile
    my $result=pop @argument_stack;

    return $result;
}


# ------------------------------------------
# Nom : Ft::query_condition
#
# Description :
# Remplace la condition de la prochaine requete
#
# Arguments :
#   - conditions : liste de conditions a passer à la requete
#       les lignes devront respectees toutes les conditions (AND)
#
# Retourne :
#   - un objet de type Ft
# ------------------------------------------
#override ITools_interface::query_condition
sub query_condition {
    my $self = shift;
    if (@_) {

        # Selectionne les conditions contenant quelquechose
        # Permet a l'utilisateur de vider les conditions si
        #   query_condition("")
        @{ $self->{query_condition} } = grep {$_} @_;
    }

    if ( @{ $self->{query_condition} } ) {
        
        # charge le fichier si condition
        require ScriptCooker::ITable::Condition;

        #Exemple :
        #$self->{query_condition}=[ "Message = .Function and Error < 20" ];

        # recuperation sous forme Reverse Polish Notation
        my $plain_condition = join(' ',@{ $self->{query_condition} });
        my @condition_rpn = ScriptCooker::ITable::Condition->parse($plain_condition);

        #Exemple resultat :
        #@condition_rpn=('.Function',\'VALUE','Message',\'FIELD',\'=','20',\'VALUE','Error',\'FIELD',\'<',\'AND');

        # validation des champs par analyse du RPN

        # pile de calcul contenant les types de champs
        my @argument_stack;
        my $current_field;
        foreach my $instruction ( @condition_rpn ) {

            # valeur (non operateur)
            if ( ! ref($instruction) ) {
                push @argument_stack, $instruction;
            }
            else {
                my $text_instruction = ${$instruction};

                # validation si valeur est un nom de colonne
                if ( $text_instruction eq 'FIELD' ) {
                    my $field = pop @argument_stack;

                    if ( ! $self->has_fields($field) ) {
                        croak(_t("La colonne [_1] n'existe pas",$field));
                    }
                    else {
                        $current_field=$field;
                    }

                    # stockage du type pour l'operateur
                    my $type = $self->{define_obj}->{size}->{$field};

                    # la taille ne nous interesse pas
                    $type =~ s/^\d+//;

                    # type strict avec +
                    push @argument_stack, '+'.$type;
                }
                elsif ( $text_instruction eq 'VALUE' ) {
                    my $value = pop @argument_stack;

                    # test si la valeur est de la forme .COLONNE
                    my $field = $value;
                    $field =~ s/\.//;
                    if ( $self->has_fields($field) ) {

                        # modification de l'operateur dans liste RPN
                        $instruction = \".FIELD";

                        # stockage du type pour l'operateur
                        my $type = $self->{define_obj}->{size}->{$field};

                        # la taille ne nous interesse pas
                        $type =~ s/^\d+//;

                        # type strict
                        push @argument_stack, '+'.$type;
                    }
                    else {
                        # ajout du type detecte de la valeur
                        if ( $value =~ /^[01]$/ ) {

                            # binaire numerique
                            push @argument_stack, 'B';
                        }
                        elsif ( $value =~ /^[YNO]$/i ) {

                            # binaire texte
                            push @argument_stack, 'b';
                        }
                        elsif ( $value =~ /^\d{14}$/ ) {
                            #TODO parser les dates valides

                            # date
                            push @argument_stack, 'd';
                        }
                        elsif ( $value =~ /^\d+([.,]\d+)?%$/ ) {

                            # pourcentage
                            push @argument_stack, 'p';
                        }
                        elsif ( $ENV{IT20_COMPLIANT} 
                                && $value =~ /^=*\s*\d+([.,]\d+)?\s*=*$/ )
                        {

                            # nombre avec des =, pour compatibilité avec 2.0.x
                            push @argument_stack, 'n';
                        }
                        elsif ( $value =~ /^\d+([.,]\d+)?$/ ) {

                            # nombre
                            push @argument_stack, 'n';
                        }
                        else {
                            # sinon texte
                            push @argument_stack, 's';
                        }
                    }
                }
                elsif ( $text_instruction =~ /^(=|!=|<=|>=|<|>)$/ ) {
                    my $op         = $text_instruction;
                    my $field_type = pop @argument_stack;
                    my $value_type = pop @argument_stack;

                    # verification interne que l'operande gauche est bien un type strict
                    if ( $field_type !~ /^[+]/ ) {
                        die(_t("Erreur interne : [_1] doit etre un type de colonne strict",$field_type));
                    }

                    # on ne peut comparer des champs strict s'ils ont le meme type
                    # (on compare en minuscule pour que B et b soit identiques)
                    if ( $value_type =~ /^[+]/ && lc($field_type) ne lc($value_type) ) {
                        croak(_t("La valeur donnee pour la colonne [_1] n'est pas correcte.",$current_field));
                    }
                    # on valide la compatibilité non stricte (cast)
                    elsif (   ( $field_type =~ /n$/ && $value_type !~ /[pdnB]$/ )
                           or ( $field_type =~ /p$/ && $value_type !~ /[pn]$/ )
                           or ( $field_type =~ /b$/ && $value_type !~ /[bB]$/ )
                           or ( $field_type =~ /B$/ && $value_type !~ /[bB]$/ )
                       )
                    {
                        croak(_t("La valeur donnee pour la colonne [_1] n'est pas correcte.",$current_field));
                    }

                    if ( $ENV{IT20_COMPLIANT} ) {
                        if ( $value_type =~ /p$/ ) {
                            #TODO probleme: la valeur a afficher dans le message n'est plus accessible!
                            carp(_t("Valeur [_1] prise en compte sans le caractere '%' !",""));
                        }
                    }

                    # codage du nouvel operateur sous la forme type/op
                    my $new_op =
                        ( $field_type =~ /[np]$/ )?'num'.$op:
                        ( $field_type =~ /[bB]$/ )?'bool'.$op:
                        'str'.$op;

                    # modification de l'operateur dans liste RPN
                    $instruction = \$new_op;

                }
                elsif ( $text_instruction =~ /(~|!~)/ ) {
                    my $field_type = pop @argument_stack;
                    my $value_type = pop @argument_stack;

                    # l'operateur ne s'applique que sur certains types
                    if ( $field_type =~ /[+][pnb]$/ || $value_type =~ /[+][pnb]$/ ) {
                        croak(_t("L'operateur de selection est incorrect !"));
                    }
                }
                else {
                    # on ne traite pas les autres operateurs AND/OR ...
                }
            }
        }

        #Exemple après traitement :
        #@condition_rpn=('.Function',\'.FIELD','Message',\'FIELD',\'str=','20',\'VALUE','Error',\'FIELD',\'num<',\'AND');
        #use Data::Dumper; warn Dumper(\@condition_rpn);

        $self->{condition_rpn} = \@condition_rpn;
        
        $logger->info(_t("Condition de selection sur [_1] : [_2]",$self->table_name(),join(' ',@{ $self->{query_condition} } )));
    }
    
    return @{ $self->{query_condition} };
}

# ------------------------------------------
# Nom : Ft::get_row_number
#
# Description :
# Calcul le nombre de ligne renvoyées depuis l'ouverture de la table
#
# Retourne :
#   - scalaire : nombre de ligne
# ------------------------------------------
sub get_row_number {
    my $self=shift;

    return $self->{row_number};
}

# ------------------------------------------
# Nom : Ft::fetch_row_array
#
# Description :
#   Renvoie la prochaine ligne validant les conditions de selection
#   sous forme d'un tableau de valeur, ordonnee selon la selection de colonne
#
# Retourne :
#   - array : liste de valeur
# ------------------------------------------
#override ITools_interface::fetch_row_array
sub fetch_row_array {
    my $self = shift;

    my %row=$self->fetch_row();
    
    return () if not %row;

    my @row_array = @row{ $self->query_field() };
        
    return @row_array;
}


# ------------------------------------------
# Nom : Ft::fetch_row
#
# Description :
#   Renvoie la prochaine ligne validant les conditions de selection
#   sous forme d'un dictionnaire restreint de type colonne => valeur
#
# Retourne :
#   - hash : dictionnaire restreint aux colonnes selectionnées
# ------------------------------------------
#override ITools_interface::fetch_row
sub fetch_row {
    my $self=shift;

    my %row_hash;

    # ouverture du fichier de donnee
    if (not defined $self->{select_descriptor} ) {
        $self->_open_table_file(O_RDONLY);
    }

    # recuperation des infos de la table
    my $sep = $self->{define_obj}->separator();
    my @query_fields = $self->query_field();

    # gestion de l'unicité des lignes renvoyées
    if ( $self->query_distinct() ) {

        # on lit l'entree suivante
        while ( %row_hash=$self->_get_sorted_row() ) {
            
            # fabrication d'un scalaire representant une ligne de façon unique
            my @distinct_field;
            foreach my $field ( $self->query_field() ) {
                push @distinct_field, $row_hash{$field};
            }
            my $distinct_row = join($sep, @distinct_field);

            if (exists $self->{distinct_query_field}->{$distinct_row}) {
                # cette valeur a deja ete rencontree
                # on la passe et on prend la ligne suivante
                next;
            }
            else {
                #nouvelle valeur rencontree, on la seuvegarde et on renvoie
                $self->{distinct_query_field}->{$distinct_row}++;
                last;
            }
        }
    }
    else {
        # pas d'unicité, on renvoie la prochaine ligne
        %row_hash=$self->_get_sorted_row();
    }

    my %return_hash;
    if ( %row_hash ) {

        # on ne laisse dans le resultat que les colonnes demandees
        @return_hash{ @query_fields } = @row_hash { @query_fields };

        # on ajoute d'eventuels champs dynamiques
        foreach my $field ($self->dynamic_field()) {
            $return_hash{$field} = "";
        }

        $self->{row_number}++;
    }
    else {
        $self->_close_table_file();
        $self->{row_number}=undef;
    }

    return %return_hash;
}



# ------------------------------------------
# Nom : Ft::update_row
#
# Description :
# Met a jour une ligne dans la table
#
# Arguments :
#   hash de la forme COLONNE => VALEUR
# Retourne :
#   -scalaire : nombre de ligne modifie
# ------------------------------------------
#override ITools_interface::update_row
sub update_row {
    my $self=shift;
    
    my %row = @_;

    # nettoie la ligne à remplacer
    foreach my $field ( %row ) {
        # transforme les undef en chaine vide (pas de NULL en I-TOOLS)
        $field='' if not defined $field;
    }

    # lance la verification de coherence
    my @check_error = $self->check_row(%row);

    # Ajout des champs manquant
    foreach my $field ( $self->field() ) {
        if ( ! exists $row{$field} ) {
            $row{$field} = undef;
        }
    }

    # Ajout les valeurs par defaut
    $self->_set_default_values(\%row);


    if ( @check_error ) {
        # on prend le premier message pour ne pas surcharger
        croak( shift @check_error);
    }
    
    # ouvrir la table en lecture/ecriture
    $self->_open_table_file(O_RDWR);

    # on stocke les lignes en memoire pour traitement (mode keepall)
    while ( defined ( my $row_hash_ref=$self->_get_file_row(1) )) {
        push @{ $self->{all_rows} }, $row_hash_ref;
    }

    # lance la mise à jour en mémoire
    my $update_key=$self->_updateall_rows(%row);

    #use Data::Dumper;die Dumper $self;

    # Si pas de mise à jour, alors erreur
    if (! defined $update_key) {
        croak(_t("Aucune ligne trouvee a remplacer"));   
    }
    # le fichier doit être modifié en entier
    else {
        if ( $update_key > 0 ) {
            $self->_writeall_rows();
        }
        else {
            #aucune valeur n'est modifiée
            $logger->debug("Aucune modification au fichier");
        }
    }

    # fermeture du fichier
    $self->close();

    return $update_key;
}


# ------------------------------------------
# Nom : Ft::insert_row
#
# Description :
# Ajoute une ligne dans la table. Si la ligne existe déjà, elle est remplacée
#
# Arguments :
#   hash de la forme COLONNE => VALEUR

# Retourne :
# ------------------------------------------
#override ITools_interface::insert_row
sub insert_row {
    my $self=shift;
    
    my %row = @_;

    # nettoie la ligne à inserer
    foreach my $field ( %row ) {
        # transforme les undef en chaine vide (pas de NULL en I-TOOLS)
        $field='' if not defined $field;
    }

    # lance la verification de coherence
    my @check_error = $self->check_row(%row);

    # Ajout des champs manquant
    foreach my $field ( $self->field() ) {
        if ( ! exists $row{$field} ) {
            $row{$field} = undef;
        }
    }

    # Ajout les valeurs par defaut
    $self->_set_default_values(\%row);

    if ( @check_error ) {
        # on prend le premier message pour ne pas surcharger
        croak( shift @check_error);
    }
    
    # ouvrir la table en lecture/ecriture
    $self->_open_table_file(O_RDWR);

    # on stocke les lignes en memoire pour traitement (mode keepall)
    while ( defined ( my $row_hash_ref=$self->_get_file_row(1) )) {
        push @{ $self->{all_rows} }, $row_hash_ref;
    }

    # on ne tente la mise à jour que si une clef est presente
    my $update_key;
    if ( $self->key() ) {
        # lance la mise à jour en mémoire
        $update_key=$self->_updateall_rows(%row);
    }

    #use Data::Dumper;die Dumper $self;

    # Si pas de mise à jour, alors insertion simple (append)
    if (! defined $update_key) {
        
        my @row_array = @row{ $self->field() };

        # transforme les undef en chaine vide
        map {$_='' if not defined $_} @row_array;

        # prepare la ligne à écrire
        my $new_line=join( $self->{define_obj}->separator() , @row_array );

        # si le ficher contient des données
        if ( -s $self->{select_descriptor} > 0 ) {

            # on prend le dernier caractère du fichier
            seek($self->{select_descriptor}, -1, 2)
                or die (_t("Impossible de se deplacer dans le fichier [_1] : [_2]",$self->{select_filename},$!));

            my $last_line = $self->_sysread_line();

            # on se repositionne à la fin au cas ou (cf MSWin32!)
            seek($self->{select_descriptor}, 0, 2)
                or die (_t("Impossible de se deplacer dans le fichier [_1] : [_2]",$self->{select_filename},$!));
            
            # y a-t-il un caractere de fin de ligne sur la derniere ligne?
            if ( $last_line !~ /\n$/ ) {
                $new_line = "\n".$new_line;
            }
        }

        $logger->debug("Insertion de la ligne en fin de fichier : $new_line");
        
        $self->_write_table_file($new_line."\n");
    }
    # le fichier doit être modifié en entier
    else {
        if ( $self->{force_insert} ) {
            if ( $update_key > 0 ) {
                $self->_writeall_rows();
            }
            else {
                #aucune valeur n'est modifiée
                $logger->debug("Aucune modification au fichier");
            }
        }
        else {
            croak(_t("Non unicite de la clef de la ligne a inserer"));
        }
    }

    # fermeture du fichier
    $self->close();

    return;
}


# ------------------------------------------
# Nom : Ft::delete_row
#
# Description :
# Ferme les descripteurs de fichiers ouverts
# Reinitialise les attributs de parcours
#
# ------------------------------------------
#override ITools_interface::delete_row
sub delete_row {
    my $self=shift;

    # ouvrir la table en lecture/ecriture
    $self->_open_table_file(O_RDWR);

    # on stocke les lignes en memoire pour traitement (mode keepall)
    my $delete_nb=0;
    my @all_rows;
    while ( defined ( my $row_hash_ref=$self->_get_file_row(1) )) {
        if ( ref $row_hash_ref ) {
            if ( $self->match_query_condition($row_hash_ref)) {
                $delete_nb++;
            }
            else {
                push @all_rows, $row_hash_ref;
            }
        }
        else {
            # supprime commentaires ?
            #push @all_rows, $row_hash_ref;
        }
    }

    # stocke la nouvelle table à écrire
    $self->{all_rows} = \@all_rows;

    if ( $delete_nb ) {
        $self->_writeall_rows();
    }
    else {
        $logger->debug("Aucune modification au fichier");
    }

    # fermeture du fichier
    $self->close();

    return $delete_nb;
}

# ------------------------------------------
# Nom : Ft::close
#
# Description :
# Ferme les descripteurs de fichiers ouverts
# Reinitialise les attributs de parcours
#
# ------------------------------------------
#override ITools_interface::close
sub close {
    my $self=shift;

    if ( $self->{select_descriptor} ) {
        $self->_close_table_file();
    }

    $self->{row_number}=undef;
    $self->{distinct_query_field}=undef;
    $self->{all_rows} = undef;
}

1;  # so the require or use succeeds

=head1 NAME

ITable::ITools::Ft is a wrapper class to ITools::DATA::ITools::Legacy

=head1 SYNOPSIS

 See ITable::ITools::Legacy
 
=cut
