#!perl

use strict;
use warnings;

use Test::More;
use Test::DNS;

plan skip_all => 'requires AUTHOR_TESTING' unless $ENV{'AUTHOR_TESTING'};

my $dns = Test::DNS->new();

# the CNAME record of a domain
$dns->is_cname( 'mail.google.com' => 'googlemail.l.google.com' );

# CNAME in hash
$dns->is_cname( {
    'mail.google.com' => 'googlemail.l.google.com',
    'www.perl.org'   => 'dualstack.h2.shared.global.fastly.net',
} );

# CNAME in hash with test_name
$dns->is_cname( {
    'mail.google.com' => 'googlemail.l.google.com',
    'www.perl.org'   => 'dualstack.h2.shared.global.fastly.net',
}, 'Checking CNAMES for google.com and perl.org' );

done_testing();
