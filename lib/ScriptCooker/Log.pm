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
﻿# ------------------------------------------------------------
# Copyright (c) 2011, BV Associates. Tous droits reserves.
# ------------------------------------------------------------
#
# $Revision: 455 $
#
# ------------------------------------------------------------
#
# Description : Module ScriptCooker::Log, gère l'affichage des erreurs
#   et l'écriture dans un fichier de log. Modifie le code
#   retour du programme en fonction des erreurs rencontrées
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
package ScriptCooker::Log;

# Verification de la version de PERL : 5.8 minimum
use 5.008;

# -------
# Imports
# -------
use strict;
use warnings;

# parametrage de l'affichage des fonctions Carp
use Carp qw(carp cluck confess croak );
$Carp::MaxArgNums = 0;
$Carp::MaxArgLen  = 0;
my $package = __PACKAGE__;
$Carp::Internal{$package} = 1;

# Utilisation de package CPAN
use Log::Handler;
use POSIX qw(strftime);
use File::Basename;
use File::Spec;

# module de traduction
use ScriptCooker::L10N 2.1.0;

# ------------------
# Variables globales
# ------------------
# version du module
our $VERSION = 2.1.0;

# variable qui contiendra l'objet Log::Handler
our $logger;

my $force_exit_code;
my $itools_compat   = $ENV{IT20_COMPLIANT};

#    7   debug
#    6   info
#    5   notice
#    4   warning, warn
#    3   error, err
#    2   critical, crit
#    1   alert
#    0   emergency, emerg
my $verbose_level   = 5;

# traductions pour l'ecran
my $language_handler;
# traductions pour la log
my $language_handler_log;

# dictionnaire qui va contenir les phrases traduites
# dans la langue utilisé pour la log
my %locale_cache_screen;

# constantes

my %code_for_level = (
    DEBUG     => 0,
    INFO      => 0,
    NOTICE    => 0,
    WARNING   => 201,
    ERROR     => 202,
    CRITICAL  => 202,
    EMERGENCY => 203,
);

my %core_command = (
        'Check' => undef,
        'Dateft' => undef,
        'Define_Table' => undef,
        'Delete' => undef,
        'Formate_File' => undef,
        'Get_Group' => undef,
        'Get_Passwd' => undef,
        'Get_PCI' => undef,
        'Insert' => undef,
        'InsertAndExec' => undef,
        'Lock_Table' => undef,
        'Log_End' => undef,
        'Log_Error' => undef,
        'Log_Info' => undef,
        'Log_Start' => undef,
        'Modify' => undef,
        'Parameters' => undef,
        'Purge_Log' => undef,
        'Read_Log' => undef,
        'Read_Row' => undef,
        'Remove' => undef,
        'RemoveAndExec' => undef,
        'Replace' => undef,
        'ReplaceAndExec' => undef,
        'Search_File' => undef,
        'Select' => undef,
        'Sort' => undef,
        'Split' => undef,
        'Update_Table' => undef,
    );

# -------------------------
# Section de chargement
# Declaration des "exports"
# -------------------------
BEGIN {
    use Exporter ();
    our ( @ISA, @EXPORT, @EXPORT_OK );

    @ISA = qw(Exporter);

    # aucun export implicite
    @EXPORT = qw();

    # export a importer explicitement
    @EXPORT_OK = qw(
      $logger

      init_logger
      tail_log
      set_exit_code
      get_exit_code

      set_debug_mode
      get_debug_mode

      _t
    );
}

# Gestion du code retour
END {

    # $force_exit_code est prioritaire par rapport à $?
    if (defined $force_exit_code) {
        $?=$force_exit_code;
    }
    else {
        $force_exit_code=$?;
    }

    if ( ! exists $core_command{basename($0)} && $logger ) {
        my $message = _t("Sortie du programme avec le code [_1]",$force_exit_code);
        $logger->info($message);
    }
}

#######################
# Fonctions           #
#######################

# ------------------------------------------
# Fonctions interne au module
# ------------------------------------------

# ------------------------------------------
# Nom : format_message_file
#
# Description :
#   Formatte un message passé par Log::Handler pour l'affichage dans un fichier
#
# Arguments :
#   - message : référence de dictionnaire passé par Log::Handler
# ------------------------------------------
sub format_message_file {
    my $message = shift;

    # recherche de la traduction
    if (exists $locale_cache_screen{ $message->{message} }) {
        $message->{message} = $locale_cache_screen{ $message->{message} };

        # supprime l'entree temporaire
        delete $locale_cache_screen{ $message->{message} };
    }

    # formatage du message
    my $output_format = "%s|%s|%s|%s|%s|%s|%s|%s|%s";

    # echappe les separateurs
    $message->{message} =~ s/\|/\\|/g;


    # decoupage des lignes
    my @message_lines = split(/\n/, $message->{message});

    my @output_message;
    my $first_line=1;
    foreach my $line ( @message_lines ) {
        
        # ajoute un caractere ^ sur les lignes suivantes
        if ( $first_line ) {
            $first_line=0;
        }
        else {
            $line = '^'.$line;
        }

        # %T|%d|%F|%P|%U|%S|%L|%c|%m
        push @output_message , sprintf( $output_format,
                $message->{time}, 
                $message->{domain}, 
                $message->{ppid}, 
                $message->{pid}, 
                $message->{user},
                $message->{progname},
                $message->{level},
                $message->{severity},
                $line,
            );
    }

    $message->{message} = join("\n",@output_message);

    return;
}


# ------------------------------------------
# Nom : format_message_output
#
# Description :
#   Formatte un message passé par Log::Handler pour l'affichage à l'écran
#
#   Verifie la variable d'environnement IT20_COMPLIANT pour l'affichage
#   des messages à l'ancienne mode
#
# Arguments :
#   - message : référence de dictionnaire passé par Log::Handler
# ------------------------------------------
sub format_message_output {
    my $message = shift;

    # formatage du message
    my $output_message;
    if ($itools_compat) {
        my $output_format =
          _t("Procedure : %s, Type : %s, Severite : %d\nMessage : %s");

        $output_message = sprintf( $output_format,
            $message->{progname}, ucfirst( lc( $message->{level} ) ),
            $message->{severity}, $message->{message}, );
    }
    else {
        my $output_format = "%s:%s:%s:%s";

        $output_message = sprintf( $output_format,
                $message->{time}, 
                $message->{progname}, 
                _t($message->{level}),
                $message->{message},
            );
    }

    $message->{message} = $output_message;

    return;
}

# ------------------------------------------
# Nom : init_logger
#
# Description :
#   Initialise l'objet $logger de classe Log::Handler
#   Permet l'affichage à l'écran et dans un fichier
#       de log indiqué dans la variable d'environnement
#       BV_LOGFILE
#
# Arguments :
#  - add_screen : booleen
#  - file_destination : chemin vers le fichier de log
# ------------------------------------------
sub init_logger {
    my $screen_destination = shift;
    my $file_destination   = shift;

    if ( !$screen_destination && !$file_destination ) {
        croak("usage: init_logger(STDERR|STDOUT|undef, filename|undef");
    }

    # configuration du logger sur STDERR
    my %screen_config = (
            # parametrage type screen
            #log_to     => 'STDERR',

            # parametrage commun
            newline    => 1,
            maxlevel   => 'notice',
            timeformat => '%Y/%m/%d %H:%M:%S',
            #message_layout  => '%T:%L:%m',
            message_layout  => '%m',
            message_pattern => [qw/%T %L %S %c %m/],
            prepare_message => \&format_message_output,
            alias           => 'screen-out',
    );

    # configuration du logger dans BV_LOGFILE
    my %file_config = (

            # parametrage type file
            #filename   => $ENV{BV_LOGFILE},
            #fileopen   => 0,
            #reopen     => 0,
            #autoflush      => 0,
            #mode           => 'append',

            # parametrage commun
            newline        => 1,
            maxlevel       => 'info',
            timeformat     => '%Y%m%d%H%M%S',
            #message_layout => '%T|%d|%F|%P|%U|%S|%L|%c|%m',
            message_layout => '%m',
            message_pattern => [qw(%T %d %F %P %U %S %L %c %m)],
            prepare_message => \&format_message_file,
            alias          => 'file-out',
    );
    
    if ( $^O eq 'MSWin32' ) {
        $file_config{fileopen}=0;
        $file_config{reopen}=0;
    }

    # creation d'un nouveau logger
    my $logger = Log::Handler->new();

    # parametrage des colonnes speciales I-TOOLS
    # BV_DOMAIN
    my $bv_domain=$ENV{BV_DOMAIN} || 'TOOLS';
    $logger->set_pattern('%d','domain',$bv_domain);

    # PID
    my $pid=$$;
    if ( defined $ENV{BV_FILS} && $ENV{BV_FILS} ne '') {
        $pid=$ENV{BV_FILS};
    }
    $logger->set_pattern('%P','pid', $pid );

    # PPID
    my $ppid=0;
    if ( defined $ENV{BV_PERE} && $ENV{BV_PERE} ne '') {
        $ppid=$ENV{BV_PERE};
    }
    elsif ( $^O ne 'MSWin32' ) {
        $ppid=getppid();
    }
    $logger->set_pattern('%F','ppid', $ppid );

    # BV_SEVERITE
    $logger->set_pattern('%c','severity', \&get_exit_code);

    # BV_PROC
    my $bv_proc;
    if ( $ENV{BV_PROC} ) {
        if ( ! exists $core_command{basename($0)} ) {
            $bv_proc=$ENV{BV_PROC}.':'.basename($0);
        }
        else {
            $bv_proc=$ENV{BV_PROC};
        }
    }
    else {
        $bv_proc=basename($0);
    }
    $logger->set_pattern('%S','progname', $bv_proc);

    if ( $^O eq 'MSWin32' ) {
        eval('use Win32;');
        my $user=Win32::LoginName();
        if ( $ENV{USERDOMAIN} ) {
            $user = $ENV{USERDOMAIN} .'\\'. $user;
        }
        $logger->set_pattern('%U','user', $user);
    }

    # creation de la sortie console
    if ( $screen_destination ) {
        if ( $screen_destination =~ /^STDERR|STDOUT$/ ) {
            $screen_config{log_to} = $screen_destination;
            $logger->add(screen => \%screen_config);
        }
        else {
            croak("usage: init_logger(STDERR|STDOUT,file_destination)");
        }
    }

    # creation de la sortie fichier
   if ( $file_destination ) {
        if ( $file_destination =~ /^STDERR|STDOUT$/ ) {
            #redirige la sortie fichier vers la console (voir Log_Info)
            $file_config{log_to} = $file_destination;
            $logger->add(screen => \%file_config);
        }
        else {
            my $file_dir = dirname($file_destination);

            if ( -w $file_destination || -w $file_dir) {
                $file_config{filename} = $file_destination;
                $logger->add(file => \%file_config);
            }
            else {
                set_exit_code(201);
                $logger->warning(_t("Impossible d'ouvrir le fichier [_1].",$file_destination));
            }
        }
   }


  #Log::WarnDie may be used, but it put everything from STDERR
  #in $logger->error() on STDOUT. So we must be aware of bad effect on output...
    ##Log::WarnDie->dispatcher( $logger );

    return $logger;
}

# ------------------------------------------
# Nom : init_language
#
# Description :
#   Charge le module de traduction
#
# Arguments :
#  - aucun
# ------------------------------------------
sub init_language {

    my @lang;
    if ( $ENV{BV_LANG} ) {
        @lang=( $ENV{BV_LANG} );
    }

    my @lang_log;
    if ( $ENV{BV_LANG_LOG} ) {
        @lang_log=( $ENV{BV_LANG_LOG} );
    }

    $language_handler     = ScriptCooker::L10N->get_handle(@lang);
    $language_handler_log = ScriptCooker::L10N->get_handle(@lang_log);

    # Affiche le message tel quel si pas de traduction
    $language_handler->fail_with('failure_handler_auto');
    $language_handler_log->fail_with('failure_handler_auto');

    if ( !$language_handler ) {
        $logger->warning("Impossible de charger un fichier de traduction");
    }

    return;
}

# ------------------------------------------
# Nom : init_die_handler
#
# Description :
#   Surcharge les evennements die() et warn() et
#       les redirige le logger
#
# Arguments :
#  - aucun
# ------------------------------------------
sub init_die_handler {

    # DIE and WARN trap
    #  Save current __WARN__ setting
    #  Replace it with a sub that
    #   If there is a dispatcher
    #    Remembers the last parameters
    #    Dispatches a warning message
    #   Executes the standard system warn() or whatever was there before

    my $WARN = $SIG{__WARN__};
    $SIG{__WARN__} = sub {
        if ($logger) {
            if ( ! defined $force_exit_code || $force_exit_code < 201 ) {
                #TODO fixer le comportement par defaut : 201 ou non?
                #set_exit_code(201);
            }
            $logger->warning(@_);
        }

        #$WARN ? $WARN->( @_ ) : CORE::warn( @_ );
    };

    #  Save current __DIE__ setting
    #  Replace it with a sub that
    #   If there is a dispatcher
    #    Remembers the last parameters
    #    Dispatches a critical message
    #   Executes the standard system die() or whatever was there before

    my $DIE = $SIG{__DIE__};
    $SIG{__DIE__} = sub {

        # check if we are in eval { }
        return if $^S;

        my @message=@_;

        if ($logger) {
            if ( ! defined $force_exit_code || $force_exit_code < 202 ) {
                set_exit_code(202);
            }
            $logger->critical(@message);
        }

        #$DIE ? $DIE->() : CORE::die(@_);
        $DIE
          ? $DIE->(_t("Terminaison du programme")."\n")
          : CORE::die(_t("Terminaison du programme")."\n");
    };
}

# ------------------------------------------
# Fonctions exportées
# ------------------------------------------

# ------------------------------------------
# Nom : reset_tail
#
# Description :
#   Pour la fonction tail_log(), relance la
#       lecture de tout le fichier
#
# Arguments :
#  - aucun
# ------------------------------------------
my $curpos = 0;

sub reset_tail {
    $curpos = 0;
}

# ------------------------------------------
# Nom : tail_log
#
# Description :
#   Imite la commande unix tail -f
#
# Arguments :
#  - file_name = chemin du fichier
#  - roll_after(entier) = nombre de ligne a passer
# ------------------------------------------
sub tail_log {
    my $file_name = shift or croak("usage : tail_log(file_name [, nb_last])");
    my $roll_after = shift;

    open( my $file_fd, '<', $file_name )
      or croak( "Impossible d'ouvrir le fichier $file_name : ", $! );

    my @rolling_line;

    if ( not $curpos and $roll_after ) {
        if ( $roll_after == -1 ) {
            seek( $file_fd, 0, 2 );
            $curpos = tell($file_fd);
        }
        else {
            for (<$file_fd>) {
                push @rolling_line, $_;
                shift @rolling_line if @rolling_line > $roll_after;
            }

            for (@rolling_line) {
                print;
            }
        }
    }

    # enable autoflush
    $| = 1;
    seek( $file_fd, $curpos, 0 );
    for ( $curpos = tell($file_fd) ; <$file_fd> ; $curpos = tell($file_fd) ) {

        # search for some stuff and put it into files
        print;
    }
    close $file_fd;
}

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
    my $user_level = shift;

    if ( $user_level !~ /^\d+$/ ) {
        croak(_t("usage: [_1]","debug_mode(level)"));
    }

    if ( $user_level ) {
        if ( $verbose_level < 6 ) {
            $logger->set_level( 'screen-out' => { maxlevel => 'info' } );
            $verbose_level=6;
        }
    }
    else {
        if ( $verbose_level > 6 ) {
            $logger->set_level( 'screen-out' => { maxlevel => 'notice' } );
            $verbose_level=5;
        }
    }

    return 1;
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
    return $verbose_level >= 6;
}

# ------------------------------------------
# Nom : set_exit_code
#
# Description :
#   Force le code retour du programme
#
# Arguments :
#  - code(entier) = code retour
# ------------------------------------------
sub set_exit_code {
    my $code = shift;
    if ( $code !~ /^\d+$/ ) {
        croak("usage: set_exit_code(nb)");
    }

    $force_exit_code = $code;

    return;
}

# ------------------------------------------
# Nom : get_exit_code
#
# Description :
# Permet de recuperer le code de sortie du script.
#
# Retourne : Le code de sortie qui sera utilise.
# ------------------------------------------
sub get_exit_code {
    return (defined $force_exit_code)?$force_exit_code:0;
}

# ------------------------------------------
# Nom : _t
#
# Description :
# Calcul les tradutions d'une chaine dans le langage
# d'affichage et le langage de fichier log
# Ex : _t("Bonjour [_1] !","world") renverra "Hello World !"
#
# Arguments :
#   - format : format Locale::Maketext
#   - valeurs : liste de chaines qui seront utiliss
#
# Retourne : Le message traduit dans le langage d'affichage
# ------------------------------------------
sub _t {
    my @text = @_;

    my $translated_text;
    my $translated_text_log;

    if ( $language_handler ) {
        $translated_text = $language_handler->maketext(@text);
    }
    else {
        $text[0] =~ s/\[_\d+\]/%s/g;
        $translated_text = sprintf(shift @text, @text);
    }

    if ( $language_handler_log ) {
        $translated_text_log = $language_handler_log->maketext(@text);
    }
    else {
        $translated_text_log = $translated_text;
    }

    # on stocke le message traduit pour pouvoir le passer à Log::Handler plus tard
    $locale_cache_screen{$translated_text} = $translated_text_log;

    return $translated_text;
}

#######################
# Programme principal #
#######################

init_language();

# initialisation du logger
my $log_file;
if ( $ENV{BV_LOGFILE} ) {
    if ( $ENV{BV_LOGFILE} =~ /^([^|&;]+)$/ ) {
        $log_file=$1;
        if ( ! File::Spec->file_name_is_absolute($log_file) ) {
            warn(_t("La variable [_1] doit etre un chemin absolu","BV_LOGFILE"));
        }
    }
    else {
        warn(_t("Le format de la variable [_1] n'est pas correct","BV_LOGFILE"));
    }
}
else {
    warn(_t("La variable [_1] est vide","BV_LOGFILE"));
}
$logger=init_logger("STDERR", $log_file);

init_die_handler();

if ( $ENV{BV_DEBUG} ) {
    $logger->set_level( 'screen-out' => { maxlevel => 'debug' } );
    $verbose_level = 7;
}

# log de demarrage du programme
if ( ! exists $core_command{basename($0)} ) {
    $logger->info( _t("Demarrage du programme (ARG=[_1])" , join( " ", @ARGV ) ));
}

#######################
# tests rapides       #
#######################
if ( not caller ) {
    $logger->notice( _t( '[_1] de traduction', 'test' ) );
    $logger->error( _t("test d'erreur"));

    #    $logger->critical("it is a critical test");
    #    eval { die("it is a eval dying test") };
    print "eval result: ", $@;

    #    die("it is a dying test");

    $logger->warning( _t("sortie en warning") );

}

1;
