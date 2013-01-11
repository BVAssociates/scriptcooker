#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;

use ScriptCooker::Utils;
source_profile('t/sample/profile.RT.minimal');


use ScriptCooker::ITable;

############################
# ScriptCooker::ITable->open
############################

my $itable = ScriptCooker::ITable->open('error_messages');
ok($itable, 'ScriptCooker::ITable->open()');

############################
# ScriptCooker::ITable::Ft->fetch_row
############################

my $fetch_row_expected = {
          'Error' => '1',
          'Message' => 'test sans quote',
          'Function' => 'TEST'
        };


my $fetch_row = { $itable->fetch_row() };
is_deeply($fetch_row, $fetch_row_expected, 'ScriptCooker::ITable::Ft->fetch_row()');


############################
# ScriptCooker::ITable::Ft->close
############################

$itable->close();

$fetch_row = { $itable->fetch_row() };
is_deeply($fetch_row, $fetch_row_expected, 'ScriptCooker::ITable::Ft->fetch_row() après ScriptCooker::ITable::Ft->close()');

$itable->close();

############################
# Accès concurent
############################

# lancement d'une tache de fond qui va locker la table
system('perl -MScriptCooker::ITable -e \'$t=ScriptCooker::ITable->open("error_messages");'
                             .'$t->fetch_row(); sleep 10;\' & ');
ok($? == 0, "Lancement de ScriptCooker::ITable::Ft->fetch_row() en tâche de fond");
# attend que le processus soit lancé
sleep 2;

$fetch_row = { $itable->fetch_row() };
is_deeply($fetch_row, $fetch_row_expected, 'ScriptCooker::ITable::Ft->fetch_row() sur verrou partagé');

$itable->close();

eval { $itable->insert_row_array(qw(TEST 10 TEST)) };
ok($@, 'ScriptCooker::ITable::Ft->insert_row() sur un verrou partagé');
diag($@);



