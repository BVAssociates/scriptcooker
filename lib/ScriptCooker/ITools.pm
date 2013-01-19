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
# Copyright (c) 2010, BV Associates. Tous droits reserves.
# ------------------------------------------------------------
#
# $Revision: 449 $
#
# ------------------------------------------------------------
#
# Description : Module ITools
# Date :        26/06/2009
# Auteur :      V. Bauchart
# Projet :      I-TOOLS
#
# ------------------------------------------------------------
#
# Historique des modifications
#
# $Log: ITools.pm,v $
# Revision 1.1.2.2  2010/02/12 16:55:24  tz
# Mise aux normes.
# Version du module : 1.0.0.
#
#
# ------------------------------------------------------------
# Declaration du package
package ScriptCooker::ITools;

# Verification de la version de PERL : 5.8 minimum
use 5.008;

# -------
# Imports
# -------
use strict;
use warnings;

use Carp;
my $package = __PACKAGE__;
$Carp::Internal{$package} = 1;

use File::Basename;

use ScriptCooker::ITable 2.1.0;
use ScriptCooker::Define 2.1.0;
use ScriptCooker::Pci    2.1.0;
use ScriptCooker::Log    2.1.0 qw($logger _t);
use ScriptCooker::Utils  2.1.0 qw(
                evaluate_variables
                sub_getopt
            );

# ------------------
# Variables globales
# ------------------
our (@ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

our $VERSION = 2.1.0;

# -------------------------
# Section de chargement
# Declaration des "exports"
# -------------------------
BEGIN {
    require Exporter;
    @ISA = qw(Exporter);

    # Fonctions exportees
    @EXPORT = qw(
        set_debug_mode
        is_debug_mode

        set_exit_code
        get_exit_code
        script_exit

        log_start
        log_end
        log_error
        log_warning
        log_info
        log_debug

        check_table
        define_table

        select_from_pci

        select_from_table
        insert_into_table
        replace_into_table
        remove_from_table

        read_row
        read_row_line
        write_row_line
    );

    @EXPORT_OK = @EXPORT;

    %EXPORT_TAGS = (
                     LOG => [qw (
                            log_start
                            log_end
                            log_error
                            log_warning
                            log_info
                            log_debug
                     )],
                     SELECT => [qw(
                            define_table
                            select_from_pci
                            select_from_table
                     )],
                     UPDATE => [qw(
                            insert_into_table
                            replace_into_table
                            remove_from_table
                     )],
    );

    # Export BV_PROC
    if(defined $ENV{BV_PROC} && $ENV{BV_PROC} ne "") {
        $ENV{BV_PROC} = $ENV{BV_PROC}.$ENV{BV_PROC_SEP}.basename($0);
    }
    else {
        $ENV{BV_PROC} = basename($0);
    }
} 


# ---------------------
# Gestion du mode debug
# ---------------------

# ------------------------------------------
# Nom : set_debug_mode
#
# Description :
# Permet de definir le mode debug, lequel active l'affichage des messages
# de debug.
#
# Arguments :
#  - Arg1 : Le niveau de debug. A l'heure actuelle : 1 = actif, 0 = inactif
# ------------------------------------------
sub set_debug_mode {
    return ScriptCooker::Log::set_debug_mode(@_);
}

# ------------------------------------------
# Nom : is_debug_mode
#
# Description :
# Permet de savoir si le mode debug est actif ou non.
#
# Retourne : true si le mode debug est actif, false sinon.
# ------------------------------------------
sub is_debug_mode {
    return ScriptCooker::Log::is_debug_mode(@_);
}

# ---------------------------------------------------
# Gestion du code de sortie du script et de la sortie
# ---------------------------------------------------

# ------------------------------------------
# Nom : get_exit_code
#
# Description :
# Permet de recuperer le code de sortie du script.
#
# Retourne : Le code de sortie qui sera utilise.
# ------------------------------------------
sub get_exit_code {
    return ScriptCooker::Log::get_exit_code();
}

# ------------------------------------------
# Nom : set_exit_code
#
# Description :
# Permet de positionner le code de sortie du script. Ce code de sortie sera
# utilise lors de la sortie effective du script.
# Positionne egalement la variable d'environnement BV_SEVERITE a la valeur
# du code de sortie (pour compatibilite).
#
# Arguments :
#  - Arg1 : Le code de sortie.
# ------------------------------------------
sub set_exit_code {
    return ScriptCooker::Log::set_exit_code(@_);
}

# ------------------------------------------
# Nom : script_exit
#
# Description :
# Termine le script avec un code de retour.
# Cette fonction ne devrait pas etre utilisee dans un script.
#
# Arguments :
#  - Arg1 : Le code de sortie du script.
# ------------------------------------------
# Termine le programme avec un code retour
sub script_exit {
    my $exit_code = shift;

    if ( defined $exit_code && $exit_code !~ /^\d+$/ ) {
        croak('usage : script_exit($exit_code)');
    }


    # Message informatif car script_exit() ne peut pas etre "attrape" par un 
    # eval {}
    if ( caller(1) ) {
        warn "script_exit() ne devrait pas etre utilise dans une fonction";
    }

    # Test du code retour
    if ( ! defined $exit_code) {
        exit;
    }
    else {
        set_exit_code($exit_code);
        croak(_t("Sortie forcee en erreur"));
    }
}

# ----------------
# Fonctions de log
# ----------------

# ------------------------------------------
# Nom : log_start
#
# Description :
# Fonction chargee d'effectuer un enregistrement de debut d'execution.
# ------------------------------------------
sub log_start {
    $logger->notice(_t("Debut du traitement de [_1]", $ENV{BV_PROC}));

    return 1;
}

# ------------------------------------------
# Nom : log_end
#
# Description :
# Fonction chargee d'effectuer un enregistrement de fin d'execution.
# ------------------------------------------
sub log_end {

    my $message;
    my $code = get_exit_code();

    if ( $code == 201) {
            $message = _t("Fin en warning du processus numero [_1] de nom [_2]", $ENV{BV_PROC}, $$ );
    }
    elsif ( $code != 0) {
            $message = _t("Fin anormale du processus numero [_1] de nom [_2]", $ENV{BV_PROC}, $$ );
    }
    else {
            $message = _t("Fin normale du processus numero [_1] de nom [_2]", $ENV{BV_PROC}, $$ );
    }

    $logger->notice($message);
    return 1;
}


# ------------------------------------------
# Nom : _get_message
#
# Description :
# Analyse les arguments et construit le message à logger
# Positionne le code retour du programme
#
# Arguments :
#  - Arg1..n : Message
#  - Argm : Reference sur un hash pour les options :
#    * severity : La severite
#    * error_number : Le numero d'erreur
#
# Retourne : le message traduit
# ------------------------------------------
sub _get_message {
    if ( @_ < 1 ) {
        croak(_t("usage: [_1]",'_get_message(@message[,$options])'));
    }

    my $log_usage = 'log_*(@message, { severity => int, error_number => int } )';

    # Analyse des arguments
    my $options = pop @_;
    my @messages = @_;

    # Initialisation
    my $severity;
    my $error_number;

    # Analyse des options (if any)
    if ( ref($options) eq 'HASH' ) {

        sub_getopt($options, { severity => \$severity, error_number => \$error_number });

        if ( $error_number !~ /^\d*$/ ) {
            croak(_t("usage: [_1]",$log_usage));
        }
    }
    else {
        # Si pas d'option, on le remet dans le message
        push @messages, $options;
    }

    if ( defined $severity ) {
        set_exit_code($severity);
    }

    # recherche dans la table error_messages
    my $function = $ENV{BV_PROC};

    my $format;
    my $format_generic;
    if ( defined $error_number ) {
        my $error_messages = ScriptCooker::ITable->open("error_messages");
        #TODO utiliser les conditions ITable
        $error_messages->query_condition("Error = $error_number");

        while (my %message = $error_messages->fetch_row() ) {

            if (defined $function && $function eq $message{Function}) {
                # message d'erreur trouvé
                $format = $message{Message};
                last;
            }
            elsif ($message{Function} eq 'generic') {
                # on garde le message generic au cas ou
                $format_generic = $message{Message};
            }

        }
        $error_messages->close();

        if ( ! defined $format ) {
            if ( defined $format_generic) {
                $format = $format_generic;
            }
            else {
                croak(_t("Numero d'erreur [_1] non reference.",$error_number));
            }
        }

        # travail sur le message
        $format = evaluate_variables($format);
    }

    my $message;
    if ( defined $format ) {
        $message = sprintf ( $format, @messages);
    }
    else {
        $message = join(' ', @messages);
    }

    return $message;
}

# ------------------------------------------
# Nom : log_error
#
# Description :
# Fonction chargee d'effectuer un enregistrement d'erreur.
#
# Termine le script en erreur (die) a l'issue de l'enregistrement.
#
# Arguments :
#  - Arg1..n : Message
#  - Argm : Reference sur un hash pour les options :
#    * severity : La severite
#    * error_number : Le numero d'erreur
# ------------------------------------------
sub log_error {
    croak(_get_message(@_));
}

# ------------------------------------------
# Nom : log_warning
#
# Description :
# Fonction chargee d'effectuer un enregistrement d'avertissement.
#
# Arguments :
#  - Arg1..n : Message
#  - Argm : Reference sur un hash pour les options :
#    * severity : La severite
#    * error_number : Le numero d'erreur
# ------------------------------------------
sub log_warning {
    warn(_get_message(@_));
}

# ------------------------------------------
# Nom : log_info
#
# Description :
# Fonction chargee d'effectuer un enregistrement de message d'information.
#
# Arguments :
#  - Arg1..n : Le message d'information.
# ------------------------------------------
sub log_info {
    $logger->notice(@_);

    return 1;
}

# ------------------------------------------
# Nom : log_debug
#
# Description :
# Fonction chargee d'effectuer un enregistrement de message de debug.
# Elle appelle la fonction log_info.
#
# Arguments :
#  - Arg1..n : Le message d'information.
# ------------------------------------------
sub log_debug {
    $logger->info(@_);
    return 1;
}


# -------------------------------------
# Fonctions de manipulation des I-TOOLS
# -------------------------------------

# ------------------------------------------
# Nom : define_table
#
# Description :
# Permet de recuperer le dictionnaire d'une table I-TOOLS sous la forme d'un 
# hash.
# La fonction fait appel a la commande I-TOOLS Define_Table.
# Les cles du hash correspondent aux informations retournees par la commande
# Define_Table, a savoir :
#  - DEFFILE : Le chemin du dictionnaire
#  - TABLE : Le nom de la table
#  - HEADER : La description de la table
#  - TYPE : Le type de la table
#  - SEP : Le separateur de la table
#  - FILE : Le fichier de donnees
#  - COMMAND : La commande (dans le cas d'une table de type commande)
#  - FORMAT : La liste des champs
#  - SIZE : Les taille et type des champs
#  - ROW : La liste des variables d'environnement des champs
#  - KEY : La liste des champs de la cle primaire
#  - NOTNULL : La liste des champs non-nuls
#  - SORT : L'ordre de tri par defaut des donnees
#  - FUKEYXX ou FKEYXX : Les cles etrangeres de la table
#
# Arguments :
#  - Arg1 : Nom de la table.
#
# Retourne : Un hash contenant les données du dictionnaire.
# ------------------------------------------
sub define_table {
    my $table = shift or log_error("usage: define_table(table)");

    my $define = ScriptCooker::Define->new($table);

    my %result_hash = $define->describe();

    return %result_hash;
}

# ------------------------------------------
# Nom : check_table
#
# Description :
#   Verifie la cohérence des données d'une table.
#       - Types des données
#       - Unicité des clefs
#       - Valorisation des champs NOTNULL et KEY
#   Si l'option fkey_on est présent, vérifie la présence des clefs
#   étrangères dans les tables de référence
#
# Arguments :
#  - Arg1 : Nom de la table
#  - Arg2 (optionnel) : Reference sur un hash pour les options :
#    * fkey_on : Nom d'une table de référence
#                  ou undef pour toutes les tables
#    * Condition : La condition de selection des donnees
#
# Retourne :
#   - tableau : liste des erreurs rencontrées
# ------------------------------------------
sub check_table {
    my $usage='check_table($table, { fkey => 1,fkey_on => "table", Condition => $condition} )';

    my $table_name = shift or croak("Usage : $usage");
    my $options = shift;

    my @ftables;
    my $check_fkey;
    my $condition;

    sub_getopt($options, { fkey => \$check_fkey, fkey_on => \@ftables, condition => \$condition});

    if ( @ftables ) {
        $check_fkey++;
    }

    my $itable = ScriptCooker::ITable->open($table_name);

    # stockage local de la structure des FKEY
    my %fkey_for_table = $itable->definition()->fkey();

    if ( $check_fkey) {

        if ( @ftables ) {
            # Vérification de la validité des tables fournies
            foreach my $table ( @ftables ) {
                if ( ! grep {$_ eq $table} keys %fkey_for_table ) {
                    croak(_t("La table [_1] n'est pas une table de référence",$table));
                }
            }
        }
        else {
            # On vérifie sur toutes les tables si aucune n'est précisée
            @ftables = keys %fkey_for_table;
        }
    }

    # Mise en place de la condition
    if ($condition) {
        $itable->query_condition($condition);
    }

    # stockage local des données utiles
    my @key_fields = $itable->key();
    my @fields = $itable->field();
    my $sep = $itable->definition()->separator();

    # structure permettant de detecter les doublons de clefs
    my %seen_key;

    # Tableau ou seront stockés les messages
    my @error_messages;

    # Parcours des données de la table
    while ( my %row = $itable->fetch_row() ) {

        my $key_string = join($sep, @row{@key_fields});
        my $row_string = join($sep, @row{@fields});

        # traitement des doublons si il y a des champs KEY
        if ( @key_fields ) {
            $seen_key{$key_string}++;

            if ( $seen_key{$key_string} > 1) {
                push @error_messages,_t("Cle [_1] : Non unique",$key_string);
            }
        }
        else {
            $seen_key{$row_string}++;
            if ( $seen_key{$row_string} > 1) {
                push @error_messages,_t("Ligne [_1] : Non unique",$row_string);
            }
        }

        push @error_messages, $itable->check_row(%row);

        # Verification des clefs étrangères
        foreach my $ftable ( @ftables ) {

            my %fkey_for_field = %{ $fkey_for_table{$ftable} };
            
            # fabrication de la condition de selection des fkey correspondantes
            my @fkey_conditions;
            foreach my $field ( keys %fkey_for_field ) {
                my $fkey = $fkey_for_field{ $field };

                my $condition = "$fkey = \'$row{$field}\'";
                push @fkey_conditions, $condition;
            }

            my $itable_reference = ScriptCooker::ITable->open($ftable);
            $itable_reference->query_condition(
                                join(' AND ', @fkey_conditions)
                            );

            my $reference_nb=0;
            while ( my %reference_row = $itable_reference->fetch_row() ) {
                $reference_nb++;
            }

            my $fkey_string=join($sep,@row{keys %fkey_for_field});
            if ( $reference_nb == 0 ) {
                push @error_messages,_t("Cle [_1] : Aucune référence pour [_2] dans la table [_3].",$key_string,$fkey_string,$ftable);
            }
            elsif ( $reference_nb > 1 ) {
                push @error_messages, _t("Cle [_1] : Réference [_2] non unique dans la table [_3].",$key_string,$fkey_string,$ftable);
            }
        }
    }

    return @error_messages;
}



# ------------------------------------------
# Nom : select_from_pci
#
# Description :
# Permet d'effectuer une selection de donnees dans le pci d'une table, et d'en
# recuperer les donnees dans un tableau de hash.
#
# Arguments :
#  - Arg1 : Nom de la table
#  - Arg2 : Les options de selection des donnees :
#    * Condition : La condition de selection des donnees au format I-TOOLS,
#    * Join : Si vrai, affiche le pci de la table liée par FUKEY
#    * Join_Condition (implique Join) : Condition sur la table liée
#
# Retourne : Un tableau de references sur des hash. Chaque hash a pour cles les 
# champs definis en option ou tous les champs de la table.
# ------------------------------------------
sub select_from_pci {
    my $table   = shift @_;
    my $options = shift @_;

    if ( ! $table ) {
        log_error("usage: select_from_pci(table[,options])");
    }

    my $condition;
    my $with_join;
    my $join_condition;
    my @sort;

    sub_getopt($options, {
                        join           => \$join_condition,
                        join_condition => \$join_condition,
                        condition      => \$condition,
                    } );

    if ( $join_condition ) {
        $with_join=1;
    }

    # calcul des tables FUKEY
    my $fukey_table = ScriptCooker::Define->new($table)->fukey_table();

    my $itable_pci = ScriptCooker::Pci->open($table);

    $itable_pci->query_sort("");
    $itable_pci->eval_env_vars(1);
    $itable_pci->eval_condition(1);

    if ( $condition ) {
        $itable_pci->query_condition($condition);
    }

    # tableau qui contiendra le résultat
    my @result;

    my $sep    = $itable_pci->output_separator();
    my @fields = $itable_pci->field();
    while (my %line=$itable_pci->fetch_row()){
        push @result,\%line; 
    }   

    if ( $with_join && $fukey_table ) {
        push @result, select_from_pci($fukey_table,
                            { Condition => $join_condition });
    }

    return @result;
}

# ------------------------------------------
# Nom : select_from_table
#
# Description :
# Permet d'effectuer une selection de donnees dans une table, et d'en
# recuperer les donnees dans un tableau de hash.
#
# Arguments :
#  - Arg1 : Nom de la table
#  - Arg2 : Les options de selection des donnees :
#    * Columns : Liste des champs a recuperer au format I-TOOLS,
#    * Condition : La condition de selection des donnees au format I-TOOLS,
#    * Sort : L'ordre de tri des donnees au format I-TOOLS.
#
# Retourne : Un tableau de references sur des hash. Chaque hash a pour cles les 
# champs definis en option ou tous les champs de la table.
# ------------------------------------------
sub select_from_table {
    my $table   = shift @_;
    my $options = shift @_;

    if ( ! $table ) {
        log_error("usage: select_from_table(table[,options])");
    }

    my $columns_text;
    my $condition;
    my $sort_text;

    sub_getopt($options, {
                        columns   => \$columns_text,
                        condition => \$condition,
                        sort      => \$sort_text,
                    });

    my @columns;
    if ( $columns_text ) {
        @columns=split(/\s*,\s*/, $columns_text);
    }

    my @sort;
    if ( $sort_text ) {
        @sort=split(/\s*,\s*/, $sort_text);
    }

    # prepare la requete
    my $table_select = ScriptCooker::ITable->open($table);
    $table_select->query_field(@columns);
    $table_select->query_condition($condition);
    $table_select->query_sort(@sort);

    # construit le tableau à retourner
    my @result;
    while ( my %row=$table_select->fetch_row() ) {
        push @result, \%row;
    }

    return @result;
}

# ------------------------------------------
# Nom : read_row
#
# Description :
# Construit un tableau de hash a partir de l'entete de la commande I-TOOLS
# Select qui doit etre dans la premiere ligne du tableau passe en argument.
#
# Arguments :
#  - Arg1 : Un tableau de chaine a utiliser pour construire le tableau de hash.
#
# Retourne : Un tableau de references sur des hash correspondant a 
# "l'evaluation" de toutes les donnees passees en argument.
# ------------------------------------------
#obsolete
sub read_row {
        my @select_rows=@_;

        $logger->info(_t("La fonction [_1] est obsolete", __PACKAGE__ . "read_row"));

        # Enleve les retour a la ligne
        chomp @select_rows;
        
        # Analyze de l'entete
        my $header = shift @select_rows;

        # Extrait l'entete
        my @header_array = split( /@@/ ,$header);

        # Construit un dictionnaire a partir de l'entete
        my %definition = map { /^(\w+)=\'([^\']*)\'$/ } @header_array;

        # Recupere les donnee utiles
        my $sep = $definition{SEP};
        my @format = split(/$sep/, $definition{FORMAT});

        # Verification
        log_error("format d'entree invalide ou sans entete") 
            if (!$sep) or (!@format);

        # Construit le nouveau tableau contenant des hashs
        my @return_array;

        # Stocke le nombre de champ a affecter
        my $field_nb = @format;

        # Traitement des donnees
        foreach my $row (@select_rows) {
            # Cree un hash pour chaque ligne
            my %value_of;

            # Separe les champs
            my @field_values = split(/$sep/,$row, $field_nb);

            # Affecte chaque valeur a sa colonne
            @value_of{@format} = @field_values;

            # Ajoute le hash par reference au tableau resultat
            push @return_array, \%value_of;
        }

        return @return_array;
} 

# ------------------------------------------
# Nom : read_row_line
#
# Description :
# Construit un hash sur le modele de la fonction read_row() a partir d'une
# ligne de donnees et d'un nom de table.
#
# Arguments :
#  - Arg1 : Nom de la table,
#  - Arg2 : Ligne de donnees a traiter.
#
# Retourne : Une reference sur un hash correspondant a "l'evaluation" de la
# ligne.
# ------------------------------------------
sub read_row_line {
    my $usage = 'usage: read_row_line($table,$ligne)';

    my $table = shift;
    my $line  = shift or log_error($usage);

    chomp $line;

    # Recuperation du dictionnaire de la table
    my $itable = ScriptCooker::ITable->open($table);

    # Decoupe la ligne
    my $sep = $itable->definition->separator();
    my @line_array=split (/\Q$sep\E/, $line, -1);

    # Remplissage du hash
    my %line_hash = $itable->array_to_hash(@line_array);

    return \%line_hash;
}

# ------------------------------------------
# Nom : write_row_line
#
# Description :
# Construit une ligne de donnees a partir d'un nom de table et d'un hash
# contenant les donnees a utiliser.
# Cette fonction agit a l'inverse de la fonction read_row_line().
#
# Arguments :
#  - Arg1 : Nom de la table,
#  - Arg2 : Une reference sur un hash devant contenir les donnees correspondant
#    aux champs de la table, ou un tableau devant contenir DANS L'ORDRE les
#    valeurs des champs.
#
# Retourne : La chaine de donnees construite.
# ------------------------------------------
sub write_row_line {
    my $usage='usage: write_row_line($table,\%ligne)';

    my $table    = shift;
    my $line_ref = shift or log_error($usage," : pas assez de parametres");

    if ( @_ ) {
        log_error($usage," : trop de parametres");
    }

    my $ref_type = ref $line_ref;

    # Verification des parametres
    if ( !defined $ref_type 
       or !grep {$ref_type eq $_} ("ARRAY","HASH") ) {
       log_error($usage," : le 2 parametre n'est pas du bon type (" .
           $ref_type . ")"); 
    }

    my $itable = ScriptCooker::ITable->open($table);

    my $sep = $itable->definition()->separator();

    # Construction de la ligne de donnees
    my @line_array;
    if ( $ref_type eq "ARRAY" ) {

        # Traitement du cas ou les donnees sont passees sous forme de tableau
        @line_array = @{ $line_ref };

    }
    elsif ( $ref_type eq "HASH" ) {

        # Traitement du cas ou les donnees sont passees sous forme de hash
        my %line_hash = %{ $line_ref };

        @line_array=$itable->hash_to_array(%line_hash);
    }
    else {
        croak($usage," : le 2 parametre n'est pas du bon type");
    }


    # Remplace les undef par la chaine vide
    foreach my $field ( @line_array ) {
        if (not defined $field) {
            $field = '';
        }
    }

    return join( $sep,  @line_array );
}

# ------------------------------------------
# Nom : insert_into_table
#
# Description :
# Permet d'inserer des donnees dans une table I-TOOLS. Cette fonction fait
# appel a la commande I-TOOLS InsertAndExec.
#
# Arguments :
#  - Arg1 : Nom de la table,
#  - Arg2 : Donnees a inserer sous la forme d'une reference sur un hash ou 
#    d'un tableau.
# ------------------------------------------
sub insert_into_table {
    my $usage = 'usage: insert_into_table($table,\%ligne)';

    my $table = shift;
    my $line_ref = shift or log_error($usage); 

    if ( @_ ) {
        log_error($usage);
    }

    my $line_insert;

    # Si le 2nd parametre est une reference, c'est un tableau ou un hash
    if ( ref $line_ref ) {
        $line_insert = $line_ref;
    }
    # Sinon c'est la ligne entiere (avec separateur)
    else {
        $line_insert = read_row_line($table,$line_ref);
    }

    my $itable=ScriptCooker::ITable->open($table);
    $itable->insert_row(%{ $line_insert });

    return 1;
}

# ------------------------------------------
# Nom : replace_into_table
#
# Description :
# Permet de remplacer des donnees dans une table I-TOOLS. La fonction fait
# appel a la commande I-TOOLS ReplaceAndExec.
#
# Arguments :
#  - Arg1 : Nom de la table,
#  - Arg2 : Donnees de remplacement sous la forme d'une reference sur un hash 
#    ou d'un tableau.
# ------------------------------------------
sub replace_into_table {
    my $usage = 'usage: replace_into_table($table,\%ligne)';

    my $table = shift;
    my $line_ref = shift or log_error($usage); 

    if ( @_ ) {
        log_error($usage);
    }

    my $line_replace;

    # Si le 2nd parametre est une reference, c'est un tableau ou un hash
    if ( ref $line_ref ) {
        $line_replace = $line_ref;
    }
    # Sinon c'est la ligne entiere (avec separateur)
    else {
        $line_replace = read_row_line($table,$line_ref);
    }

    my $itable=ScriptCooker::ITable->open($table);
    $itable->update_row(%{ $line_replace });

    return 1;
}

# ------------------------------------------
# Nom : remove_from_table
#
# Description :
# Permet de supprimer des donnees depuis une table I-TOOLS. La fonction fait
# appel a la commande I-TOOLS RemoveAndExec.
#
# Arguments :
#  - Arg1 : Nom de la table,
#  - Arg2 : Donnees a supprimer sous la forme d'une reference sur un hash 
#    ou d'un tableau.
# ------------------------------------------
sub remove_from_table {
    my $usage = 'usage: remove_from_table($table,\%ligne)';

    my $table = shift;
    my $line_ref = shift or log_error($usage); 

    if ( @_ ) {
        log_error($usage);
    }

    my $line_remove;

    # Si le 2nd parametre est une reference, c'est un tableau ou un hash
    if ( ref $line_ref ) {
        $line_remove = $line_ref;
    }
    # Sinon c'est la ligne entiere (avec separateur)
    else {
        $line_remove = read_row_line($table,$line_ref);
    }

    # fabrication de la condition
    my @condition_list;
    foreach my $field ( keys %{$line_remove} ) {
        my $value = $line_remove->{$field};
        
        push @condition_list, sprintf("%s = '%s'",$field,$value);
    }


    my $itable=ScriptCooker::ITable->open($table);
    $itable->query_condition(join(' AND ', @condition_list));
    $itable->delete_row(%{ $line_remove });

    return 1;
}

1;
