#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Test::DNS' ) || print "Bail out!
";
}

diag( "Testing Test::DNS $Test::DNS::VERSION, Perl $], $^X" );
