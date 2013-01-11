#!perl -T

use Test::More tests => 3;

# test du chargement du module principale
BEGIN {
    use_ok( 'ScriptCooker::ITools' ) || print "Bail out!
";
    use_ok( 'ScriptCooker::Utils' ) || print "Bail out!
";
}

diag( "Testing ScriptCooker::ITools $ScriptCooker::ITools::VERSION, Perl $], $^X" );

# test de chargement de IPC::Run3 necessaire pour les tests
BEGIN {
	use_ok('IPC::Run3') || print "Bail out!;
";
}
