# ------------------------------------------------------------
# Copyright (c) 2011, BV Associates. Tous droits reserves.
# ------------------------------------------------------------
#
# $Revision: 422 $
#
# ------------------------------------------------------------
#
# Description : Module Condition
# Date :        26/06/2011
# Auteur :      V. Bauchart
# Projet :      I-TOOLS
#
# ------------------------------------------------------------
#
# Historique des modifications
#
# $Log$
#
# ------------------------------------------------------------

# Declaration du package
package ScriptCooker::ITable::Condition;

our $VERSION=2.1.0;

# -------
# Imports systemes
# -------
use strict;
use Carp qw( croak carp );
use Data::Dumper;
use File::Basename qw(dirname);
use Cwd;

# -------
# Imports libs
# -------
use Parse::RecDescent;
use ScriptCooker::Log 2.1.0 qw{$logger _t};



####################################################
## Méthodes statiques
####################################################

# ------------------------------------------
# Nom : Condition::new
#
# Description :
# Charge le parser de la grammaire des conditions
# Analyse le texte et le convertit en liste d'opérations RPN
#
# Arguments :
#   - text_condition : texte à analyser selon la grammaire definie
#
# Retourne :
#   - tableau : operations sous forme RPN (Reverse Polish Notation)
# ------------------------------------------
sub parse (){
    my $self = shift;

    # pas de creation d'objet, methode statique
    #$self = fields::new($self);

    # traitement des arguments
    if (@_ != 1) {
        croak ('usage: '.__PACKAGE__.'->parse($text)');
    }
    my $text_condition = shift;

    # decommenter ci-dessous pour forcer la compilation
    #$self->precompile();

    # decommenter ci-dessous pour afficher les informations de parsing
    #$::RD_TRACE = 1;
    # affiche des indications sur l'erreur à l'utilisateur
    $::RD_HINT=1;

    # charge le parser généré à partir de la grammaire
    eval { require ScriptCooker::ITable::ConditionParser };
    if ($@) {
        # pas réussi à charger, on tente de le recompiler
        $self->precompile();
        die("Relancer le programme");

    }

    # créé l'objet parser
    my $parser = ScriptCooker::ITable::ConditionParser->new();

    if (! $parser) {
        die("Erreur interne de grammaire");
    }

    # lance l'analyse
    my $return_prn = $parser->expression(\$text_condition);

    if ( $text_condition || ! $return_prn ) {
        croak("La condition de selection n'est pas valide : $text_condition");
    }

    #use Data::Dumper;print STDERR Dumper($return_prn)."\n";

    return @{ $return_prn };
}


# ------------------------------------------
# Nom : Condition::precompile
#
# Description :
# Compile la grammaire (variable $grammar) en un fichier ConditionParser.pm
#   utilisable directement comme un objet Perl
#
# Arguments :
#
# Retourne :
# ------------------------------------------
sub precompile {
    my $self=shift;

    
    $logger->notice("Create or update parser ConditionParser.pm");

    # grammaire decrivant le langage de selection par condition
    # Genere un tableau en notation polonaise inversee
    # Pour distinguer operateur et valeurs, les operateurs sont des references
    my $grammar = <<'_GRAMMAR' ;

expression:
        AND_expression(s /[Oo][Rr]/)
            {
                #ici $item = [ AND_expression, AND_expression, ... ]

                #on met le premier sur la pile
                my $first_or = shift @{ $item[1] };
                push @{ $return } , @{ $first_or };

                # s'il y a d'autres clauses OR on les mets sur la pile
                # avec l'opÃ©rateur
                foreach ( @{ $item[1]} ) {
                    push @{ $return } , @{ $_ }, \"OR" 
                }

                # doit renvoyer True !
                1;
            }

AND_expression:
        operator_expression(s /[Aa][Nn][Dd]/)
            {
                #ici $item = [ operator_expression, operator_expression, ... ]

                #on met le premier sur la pile
                my $first_or = shift @{ $item[1] };
                push @{ $return } , @{ $first_or };

                # s'il y a d'autres clauses AND on les mets sur la pile
                # avec l'opÃ©rateur
                foreach ( @{ $item[1]} ) {
                    push @{ $return } , @{ $_ }, \"AND" 
                }

                # doit renvoyer True !
                1;
            }

operator_expression:
        IDENTIFIER OP strings
            { push @{ $return } , @{ $item{strings} },
                    $item{IDENTIFIER}, \"FIELD", \$item{OP} }
|       '(' expression ')'
            { push @{ $return } , @{ $item{expression} }}

strings:
        QUOTED_VALUE
            { $item{QUOTED_VALUE} =~ s/^'(.*)'/$1/;
              push @{ $return } , $item{QUOTED_VALUE}, \"VALUE" }
|       DB_QUOTED_VALUE
            { $item{DB_QUOTED_VALUE} =~ s/^"(.*)"/$1/;
              push @{ $return } , $item{DB_QUOTED_VALUE}, \"VALUE" }
|        VALUE(s)
            { push @{ $return } , join(' ',@{ $item[1] }), \"VALUE" }


OP :        /(=|!=|<=|>=|<|>|~|!~)/
IDENTIFIER: /[A-Za-z0-9_]+/

VALUE:      /
                (?!([Aa][Nn][Dd]|[Oo][Rr])[^a-zA-Z_])  # pas AND ou OR
                [^\(\)\s]+                             # sauf espace et ()
            /x 

QUOTED_VALUE: /'
                ([^']                # None of these
                |\\[\\ntvbrfa'"])*   # or a backslash followed by one of those
              '/x
DB_QUOTED_VALUE: /"
                ([^"]                # None of these
                |\\[\\ntvbrfa'"])*   # or a backslash followed by one of those
              "/x


_GRAMMAR

    # sauvegarde du repertoire actuel
    my $old_pwd=getcwd();
    # recherche du repertoire de destination
    my $new_pwd=dirname($INC{"BV/ITable/Condition.pm"});

    chdir $new_pwd;
    Parse::RecDescent->Precompile($grammar, "ScriptCooker::ITable::ConditionParser");
    chdir $old_pwd;
}

if (!caller()) {

    # si appelé comme un programme, lance la compilation
    require ScriptCooker::ITable::Condition;
    ScriptCooker::ITable::Condition->precompile();
}

1;
