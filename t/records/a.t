#!perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::DNS;

my $dns = Test::DNS->new();

# the A record of NS records of a domain
$dns->is_a( 'ns1.google.com' => '216.239.32.10' );

# hash-formatted parameter
# A in hash
$dns->is_a( {
    'ns1.google.com' => [ '216.239.32.10' ],
    'ns2.google.com' =>   '216.239.34.10',
} );

