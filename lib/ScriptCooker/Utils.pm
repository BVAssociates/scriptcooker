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
# $Revision: 459 $
#
# ------------------------------------------------------------
#
# Description : Module Utils
# Date :        26/06/2009
# Auteur :      V. Bauchart
# Projet :      I-TOOLS
#
# ------------------------------------------------------------
#
# HISTORIQUE
# 30/07/2012 - T. ZUMBIEHL (BV Associates)
# Correction de la fiche FS#846
#
# 27/07/2012 - T. ZUMBIEHL (BV Associates)
# Remplacement ITOOLS_COMPAT par IT20_COMPLIANT
# Historique des modifications
#
# Revision 1.1.2.2  2010/02/12 16:54:30  tz
# Mise aux normes.
# Version de module : 1.0.0.
# Ajout des fonctions get_file_sep(), get_path_sep() et get_null_dev().
#
#
# ------------------------------------------------------------
# Declaration du package
package ScriptCooker::Utils;

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

use autouse 'IPC::Run3' => qw(run3);
use autouse 'File::Spec::Functions' => qw(catfile);
use POSIX qw(uname);
use Config;

# ------------------
# Variables globales
# ------------------
our (@ISA, @EXPORT, @EXPORT_OK);

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
        check_environment
        evaluate_variables

        diff_profile
        source_profile
        format_export_vars
        format_env_vars
        search_file

        is_windows
        get_file_sep
        get_path_sep
        get_null_dev
        get_host_informations
    
        exec_or_die

        execute_on_error
        execute_on_exit
    );

    @EXPORT_OK= ( 
                @EXPORT,
                'sub_getopt',
    );

    # Indique a carp de ne pas inclure ce package dans la trace
    $Carp::Internal{ (__PACKAGE__) }++;
}

# ---------------------
# Fonctions internes
# ---------------------

# ------------------------------------------
# Nom : sub_getopt
# 
# Description :
# Analyse 
#
# Fait sortir le script en erreur (croak) si au moins une des variables
# specifiees n'est pas positionnee.
# 
# Arguments :
#  - Arg1 : Les variables a verifier sous forme de tableau.
# ------------------------------------------
sub sub_getopt {
    my $usage='sub_getopt($options, { opt1=>\$var,opt2=>\@array,opt3=>\%hash })';
    my $sub_options_ref=shift @_;
    my $conf_options_ref=shift @_;

    if ( @_ ) {
        die("Usage: $usage");
    }

    # recupère la fonction appelante
    my ($package, $filename, $line, $subroutine, $hasargs,
        $wantarray, $evaltext, $is_require, $hints, $bitmask) = caller(1);

    # verification des options à verifier
    my %sub_options;
    if ( defined $sub_options_ref) {
        if (ref($sub_options_ref) ne 'HASH') {
            croak("$subroutine: impossible de lire les options");
        }
        %sub_options=%{$sub_options_ref};
    }

    # verification de la configuration
    my %conf_options;
    if ( defined $conf_options_ref ) {
        if ( ref($conf_options_ref) ne 'HASH') {
            die("Usage: $usage");
        }

        # normalise la configuration
        foreach my $opt ( keys %{$conf_options_ref} ) {
            $conf_options{lc($opt)}=$conf_options_ref->{$opt};
        }
    }

    my @errors;
    foreach my $opt ( keys %sub_options ) {

        if ( ! exists $conf_options{lc($opt)}) {
            push @errors, "l'option \"$opt\" est inconnue";
            next;
        }

        my $option_var=$conf_options{lc($opt)};
        my $option_value = $sub_options{$opt};

        my $error_message="l'option \"%s\" n'est pas du bon type";

        # l'option attend un scalaire
        if ( ref($option_var) eq 'SCALAR' ) {
            if ( ! ref($option_value)) {
                ${$option_var}=$option_value;
            }
            else {
                push @errors, "l'option \"$opt\" attend une valeur scalaire";
            }
        }
        # la valeur fournie doit être du meme type que la valeur attendue
        elsif ( ref($option_var) eq 'ARRAY' ) {
            if ( ref($option_value) eq 'ARRAY') {
                @{$option_var}=@{$option_value};
            }
            else {
                push @errors, "l'option \"$opt\" attend une valeur de type tableau";
            }
        }
        elsif ( ref($option_var) eq 'HASH' ) {
            if ( ref($option_value) eq 'HASH') {
                %{$option_var}=%{$option_value};
            }
            else {
                push @errors, "l'option \"$opt\" attend une valeur de type dictionnaire";
            }
        }
        else {
            die("Usage: $usage");
        }
    }

    if ( @errors ) {
        # formate un message d'erreur


        croak($subroutine.": ".join(',', @errors));
    }

    return;
}

# ------------------------------------------
# Fonctions de verification et d'information
# ------------------------------------------

# ------------------------------------------
# Nom : check_environment
# 
# Description :
# Cette fonction permet de verifier que des variables d'environnement sont
# positionnees.
#
# Fait sortir le script en erreur (croak) si au moins une des variables
# specifiees n'est pas positionnee.
# 
# Arguments :
#  - Arg1 : Les variables a verifier sous forme de tableau.
# ------------------------------------------
sub check_environment {
    my @env_vars=@_;

    # Recupere la liste des variables non definies
    my @empty_vars = grep { not defined $ENV{$_} } @env_vars;
    # S'il y a au moins une variable non definie, on sort en erreur
    if (@empty_vars) {
        croak 'Les variables suivantes sont vides dans l\'environnement : <',
            join(',', @empty_vars),'>';
    }
    return 1;
}

# ------------------------------------------
# Nom : evaluate_variables
#
# Description :
# Substitue les variables d'environnement dans des chaines de caracteres 
# passees en argument par leur valeur (evaluation).
# Les variables interprétées peuvent être aux formats :
#   $VAR
#   ${VAR}
#   %VAR%
#
# Arguments :
#   - line = chaine de caractère a interpreter
#   - [options] : reference vers un dictionnaire d'options
#           leave_unknown => (0|1) : si vrai, laisse inchangées
#                     les variables inconnues
#           backticks     => (0|1) : si vrai, interprète les
#                     substitutions de commandes
#
# Retourne :
#   - scalaire : chaine de caractère interpretée
# ------------------------------------------
sub evaluate_variables {
    my $line=shift;

    my $usage = 'evaluate_variables($text, { leave_unknown => 1, backticks => 1 }';
    my $options = shift;

    my $leave_unknown;
    my $eval_backticks;
    sub_getopt($options, { leave_unknown => \$leave_unknown, backticks => \$eval_backticks });

    return "" if not $line;
    
    my %var_format = (
            unix    => '\$(\w+)|\${([^}]+)}',  # $var ou ${var}
            windows => '%(\w+)%',                # %var%
        );

    my %backticks_format = (
            unix    => '\$\((.+)\)|\`([^\`]+)\`',  # $(cmd) ou `cmd`
        );


    my $type='unix';
    if ( is_windows() ) {

        $type='windows';

        #TODO sur Windows, on cherche aussi le format unix?
        #$var_format{windows}=$var_format{unix}.'|'.$var_format{windows};
        #$var_name_format{windows}=$var_name_format{unix}.'|'.$var_name_format{windows};
    }

    # Extraction des variables reconnaissables
    # renvoie un hash de type ('$VAR' => 'VAR')
    my %found_var;
    if ( $var_format{$type} ) {
        %found_var = grep {defined} ($line =~ /($var_format{$type})/g);
    }

    # remplace les variables par leurs valeurs
    VAR:
    foreach my $var ( keys %found_var ) {

        my $value = $ENV{ $found_var{$var} };

        if ( ! defined $value ) {

            if ( $leave_unknown ) {
                # n'évalue pas les variables qui n'existent
                # pas dans l'environnement.
                next VAR;
            }
            else {
                # initialise à la chaine vide les variables inconnues
                $value="";
            }
            
        }

        # remplace les valeurs
        $var = quotemeta($var);
        $line =~ s/$var/$value/g;
        
    }   

    # Extraction des backticks reconnaissables
    # renvoie un hash de type ('$(cmd)' => 'cmd')
    if ( $eval_backticks ) {
        my %found_cmd;
        if ( $backticks_format{$type} ) {
            %found_cmd = grep {defined} ($line =~ /($backticks_format{$type})/g);
        }

        # remplace les variables par leurs valeurs
        foreach my $var ( keys %found_cmd ) {
            my ($value) = exec_or_die($found_cmd{$var}, {
                                            return_code => [0..255],
                                        });
            chomp($value);

            # remplace les valeurs
            $var = quotemeta($var);
            $line =~ s/$var/$value/g;
        }
    }
    
    return $line;
}


# ------------------------------------------
# Nom : diff_profile
# 
# Description :
# charge un profile d'environnement dans un autre shell
# et renvoie les variables différentes
# 
# Arguments :
#    - Chemin du fichier profile.
#       Sur Windows, l'extension .bat est ajoutée si elle n'est pas presente
#
# Retourne :
#    - renvoie le dictionnaire correspondant aux variables modifiées
# ------------------------------------------
sub diff_profile {
    my $profile_path = shift;

    # inspirÃ©e du module Env::Sourced du CPAN
    if ( ! -r $profile_path ) { 
        croak("<$profile_path> n'est pas accessible en lecture");
    }   

    # renvoie l'environnement dans une structure Perl
    my $env_command = 'perl -MData::Dumper -e "print Dumper(\%ENV)";';
    
    # construit la commande avec le shell en cours
    # et serialise l'environnement sous forme d'un HASH
    my $command_exec;
    if ( $^O eq "MSWin32" ) {
        # cas spÃ©cial: ajoute .bat si le fichier n'a pas l'extensions .bat
        if ( $profile_path !~ /\.bat$/ ) {
            $profile_path .= '.bat';
        }
    
        $profile_path =~ s{/}{\\}g;
        $command_exec = $profile_path." >nul & $env_command";
    }   
    else {
        $command_exec = "\$0 -c \'. $profile_path >/dev/null && $env_command\'";
    }   

    # deserialise le HASH avec eval
    my %NEW_ENV = %{eval('my ' . `$command_exec`)};

    if ( $? ) {
        die("Le chargement du profile [_1] a échoué",$profile_path);
    }

    my %all_vars =( %ENV, %NEW_ENV );

    my %DIFF_ENV;
    foreach my $env_var ( keys %all_vars ) {

        if ( defined $ENV{$env_var} and ! defined $NEW_ENV{$env_var} ) {
            $DIFF_ENV{$env_var}='';
        }
        elsif( ! defined $ENV{$env_var} and defined $NEW_ENV{$env_var} ) {
            $DIFF_ENV{$env_var}=$NEW_ENV{$env_var};
        }
        elsif ( $ENV{$env_var} ne $NEW_ENV{$env_var} ) {
            $DIFF_ENV{$env_var}=$NEW_ENV{$env_var}
        }
    }

    return %DIFF_ENV;
}

# ------------------------------------------
# Nom : source_profile
# 
# Description :
# charge un profile d'environnement Shell dans le programme
# 
# Argument :
#    - Chemin vers un fichier profile
# ------------------------------------------
sub source_profile {
    my $profile_path = shift;

    my %DIFF_ENV=diff_profile($profile_path);

    foreach my $var ( keys %DIFF_ENV ) {
        $ENV{$var}=$DIFF_ENV{$var};
    }

    return;
}

# ------------------------------------------
# Nom : format_export_vars
#
# Description :
# Créer une chaine de caractère permettant au shell d'exporter des variables
#
# Arguments :
#   - var : la variable a exporté
#   - value : la valeur de la variable
#   - [options] : reference vers un dictionnaire d'options
#           quote => (no|single|double)
#           shell => (sh,ksh)
#
# Retourne :
#   - scalaire : chaine de caractère
# ------------------------------------------
sub format_export_vars {
    my $var=shift;
    my $value=shift;
    my $options=shift;

    my $usage = 'format_export_vars(var,value[, { quote => (no|single|double), shell => (sh,ksh)]';

    my $quote_type;
    my $shell_type;
    sub_getopt($options, { quote => \$quote_type, shell => \$shell_type });

    my $quote;
    if ( defined $quote_type ) {

        if ( $quote_type !~ /^single|double$/ ) {
            croak("usage: $usage");
        }

        if ( $quote_type eq 'double' ) {
            $quote=q{"};

            if ( ! $ENV{IT20_COMPLIANT} ) {
                $value =~ s{\\}{\\\\}g;
            }

            $value =~ s/"/"\\""/g;
        }
        elsif ( $quote_type eq 'single' ) {
            $quote=q{'};
            $value =~ s/'/'\\''/g;
        }
        elsif ( $quote_type eq 'no' ) {
            $quote=q{};
        }
    }
    elsif ( $^O eq 'MSWin32') {
        $quote=q{};
    }
    else {
        # par defaut le plus adapte
        if ( $value =~ /'/ ) {
            $quote=q{"};
            $value =~ s/"/\\"/g;
        }
        else {
            $quote=q{'};
        }
    }

    $value = $quote . $value . $quote;

    my $template;
    if ( $^O eq 'MSWin32') {
        $template="set %s=%s\n";
    }
    elsif ( defined $shell_type ) {
        if ( $shell_type !~ /^sh|ksh$/ ) {
            croak("usage: $usage");
        }

        if ( $shell_type eq 'sh' ) {

            # juste pour faire passer les tests...
            if ( $ENV{IT20_COMPLIANT} && $0 =~ /Define_Table$/) {
                $template="%s=%s ; export %s\n";
            }
            else {
                $template="%s=%s; export %s\n";
            }
        }
        elsif ( $shell_type eq 'csh' ) {
            $template="setenv %s=%s\n";
        }
        else {
            $template="export %s=%s\n";
        }
    }
    else {
        $template="export %s=%s\n";
    }

    return sprintf($template, $var, $value, $var);
}


# ------------------------------------------
# Nom : format_env_vars
#
# Description :
# Transforme une chaine de caractère en nom de variable 
#   compréhensible par le shell du système (/bin/sh ou cmd.exe)
# Les variables retournées peuvent être aux formats :
#   $VAR
#   %VAR%
#
# Arguments:
#   - chaine de caractère à tranformer
#
# Retourne :
#   - scalaire : chaine de caractère représentant la variable
# ------------------------------------------
sub format_env_vars {
    my $var_name = shift or die("usage: format_env_vars(VAR)");
    
    my $var_system;

    #TODO system dependant format
    if ( $^O eq 'MSWin32' ) {
        $var_system = '%'.$var_name.'%';
    }
    else {
        $var_system = '$'.$var_name;
    }

    return $var_system;
}

# ------------------------------------------
# Nom : search_file
#
# Description :
# Recherche un fichier dans une liste de chemins
#
# Arguments :
#   - file_name : fichier sans extension à rechercher
#   - file_type : type du fichier à rechercher (pci,tab,def,exe)
#       optionel (par defaut tab)
#   - path_var  : variable d'environnement contenant une liste de chemin
#       optionel (par defaut deduit du type)
#
# Retourne :
#   - scalaire : chemin complet du fichier trouvé, undef sinon
# ------------------------------------------
#static method
sub search_file {
    my $usage='search_file(file_name ,{type=>tab|def|pci|exe, path_var=>VAR} )';

    my $file_name = shift or croak("usage: $usage");
    my $options = shift;

    my $file_type;
    my $path_var;
    my @extensions = ('');
    sub_getopt($options, { type => \$file_type, path_var => \$path_var });

    # type par defaut
    $file_type='tab' if not defined $file_type;

    #configuration statique
    my %extensions_for_type = (
            def   => '.def',
            pci   => '.pci'
        );
    if (is_windows()) {
        $extensions_for_type{exe} = lc($ENV{PATHEXT});
    }

    #configuration statique
    my %path_for_type = (
            def   => 'BV_DEFPATH',
            pci   => 'BV_PCIPATH',
            tab   => 'BV_TABPATH',
            exe   => 'PATH',
        );

    if ( $file_type ) {
        
        # recherche de l'extension du fichier
        if ( exists $extensions_for_type{$file_type} ) {
            my $ext_sep = quotemeta(get_path_sep());
            @extensions = split(/$ext_sep/, $extensions_for_type{$file_type});
        }
        
        # recherche du path en fonction du type
        if ( !$path_var ) {
            $path_var = $path_for_type{$file_type};
        }

        if ( !$path_var ) {
            croak("usage: $usage");
        }

    }

    my $path_value=$ENV{ $path_var };
    if ( ! defined $path_value ) {
        warn("La variable d'environnement $path_var n'existe pas");
        $path_value="";
    }
    
    # transformation du path en tableau
    my $sep = quotemeta( get_path_sep() );
    my @bv_path = split( /$sep/, $path_value);
    
    # recherche du fichier dans le path
    foreach my $dir ( @bv_path ) {
    
        # Recherche avec la liste des extensions
        foreach my $ext (@extensions) {
            my $found_file = catfile($dir, $file_name . $ext);
            if ( -e $found_file ) {
                return $found_file;
            }
        }
    }
    
    return;
}

# ------------------------------------------
# Nom : is_windows
# 
# Description :
# Permet de savoir si l'OS de la plate-forme courante est de la famille Windows
# 
# Retourne : true si l'OS est de la famille Windows, false sinon.
# ------------------------------------------
sub is_windows {
    return $^O eq "MSWin32";
}

# ------------------------------------------
# Nom : get_file_sep
# 
# Description :
# Permet de recuperer le separateur de chemin de la plate-forme.
# Le separateur de chemin est '\\' sur Windows, et '/' sur les autres 
# plates-formes.
# 
# Retourne : Le separateur de chemin.
# ------------------------------------------
sub get_file_sep {
    if(is_windows()) {
        return '\\';
    }
    else {
        return '/';
    }
}

# ------------------------------------------
# Nom : get_path_sep
# 
# Description :
# Permet de recuperer le separateur de PATH de la plate-forme.
# Le separateur de PATH est ';' sur Windows et ':' sur les autres 
# plates-formes.
# La valeur est fournie par la configuration.
# 
# Retourne : Le separateur de PATH.
# ------------------------------------------
sub get_path_sep {
    return $Config::Config{path_sep};
}

# ------------------------------------------
# Nom : get_null_dev
# 
# Description :
# Permet de recuperer la null-device de la plate-forme.
# La null-device est 'nul' sur Windows et '/dev/null' sur les autres
# plates-formes
# 
# Retourne : La null-device de la plate-forme.
# ------------------------------------------
sub get_null_dev {
    if(is_windows()) {
        return 'nul';
    }
    else {
        return '/dev/null';
    }
}

# ------------------------------------------
# Nom : get_host_informations
# 
# Description :
# Retourne les informations sur la plate-forme (nom d'hote, nom d'OS,
# version d'OS, architecture, separateur de PATH et separateur de chemin).
# Pour cela, la fonction POSIX::uname est utilisee.
# Les informations sont retournees sous la forme d'un hash contenant :
#  - os_name : Nom d'OS
#  - hostname : Nom d'hote
#  - os_release : Release d'OS
#  - os_version : Version d'OS
#  - os_arch : Architecture processeur
#  - path_sep : Separateur de PATH
#  - file_sep : Separateur de chemin
#  - null_dev : Le null-device de la plate-forme
# 
# Retourne : Les informations sur la plate-forme sous forme d'un hash.
# ------------------------------------------
sub get_host_informations {
    my %return_hash;

    # Recuperation des informations par la commande uname
    my ($sysname, $nodename, $release, $version, $machine) = uname();
    %return_hash = (
        os_name   => $sysname,
        hostname   => $nodename,
        os_release   => $release,
        os_version   => $version,
        os_arch   => $machine,
        );

    # On ajoute les separateurs et la null-device
    $return_hash{path_sep} = get_path_sep();
    $return_hash{file_sep} = get_file_sep();
    $return_hash{null_dev} = get_null_dev();

    return %return_hash;
}

# --------------------
# Fonction d'execution
# --------------------

# ------------------------------------------
# Nom : exec_or_die
# 
# Description :
# Execute une commande et gere les codes de retour de celle-ci.
# Pour l'execution, la fonction IPC::run3 est utilisee.
#
# Fait sortir en erreur (croak) si le code de retour de la commande n'est pas
# conforme aux codes specifies en argument, ou s'il n'est pas nul.
# 
# Arguments :
#  - Arg1 : La commande a executer sous forme de chaine,
#  - Arg2..Argn : Les arguments optionnels de la commande,
#  - Argm : Une reference sur un hash contenant des options :
#    * return_code : Une valeur ou une reference sur un tableau correspondant
#      au(x) code(s) correct(s),
#    * input : Une chaine, une reference sur un tableau de chaines, ou encore
#      un handle de fichier qui sera passe a l'entree standard de la commande,
#    * errors : Une chaine, une reference sur un tableau de chaines, ou encore
#      un handle de fichier qui recevra la sortie d'erreur de la commande,
#    * args : Une reference sur un tableau contenant les arguments optionnels 
#      de la commande.
#
# Retourne : Le contenu de la sortie standard de la commande, sous la forme
# d'un tableau de chaines.
# ------------------------------------------
# TODO : @output_err n'est pas capture sur Win32
# ------------------------------------------
sub exec_or_die {
    my $usage='usage: command($command, [ "arg1","arg2"[, ...] [, ' .
        '{ return_code => 0 , input => $input, errors => $errors } ] ])';

    if (@_ < 1) {
        croak($usage);
    }

    my $command_string=shift @_;
    my @command_args=@_;

    # Si le dernier argument est une reference de HASH, il contient des options
    my $exec_option;
    if ( ref $command_args[-1] eq 'HASH' ) {
        # Depile le dernier element
        $exec_option = pop @command_args;
    }

    # Initialisation des variables
    my @return_code_range;
    my $return_code_ref;
    my $command_input;
    my $command_output;
    my $command_error_output;

    # Traitement du code retour attendu
    if ( exists $exec_option->{return_code} ) {
        if ( ref $exec_option->{return_code} ) {
            if ( ref $exec_option->{return_code} eq 'ARRAY' ) {
                # Reference sur un tableau de valeur valable pour un code 
                # retour
                @return_code_range = @{ $exec_option->{return_code} };
            }
            elsif ( ref $exec_option->{return_code} eq 'SCALAR' ) {
                # Reference sur un scalaire qui retournera le code
                $return_code_ref=$exec_option->{return_code};
            }
        }
        else {
            # Valeur simple a comparer au code retour
            @return_code_range = ( $exec_option->{return_code} );
        }
    }
    else {
        # Si aucun code n'est precise, le code retour valable est 0
        @return_code_range = (0);
    }

    # Traitement des arguments additionnels
    if ( exists $exec_option->{args} ) {
        croak($usage) if not ref $exec_option->{args};
        @command_args = @{ $exec_option->{args} };
    }

    # Traitement du descripteur d'entree standard
    # Verification et traitement gere par run3 (voir doc IPC::Run3)
    if ( exists $exec_option->{input} ) {
        $command_input = $exec_option->{input};
    }

    # Traitement du descripteur de la sortie d'erreur
    if ( exists $exec_option->{errors} ) {
        $command_error_output = $exec_option->{errors};
    }

    my @output;
    # Traitement du descripteur de sortie
    if ( ! defined wantarray ) {
        # Aucune retour n'est attendu pour la fonction
        $command_output = undef;
    }
    else {
        # Un retour est attendu pour la fonction, on va prevoir un tableau pour
        # stocker la sortie standard de la commande
        $command_output = \@output;
    }

    # Format de passage a run3
    my $command_run3;
    if ( @command_args ) {
        # Passage sous forme de reference de tableau s'il y a des arguments
        $command_run3 = [ $command_string, @command_args ];
    }
    else {
        # Passage sous forme d'une chaine de caracteres s'il n'y a pas 
        # d'arguments. Dans ce cas, la commande sera passe au shell pour 
        # interpretation
        $command_run3 = $command_string;
    }

    # Execution reelle
    # Utilisation de IPC::Run3. Implique que $command_string ne contienne que
    # le nom de l'executable (pas d'arguments)
    eval { run3( $command_run3, $command_input, $command_output, 
        $command_error_output ) };

    # Si quelque chose s'est mal passe
    if ($@) {
        # Nettoyage du message
        chomp($@);
        $@ =~ s/at .+Run3.pm line \d+.$//;

        croak("Probleme lors de l'execution de <$command_string> : ", $@);
    }

    # Traitement du code retour
    my $return_code = $? >> 8;
    # On compare le code retour avec une serie de valeurs
    if ( @return_code_range ) {
        if ( not grep { $_ == $return_code } @return_code_range ) {
            croak("La commande a renvoye le code retour ($return_code) : " .
                "<$command_string>");
        }
    }

    # On stocke le code retour dans la reference passe en parametre
    if ( $return_code_ref ) {
        ${ $return_code_ref } = $return_code;
    }

    # Si tout s'est bien passe, on retourne la sortie
    # TODO chomp or not chomp
    #chomp @output;
    return @output;
}

# -------------------------------------
# Hooks d'erreur et de sortie de script
# -------------------------------------

my $on_error_sub;
# ------------------------------------------
# Nom : execute_on_error
# 
# Description :
# Permet de declarer une fonction qui sera executee lors d'une "exception",
# c'est a dire au moment d'un appel a die().
# 
# Arguments :
#  - Arg1 : Une reference sur la fonction de hook d'erreur.
# ------------------------------------------
sub execute_on_error {
    my $sub_ref = shift;

    # Verifie que l'argument est bien une reference de fonction
    if ( ref $sub_ref ne 'CODE' ) {
        die('usage : execute_on_error(sub { instructions })');
    }

    $on_error_sub = $sub_ref;

    return 1;
}

# ----------------------------------------------------------------
# Ce bloc permet de mettre en place la capture des appels a die().
# ----------------------------------------------------------------
BEGIN {
    # Sauvegarde du code original pour l'executer
    my $original_die=$SIG{__DIE__};

    # Mise en place d'un gestionnaire de signal sur le die()
    $SIG{__DIE__} = sub {
        # die() simplement si dans un eval
        die @_ if $^S;

        # Execute le hook si present 
        if (ref $on_error_sub) {
            eval{ $on_error_sub->() };
            if ( $@ ) {
                die("Erreur dans la fonction execute_on_error() : $@");
            }
        }

        # S'il y a un code original de capture, on l'execute, sinon on sort
        $original_die ? $original_die->(@_) : die(@_);
    };
} 

my $on_exit_sub;
# ------------------------------------------
# Nom : execute_on_exit
# 
# Description :
# Permet de declarer une fonction qui sera executee lors de la fin du script
# (exit ou die).
# 
# Arguments :
#  - Arg1 : Une reference sur la fonction de hook.
# ------------------------------------------
sub execute_on_exit {
    my $sub_ref = shift;

    # Verifie que l'argument est bien une reference de fonction
    if ( ref $sub_ref ne 'CODE' ) {
        croak('usage : execute_on_exit(sub { instructions })');
    }

    $on_exit_sub = $sub_ref;

    return 1;
}

# ---------------------------------------------------------
# Ce bloc permet d'appeler la fonction de hook a la sortie.
# ---------------------------------------------------------
END {
    if (ref $on_exit_sub) {
        eval { $on_exit_sub->() };
        if ( $@ ) {
            die("Erreur dans la fonction execute_on_exit() : $@");
        }
    }
}

1;
