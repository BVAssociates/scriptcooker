#    This file is part of ScriptCooker.
#
#    ScriptCooker is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    ScriptCooker is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with ScriptCooker.  If not, see <http://www.gnu.org/licenses/>.
#
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
package ScriptCooker::Define;
our $VERSION=2.1.0;

# -------
# Imports systemes
# -------
use strict;
use warnings;

use Carp qw( croak carp );
my $package = __PACKAGE__;
$Carp::Internal{$package} = 1;

use File::Spec;

# -------
# Imports libs
# -------
use ScriptCooker::Log 2.1.0 qw{$logger _t set_exit_code};
use ScriptCooker::Utils 2.1.0;

####################################################
## Decalaration de classe
####################################################

# Declaration des attributs
use fields qw{
    name

    deffile
    header
    type
    separator
    command
    file
    key
    field
    size
    row
    not_null
    sort

    no_fkey
    fkey
    fukey

    text_definition
    text_fkey

    read_ahead_data
};


####################################################
## Constructeur
####################################################

# ------------------------------------------
# Nom : Define::new
#
# Description :
# Constructeur de la classe Define
# En options, la clef "definition" permet de passer une definition
#   sous forme d'un hash variable => valeur
#
# Arguments :
#   - table_name : nom de la table a ouvrir
#   - options : options de creation sous forme d'une reference de hash
#
# Retourne :
#   - reference : objet de type Define
# ------------------------------------------
sub new (){
    my $self = shift;

    # créer un nouvel objet si non-hérité
    $self = fields::new($self) if ! ref $self;

    # gestion des arguments
    my $options;
    @_ = grep {defined} @_;
    if ( @_ == 2 ) {
        # arg1=name, arg2=options
        $self->{name} = shift;
        $options = shift;
    }
    elsif ( @_ == 1 ) {
        # arg1=name ou option
        $options = shift;
        if ( ! ref($options) ) {
            $self->{name} = $options;
            $options = undef;
        }
    }
    else {
        croak ("usage: ".__PACKAGE__."->new(tablename [, { definition => { SEP => '...', FORMAT => '...' } } ])");
    }

    # verification des options
    if ( defined $options && ! ref $options eq 'HASH' ) {
        croak ("usage: ".__PACKAGE__."->new(tablename [, { definition => { SEP => '...', FORMAT => '...' } } ])");
    }

    $self->{no_fkey} = $options->{no_fkey};

    # initialisation des attributs
    $self->{deffile} = undef;
    $self->{header} = undef;
    $self->{type} = "FT";
    $self->{separator} = "\t";
    $self->{command} = undef;
    $self->{file} = undef;
    $self->{key} = [];
    $self->{field}= [];
    $self->{size}= {} ;
    $self->{row} = {};
    $self->{not_null}= [];
    $self->{sort}= [];

    # format: $self->{fkey}->{$table}  = { $fkey1 => $key1 , $fkey2 => $key2 };
    $self->{fkey}= {};
    $self->{fukey}= {};

    # stockage des variables non-interpretées de la definition
    $self->{text_definition}= {};
    $self->{text_fkey}= [];

    # stockage de lignes de donnees "trop-lues" destinees au Select
    $self->{read_ahead_data}= [];

    # récuperation de la definition texte depuis le fichier .def
    if ( $self->{name} ) {
        $self->_read_file_definition();
    }
    else {
        $self->{name} = ':virtual';
    }

    # si rien n'a été récuperé, on teste les options
    if ( ! %{ $self->{text_definition} } ) {
        if ( ref $options->{definition} eq 'HASH' ) {

            # calcul de la definition texte depuis les options
            $self->_read_option_definition( $options->{definition} );
        }
        else {
            set_exit_code(203);
            croak(_t("La chaine de definition n'est pas valide ou est absente"));
        }
    }

    # calcul des structures de données depuis la definition texte
    $self->define();
    
    # Messages de debug
    $logger->debug("Fields : ", join($self->separator(),$self->field()),", Keys : ", join($self->separator(),$self->key()));

    #$logger->dump($self);

    # retourne l'objet
    return $self;
}

##############################################
## Accesseurs
##############################################


# ------------------------------------------
# Nom : Define::header
#
# Description :
# Enregistre et retourne l'entete de la table
#
# Arguments :
#   - header : si defini, enregistre le nouveau champs header
#
# Retourne :
#   - scalaire : texte evalué du champs header
# ------------------------------------------
sub header {
    my $self = shift;
    if (@_) { $self->{header} = shift }
    return evaluate_variables($self->{header});
}

# ------------------------------------------
# Nom : Define::name
#
# Description :
# Retourne le nom de la table
#
# Retourne :
#   - scalaire : nom de la table
# ------------------------------------------
sub name {
    my $self = shift;
    if (@_) { croak("'name' member is read-only") }
    return $self->{name};
}

# ------------------------------------------
# Nom : Define::type
#
# Description :
# Retourne le type de la table
#
# Retourne :
#   - scalaire : type de la table
# ------------------------------------------
sub type {
    my $self = shift;
    if (@_) { croak("'type' member is read-only") }
    return $self->{type};
}

# ------------------------------------------
# Nom : Define::separator
#
# Description :
# Enregistre et retourne le separateur de colonne de la table
#
# Arguments :
#   - separator : si defini, enregistre le nouveau separateur
#
# Retourne :
#   - scalaire : separateur de la table
# ------------------------------------------
sub separator {
    my $self = shift;
    if (@_) {
        my @temp_sep = grep {$_} @_;
        my $sep = shift @temp_sep;

        if ( ! $sep ) {
            croak(_t("Un séparateur ne peut pas être vide"));
        }

        $self->{separator} = $sep;
    }

    return $self->{separator};
}


# ------------------------------------------
# Nom : Define::def_file
#
# Description :
# Enregistre et retourne le chemin vers le fichier .def
#
# Arguments :
#   - deffile : si defini, enregistre le nouveau chemin vers le fichier .def
#
# Retourne :
#   - scalaire : chemin vers le fichier .def
# ------------------------------------------
sub def_file {
    my $self = shift;
    if (@_) { $self->{deffile} = shift }
    return $self->{deffile};
}

# ------------------------------------------
# Nom : Define::command
#
# Description :
# Retourne la commande de la table
#
# Retourne :
#   - scalaire : commande de la table
# ------------------------------------------
sub command {
    my $self = shift;
    if (@_) { croak("'command' member is read-only") }
    return $self->{command};
}

# ------------------------------------------
# Nom : Define::file
#
# Description :
# Retourne le chemin des données de la table
# Si nécéssaire evalue la valeur
#
# Retourne :
#   - scalaire : chemin des données de la table
# ------------------------------------------
sub file {
    my $self = shift;
    if (@_) { croak("'file' member is read-only") }

    my $file;
    if (defined $self->{file} ) {

        # calcul de l'attribut file sans backticks
        $file = evaluate_variables( $self->{file} );

        # nettoie les backticks
        my $evalued_file_call = $file;
        $evalued_file_call =~ s/^\$\((.*)\)$/$1/g;
        $evalued_file_call =~ s/^\`(.*)\`$/$1/g;

        # optmisation sur les cas classiques
        if ( $evalued_file_call =~ /^Search_File\s+-t\s+(\w+)$/ ) {
            $file = search_file($1, {type => 'tab'} );
        }
        elsif ( $evalued_file_call =~ /^Search_File\s+(\w+)\.pci$/ ) {
            $file = search_file($1, { type => 'pci'} );
        }
        elsif ( $evalued_file_call =~ /^Search_File\s+\.pci$/ ) {
                croak(_t("Problème lors de l'execution de [_1]",$evalued_file_call));
        }

        if ( ! $file ) {
            croak(_t("L'evaluation de <[_1]> est incorrecte !",sprintf('`%s`',$evalued_file_call)));
        }

        # reevalue avec activation des backticks
        $file = evaluate_variables( $file, { backticks => 1} );
    }


    return $file;
}

# ------------------------------------------
# Nom : Define::key
#
# Description :
# Retourne la liste des clefs primaires
#
# Arguments :
#   - keys : si defini, enregistre la nouvelle liste des clefs primaire
#
# Retourne :
#   - tableau : liste des clefs primaires
# ------------------------------------------
sub key {
    my $self = shift;
    if (@_) { @{ $self->{key} } = @_ }
    return @{ $self->{key} };
}

# ------------------------------------------
# Nom : Define::field
#
# Description :
# Retourne les colonnes de la table
#
# Arguments :
#   - fields : si defini, enregistre la nouvelle liste de colonnes
#
# Retourne :
#   - tableau : liste des colonnes
# ------------------------------------------
sub field {
    my $self = shift;
    if (@_) { @{ $self->{field} } = @_ }
    return @{ $self->{field} };
}

# ------------------------------------------
# Nom : Define::size
#
# Description :
# Retourne les tailles et type de colonnes
#
# Arguments :
#   - sizes : si defini, enregistre la nouvelle liste de taille
#       sous forme d'un hash colonnes=>tailles (format .def)
#
# Retourne :
#   - dictionnaire : colonnes=>tailles
# ------------------------------------------
sub size {
    my $self = shift;
    if (@_) { %{ $self->{size} } = @_ }
    return %{ $self->{size} };
}

# ------------------------------------------
# Nom : Define::row
#
# Description :
# Retourne les variables ROW
#
# Arguments :
#   - rows : si defini, enregistre la nouvelle liste de variables
#       sous forme d'un hash colonnes=>variables (format .def)
#
# Retourne :
#   - dictionnaire : colonnes=>variables
# ------------------------------------------
sub row {
    my $self = shift;
    if (@_) { @{ $self->{row} } = grep {$_} @_ }
    return %{ $self->{row} };
}

# ------------------------------------------
# Nom : Define::not_null
#
# Description :
# Retourne la liste des colonnes NOTNULL
#
# Arguments :
#   - not_nulls : si defini, enregistre la nouvelle liste de colonnes NOTNULL
#
# Retourne :
#   - tableau : liste des colonnes NOTNULL
# ------------------------------------------
sub not_null {
    my $self = shift;
    if (@_) { @{ $self->{not_null} } = grep {$_} @_ }
    return @{ $self->{not_null} };
}

# ------------------------------------------
# Nom : Define::fkey
#
# Description :
# Retourne la liste des clefs étrangères
#   au format: table => { $fkey1 => $key1 , $fkey2 => $key2 };
#
# Arguments :
#   - fkeys : si defini, enregistre le nouveau dictionnaire décrivant
#       les FKEY
#
# Retourne :
#   - dictionnaire : table => { $fkey1 => $key1 , $fkey2 => $key2 }
# ------------------------------------------
sub fkey {
    my $self = shift;
    if (@_) { %{ $self->{fkey} } = grep {$_} @_ }

    # copie en profondeur les structures
    my %all_fkey;
    foreach my $table ( keys %{ $self->{fukey} } ) {
        %{ $all_fkey{$table} }=%{ $self->{fukey}->{$table} }
    }
    foreach my $table ( keys %{ $self->{fkey} } ) {
        %{ $all_fkey{$table} }=%{ $self->{fkey}->{$table} }
    }

    return %all_fkey;
}

# ------------------------------------------
# Nom : Define::fukey_table
#
# Description :
# Retourne la liste des tables contenant une clef étrangère unique
#   (ie. sur les clefs de la table courante)
#
# Arguments :
#
# Retourne :
#   - scalaire : table
# ------------------------------------------
sub fukey_table {
    my $self = shift;
    if (@_) {
        croak(_t("usage: [_1]",'ScriptCooker::Define->fukey_table()'));
        croak(_t("usage: [_1]",'ScriptCooker::Define->fukey_table()'));
    }

    my @fukey_list = keys %{ $self->{fukey} };

    return shift @fukey_list;
}

# ------------------------------------------
# Nom : Define::sort
#
# Description :
# Retourne la liste des colonnes participant au tri
# Chaque colonne est du type COLONNE [ASC|DESC]
#
# Arguments :
#   - sorts : si defini, enregistre la nouvelle liste de tri
#
# Retourne :
#   - tableau : liste de colonnes participant au tri
# ------------------------------------------
sub sort {
    my $self = shift;
    if (@_) { @{ $self->{sort} } = grep {$_} @_ }
    return @{ $self->{sort} };
}


# ------------------------------------------
# Nom : Define::path_separator
#
# Description :
# Retourne le caractere separateur de PATH
#
# Retourne :
#   - scalaire : caractere
# ------------------------------------------
sub path_separator {
    my $self = shift;

    my $path_separator=':';
    if ( $^O eq 'MSWin32' ) {
        $path_separator=';';
    }
    
    return $path_separator;
}


##############################################
## Méthodes privées
##############################################

# ------------------------------------------
# Nom : Define::_set_definition_var
#
# Description :
# Ajoute un couple variable/valeur représentant une variable
#   d'un définition dans la structure $self->{text_definition}
# Sors en erreur en cas de doublon
#
# Arguments :
#   - var_name : nom de la variable
#   - value    : contenu de la variable
# ------------------------------------------
sub _set_definition_var {
    my $self=shift;

    my $var_name=shift;
    my $value = shift;

    if (! defined $value) {
        croak("usage: _set_definition_var(var,value)");
    }

    if ( $ENV{IT20_COMPLIANT} ) {
        # mode compatibilité : aucune verification
        $self->{text_definition}->{$var_name} = $value;
    }
    else {
        if ( exists $self->{text_definition}->{$var_name} ) {
            croak(_t("La definition [_1] est present plusieurs fois dans [_2]",$var_name,$self->def_file() ));
        }
        else {
            $self->{text_definition}->{$var_name} = $value;
        }
    }

    return;
}

# ------------------------------------------
# Nom : Define::_sysread_line
#
# Description :
# Lit une ligne de l'entrée standard sans utiliser de buffer,
#   afin de laisser les données non lues sur le descripteur
#
# Arguments :
#
# Retourne :
#   - scalaire : ligne lue
# ------------------------------------------
sub _sysread_line {
    my $self=shift;

    my $raw_line="";

    while (1) {
        my $char;

        my $read_result=sysread( STDIN, $char, 1);
        if ( ! defined $read_result ) {
            die(_t("Probleme de lecture de STDIN"));
        }
        elsif( ! $read_result ) {
            # EOF
            last;
        }
        elsif ( $char eq "\n" ) {
            $raw_line.=$char;
            last;
        }
        else {
            $raw_line.=$char;
        }
    }
    return $raw_line;
}


# ------------------------------------------
# Nom : Define::_read_option_definition
#
# Description :
# Lit une definition passée en paramètre
#
# Arguments :
#   - definition : référence sur un dictionnaire contenant les variables
#       attendue dans une définition
#
# Retourne :
# ------------------------------------------
sub _read_option_definition {
    my $self=shift;
    my $definition = shift;

    if ( ref $definition ne 'HASH' ) {
        die("usage: _read_option_definition( { VAR => value, ...} )");
    }

    # configuration des mots clefs attendus
    my @allowed_var_list= qw(
                    SEP
                    HEADER
                    KEY
                    FORMAT
                    ROW
                    SIZE
                );

    my %temp_definition = %{ $definition };
    foreach my $var ( @allowed_var_list ) {

        if ( exists $temp_definition{$var} ) {

            $self->{text_definition}->{$var}
                = delete $temp_definition{$var}
        }
    }

    my @unknown_var = keys %temp_definition;
    if ( @unknown_var ) {
        croak(_t("Les variables suivantes ne sont pas des définitions valides : [_1]",join(',',@unknown_var) ));
    }

    return;
}

# ------------------------------------------
# Nom : Define::_read_file_definition
#
# Description :
# Lit une definition dans un fichier .def ou sur l'entree standard
#
# Arguments :
#
# Retourne :
# ------------------------------------------
sub _read_file_definition {
    my $self = shift;

    # configuration des mots clefs attendus
    my @allowed_var_list= qw(
                    SEP
                    HEADER
                    TYPE
                    COMMAND
                    FILE
                    KEY
                    FORMAT
                    SORT
                    ROW
                    SIZE
                    NOTNULL
                );


    my @definition_array;

    if ( $self->{name} eq '-' ) {

        # lit la premiere ligne de l'entree standard
        my $definition_row = $self->_sysread_line();

        # rien sur STDIN
        if ( ! $definition_row ) {
            return;
        }

        # remove EOL (OS dependant)
        chomp $definition_row;

        # separateur en dur
        @definition_array = split(/@@/, $definition_row);

        if ( @definition_array <= 1 ) {
            # la definition ne semble pas correcte, on garde les donnees de coté
            push @{ $self->{read_ahead_data} }, $definition_row;

            # inutile de continuer, l'entete ne contient pas definition
            return;
        }
        else {
            # le definition est correcte, on stocke la source de la definition
            $self->def_file('-');
        }
    }
    else {
        if ( $ENV{IT20_COMPLIANT} ) {
            # en mode compatibilité, Define_Table table.def est toléré
            my $temp_name=$self->{name};
            $temp_name =~ s/\.def$//;
            $self->def_file(search_file($temp_name, {type => "def"} ));
            if ( ! $self->def_file() ) {
                croak(_t("Impossible de trouver ou d'ouvrir le fichier de definition [_1]", $temp_name.".def"));
            }
        }
        else {
            $self->def_file(search_file($self->{name}, {type => "def"}));
            if ( ! $self->def_file() ) {
                croak(_t("Impossible de trouver ou d'ouvrir le fichier de definition [_1]", $self->{name}.".def"));
            }
        }
        
        my $define_descriptor;
        open $define_descriptor, '<', $self->def_file()
            or croak(_t("Impossible d'ouvrir le fichier [_1] en lecture : [_2]",$self->def_file,$!));

        while(my $line=<$define_descriptor>) {

            # retire les espaces en trop
            $line =~ s/^\s*//;

            # Comments
            next if $line =~ /^#/;
            # Empty lines
            next if $line =~ /^\s*$/;

            # remove EOL (OS dependant)
            chomp $line;

            
            push @definition_array, $line;
        }

        close $define_descriptor
            or croak(_t("Impossible de fermer le fichier [_1] : [_2]",$self->def_file,$!));
    }

    # converti les lignes en tableau de hashage

    # parse output
    my $rex_separator;

    # precompilation des expressions regulieres
    my $rex_after      = q/\s*=\s*(['"]?)(.*)\2\s*$/;
    my $rex_after_call = q/\s*=\s*(([`]).*\3)\s*$/; #capture ` pour test
    my $var_list_regex='('.join('|', @allowed_var_list).')';
    

    # premier passage pour récuperer le separateur
    my ($separator_definition) = 
                grep {/^\s*(SEP)${rex_after}/ } @definition_array;

    if ( defined $separator_definition ) {
        $separator_definition =~ /^\s*(SEP)${rex_after}/;
        $self->{separator} = $2;
    }

    # separateur par defaut
    if ( ! $self->{separator} ) {
        $self->{separator}="\t";
    }

    # prepare I-TOOLS separator
    $rex_separator = quotemeta($self->{separator});
    if ( $ENV{IT20_COMPLIANT} ) {
        # en mode compatibilité, la virgule est toléré comme separateur universel
        $rex_separator = qr/(?:$rex_separator|,)/;
    }


    foreach ( @definition_array ) {
        

        # attributs simples        
        if (    /^${var_list_regex}${rex_after}/ ) {
            $self->_set_definition_var($1,$3);
        }
        elsif ( /^(FILE)${rex_after_call}/ ) {
            $self->_set_definition_var('FILE',$2);
        }


        # cas special des FKEY
        elsif ( /^(FKEY)${rex_after}/ ) {
            push @{ $self->{text_fkey} }, $3
        }
        
        else {
            croak(_t("La definition suivante est incorrecte: [_1]",$_));
        }
        
    }


    return;
}

##############################################
## Méthode publiques
##############################################


# ------------------------------------------
# Nom : Define::define
#
# Description :
# Calcule et vérifie la structure de donnée de l'objet à partir de la definition texte
#   contenu dans $self->{text_definition}
#
# Arguments :
#
# Retourne :
# ------------------------------------------
sub define() {
    my $self = shift;

    $logger->debug("Define_Table $self->{name}");
    
    # configuration des variables obligatoire pour une definition
    my @mandatory_var_list = qw(
                    SEP
                    FORMAT
                );

    foreach my $var ( @mandatory_var_list ) {
        if ( ! exists $self->{text_definition}->{$var} ) {
            croak(_t("La chaine de definition [_1] n'est pas valide ou est absente",$var));
        }
    }

    # Temp vars
    my @size_array;
    my $rex_separator;

    # récupération des variables simples
    if ( defined $self->{text_definition}->{SEP} ) {
        $self->{separator} = $self->{text_definition}->{SEP};
    }

    if ( defined $self->{text_definition}->{FILE} ) {
        $self->{file} = $self->{text_definition}->{FILE};
    }

    if ( defined $self->{text_definition}->{COMMAND} ) {
        $self->{command} = $self->{text_definition}->{COMMAND};
    }

    if ( defined $self->{text_definition}->{TYPE} ) {
        $self->{type} = $self->{text_definition}->{TYPE};
    }

    if ( defined $self->{text_definition}->{HEADER} ) {
        $self->{header} = $self->{text_definition}->{HEADER};
    }

    # variable contenant potentiellements des variables shells
    $self->{header}  = evaluate_variables( $self->{header} );

    # première verification
    if ( $self->{text_definition}->{COMMAND}
            && $self->{text_definition}->{FILE} )
    {
        croak(_t("Les champs COMMAND et FILE sont mutuellement exclusifs"));
    }

    # separateur par defaut
    if ( ! $self->{separator} ) {
        $self->{separator}="\t";
    }

    # prepare I-TOOLS separator
    $rex_separator = quotemeta($self->{separator});
    if ( $ENV{IT20_COMPLIANT} ) {
        # en mode compatibilité, la virgule est toléré comme separateur universel
        $rex_separator = qr/(?:$rex_separator|,)/;
    }

    # message d'information en mode IT20_COMPLIANT
    foreach my $var ( qw (FORMAT SIZE ROW KEY NOTNULL SORT) ) {

        my $list_values = $self->{text_definition}->{$var};
        next if ! defined $list_values;

        # attribut découpés par le separateur automatique ','
        if ( $list_values =~ /,/ && $self->{separator} !~ /,/ ) {

            $logger->info(_t("Le separateur implicite implicite ',' ne sera plus pris en charge dans la prochaine version des I-TOOLS : [_1] ([_2])",
                                            $self->name(),
                                            "$var=$list_values",
                                        ));
        }
    }

   # interpretation du FORMAT
   if ( my $list_values=$self->{text_definition}->{FORMAT} ) {
       $self->{field} = [ split(/\s*$rex_separator\s*/, $list_values) ];
   }

   # interpretation du SORT
   if ( my $list_values=$self->{text_definition}->{SORT} ) {
       $self->{sort} = [ split(/\s*$rex_separator\s*/, $list_values) ];
   }

   # interpretation du KEY
   if ( my $list_values=$self->{text_definition}->{KEY} ) {
       $self->{key} = [ split(/\s*$rex_separator\s*/, $list_values) ];
   }

   # interpretation du NOTNULL
   if ( my $list_values=$self->{text_definition}->{NOTNULL} ) {
       $self->{not_null} = [ split(/\s*$rex_separator\s*/, $list_values) ];
   }

   # interpretation du ROW
    if ( my $list_values=$self->{text_definition}->{ROW} ) {

        # get field's rows
        if ( $list_values ) {
            my @row_array = split(/\s*$rex_separator\s*/, $list_values);

            # stockage dans un hash (champ => variable)
            foreach my $field ( $self->field() ) {

                # aucun contrôle si mode de compatibilité activé
                if ( ! @row_array && ! $ENV{IT20_COMPLIANT}) {
                    croak(_t("La definition [_1] n'a pas assez de valeur","ROW"));
                }

                $self->{row}->{$field} = shift @row_array;
            }
            if ( @row_array && ! $ENV{IT20_COMPLIANT} ) {
                croak(_t("La definition [_1] a trop de valeur","ROW"));
            }
        }
    }
    else {
        # construction d'un ROW générique
        foreach my $field ( $self->field() ) {
            $self->{row}->{$field} = format_env_vars($field);
        }
    }

    # interpretation du SIZE
    if ( my $list_values=$self->{text_definition}->{SIZE} ) {

        my @size_array =  split(/\s*$rex_separator\s*/, $list_values);

        # stockage dans un hash (champ => size)
        foreach ( $self->field() ) {
            if ( ! @size_array ) {
                croak(_t("La definition [_1] n'a pas assez de valeur","SIZE"));
            }
            
            my $size = shift @size_array;

            if ( $size !~ /^\d+[snpbd]/) {
                croak(_t("La definition [_1] est mal formée : [_2]","SIZE",$size));
            }
        
            $self->{size}->{$_} = $size;
        }
        if ( @size_array ) {
            croak(_t("La definition [_1] a trop de valeur","SIZE"));
        }
    }
    else {
        # construction d'un ROW générique
        foreach my $field ( $self->field() ) {
            $self->{size}->{$field} = '20s';
        }
    }

    # interpretation du FKEY
    if ( ! $self->{no_fkey} ) {
        foreach my $fkey_line ( @{ $self->{text_fkey} } ) {


            # analyse des relations
            if ( $fkey_line =~ /^ \[\s*(.+)\s*\]\s+
                                    on
                                    \s+(.+)\s*\[\s*(.+)\s*\]$/x )
            {
                my @field_list         = split('\s*,\s*', $1);
                my $foreign_table      = $2;
                my @foreign_field_list = split('\s*,\s*', $3);

                #TODO inutile si non IT20_COMPLIANT ?
                if ( exists $self->{fukey}->{$foreign_table}
                    || exists $self->{fkey}->{$foreign_table} )
                {
                    croak(_t("La table [_1] existe sous plusieurs cles etrangeres.",$foreign_table));
                }

                # ouverture de la definition de la table liee
                #  emettra une exception si la table n'existe pas
                my $foreign_table_def = ScriptCooker::Define->new( $foreign_table, { no_fkey => 1} );

                # verification du nombre de colonnes
                if ( @field_list != @foreign_field_list ) {
                    croak(_t("La cle de reference de la contrainte sur [_1] est incorrecte.",$foreign_table));
                }

                # reformatage de la ligne
                $fkey_line = sprintf("[%s] on %s[%s]",
                                                join(',',@field_list),
                                                $foreign_table,
                                                join(',',@foreign_field_list),
                                            );

                # determination de l'aspect "unique" si FKEY=KEY
                my $fkey_attr='fkey';
                if (   join(',',sort @field_list)
                    eq join(',',sort $self->key()) )
                {
                    $fkey_attr='fukey';
                }

                # verification des colonnes de la table
                my @foreign_field_list_copy = @foreign_field_list;
                foreach my $field ( @field_list ) {

                    # verification de l'existence de la colonne
                    if ( grep { $_ eq $field } $self->field() ) {
                        $self->{$fkey_attr}->{$foreign_table}->{$field} = shift @foreign_field_list_copy;
                    }
                    else {
                        croak(_t("La colonne [_1] n'existe pas",$field));
                    }
                }

                # verification des colonnes de clefs etrangeres

                foreach my $field ( @foreign_field_list ) {
                    if ( ! grep {$_ eq $field} $foreign_table_def->field() ) {
                        croak(_t("La colonne [_1] (Table [_2]) n'existe pas",$field,$foreign_table));
                    }
                }

            }
            else {
                croak(_t("La contrainte [_1] est invalide !",$fkey_line));
            }
       }
    }
        

 
    # optimisation COMMAND="Select -s from Table"
    if ( $self->{command} and 
            $self->{command} =~ /^\s*Select\s+\-s\s+\*?\s*from\s+(\S+)\s*$/i )
    {
        $self->{file}    = search_file($1, {type => "tab"} );
        $self->{command} = undef;
    }
    
    # default table when no COMMAND neither FILE
    if ( ! $self->{command} and ! $self->{file} ) {
        if ( $self->{name} eq '-' ) {
            $self->{file}= '-';
        }
        else {
            $self->{file}=search_file($self->{name} , {type => "tab"} );
        }
    }
    
    if ( ! $ENV{IT20_COMPLIANT} ) {
        # en mode compatibilité les I-TOOLS n'emettent aucun avertissement
        if ( ! $self->{file} and ! $self->{command} ) {
            carp(_t("Impossible d'obtenir la source de donnée de [_1]",$self->{name}));
        }
    }

    return;
    
}


# ------------------------------------------
# Nom : Define::describe
#
# Description :
# Retourne un dictionnaire contenant la structure de la definition reformatée
#   et vérifiée. Ce dictionnaire sera utilisable par des fonctions exterieures.
#
# Arguments :
#
# Retourne :
#   - dictionnaire : type variable => valeur
# ------------------------------------------
sub describe()
{
    my $self = shift;

    my %attr_for_var = (
            DEFFILE => "deffile",
            TABLE => "name",
            HEADER => "header",
            TYPE => "type",
            SEP => "separator",
            FILE => "file",
            COMMAND => "command",
            FORMAT => "field",
            SIZE => "size",
            ROW => "row",
            KEY => "key",
            NOTNULL => "not_null",
            SORT => "sort",
        );

    # variable qui stocke le dictionnaire a renvoyer
    my %description;

    foreach my $env_var ( keys %attr_for_var ) {
        my $attr      = $attr_for_var{$env_var};
        my $env_value = $self->{$attr};

        # valeurs par defaut
        my $output_separator= $self->separator();

        # IT20_COMPLIANT: renvoie des lignes sans changement
        if ( $ENV{IT20_COMPLIANT} ) {
            if ( $attr eq 'row' && $self->{text_definition}->{ROW} ) {
                $env_value = $self->{text_definition}->{ROW};
            }
            elsif ( $attr eq 'file' && $self->{text_definition}->{FILE} ) {
                $env_value = $self->{text_definition}->{FILE};
            }
        }

        # séparateur special pour SORT
        if ( $attr eq 'sort' ) {
            $output_separator=',';
        }

        # evalue le contenu de HEADER
        if ( $attr eq 'header' ) {
            $env_value = evaluate_variables($env_value);
        }

        if ( !defined $env_value) {
            $env_value="";
        }
        elsif (ref($env_value) eq 'ARRAY') {
            $env_value=join( $output_separator, @{ $env_value } );
        }
        elsif (ref($env_value) eq 'HASH') {
            my %hash = %{ $env_value };
            $env_value=join( $output_separator, @hash{ $self->field() } );
        }

        $description{$env_var} = $env_value;
    }

    # cas particulier des FUKEY
    my $fkey_count=1;
    foreach my $fkey ( @{ $self->{text_fkey} } ) {

        # pour simplifier, on renvoie la ligne texte
        my ($ftable) = ($fkey =~ /on (\w+)/);

        if ( ! exists $self->{fukey}->{$ftable} ) {
            next;
        }

        my $key_name = sprintf("FUKEY%02d",$fkey_count++);
        $description{$key_name} = $fkey;
    }

    $fkey_count=1;
    foreach my $fkey ( @{ $self->{text_fkey} } ) {

        # pour simplifier, on renvoie la ligne texte
        my ($ftable) = ($fkey =~ /on (\w+)/);

        if ( ! exists $self->{fkey}->{$ftable} ) {
            next;
        }

        my $key_name=sprintf("FKEY%02d",$fkey_count++);
        $description{$key_name} = $fkey;
    }

    return %description;
}


1;  # so the require or use succeeds



=head1 NAME

ScriptCooker::Define - Classe de traitement des fichiers de definition

=head1 SYNOPSIS

 use ScriptCooker::Define 2.1.0;

 # object creation from file
 $definition = ScriptCooker::Define->new("table_name");

 # object creation from STDIN
 $definition = ScriptCooker::Define->new("-");

 # object creation from STDIN with fallback
 $definition = ScriptCooker::Define->new("-", { 
                                    definition => { 
                                        SEP=',', 
                                        FORMAT='FIELD1,FIEDL2,
                                        }
                                    });
 
 # object creation sans traiter les FKEYs
 $definition = ScriptCooker::Define->new("table_name", { no_fkey => 1 });

 # recuperation des informations
 $file  = $definition->file();
 @field = $definition->field();
 %size  = $definition->size();

 %description = $definition->describe();

=head1 DESCRIPTION

Classe de lecture et d'analyse des fichiers de definitions.

=head1 AUTHOR

Copyright (c) 2011 BV Associates. Tous droits réservés.

=cut
