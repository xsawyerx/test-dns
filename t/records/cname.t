#!perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::DNS;

my $dns = Test::DNS->new();

# the CNAME record of a domain
$dns->is_cname( 'www.google.com' => 'www.l.google.com' );

# CNAME in hash
$dns->is_cname( {
    'www.google.com' => 'www.l.google.com',
    'www.perl.org'   => 'varnish-lb.develooper.com',
} );

# CNAME in hash with test_name
$dns->is_cname( {
    'www.google.com' => 'www.l.google.com',
    'www.perl.org'   => 'varnish-lb.develooper.com',
}, 'Checking CNAMES for google.com and perl.org' );


