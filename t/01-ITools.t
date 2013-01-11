#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use ScriptCooker::Utils;
source_profile('t/sample/profile.RT.minimal');


use ScriptCooker::ITools;

############################
# define_table
############################

my $define_expected = {
          'DEFFILE' => 'TOOLS_HOME/def/error_messages.def',
          'FILE' => 'TOOLS_HOME/tab/error_messages',
          'FORMAT' => 'Function;Error;Message',
          'SIZE' => '20s;4n;80s',
          'KEY' => 'Function;Error',
          'TABLE' => 'error_messages',
          'TYPE' => 'FT',
          'ROW' => '$Function;$Error;$Message',
          'COMMAND' => '',
          'HEADER' => 'Liste des messages d\'erreur de variable evaluee',
          'SORT' => '',
          'NOTNULL' => 'Function;Error;Message',
          'SEP' => ';'
        };

my $define = { define_table("error_messages") };

map { s/\Q$ENV{TOOLS_HOME}\E/TOOLS_HOME/g } values %{ $define };

is_deeply($define, $define_expected, 'define_table("error_messages")');


############################
# select_from_table
############################

my $select_expected = [
          {
            'ID' => '1',
            'Bool' => '1',
            'Pourcentage' => '20',
            'Description' => 'premier',
            'Date' => '20110101120000'
          },
          {
            'ID' => '2',
            'Bool' => '0',
            'Pourcentage' => '40',
            'Description' => 'deuxieme',
            'Date' => '20120101120000'
          },
          {
            'ID' => '3',
            'Bool' => 'o',
            'Pourcentage' => '60',
            'Description' => 'troisieme',
            'Date' => '20100101120000'
          },
          {
            'ID' => '4',
            'Bool' => 'Y',
            'Pourcentage' => '80',
            'Description' => 'quatrieme',
            'Date' => '20110101140001'
          },
          {
            'ID' => '5',
            'Bool' => 'Y',
            'Pourcentage' => '90',
            'Description' => 'cinquieme',
            'Date' => '20110101140002'
          },
          {
            'ID' => '6',
            'Bool' => 'Y',
            'Pourcentage' => '100n',
            'Description' => 'sixieme',
            'Date' => '20110101140003'
          },
          {
            'ID' => '7',
            'Bool' => 'Y',
            'Pourcentage' => '10',
            'Description' => 'septieme',
            'Date' => '20110101140004X'
          },
          {
            'ID' => '8',
            'Bool' => 'errror_bool',
            'Pourcentage' => '10',
            'Description' => 'huitieme',
            'Date' => '20110101140004'
          },
          {
            'ID' => 'toto',
            'Bool' => '0',
            'Pourcentage' => '20',
            'Description' => 'mauvais ID',
            'Date' => '20110101140005'
          }
        ];


my $select = [ select_from_table("table_simple") ];
is_deeply($select, $select_expected, 'select_from_table("table_simple")');


