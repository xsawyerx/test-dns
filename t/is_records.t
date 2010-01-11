#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::DNS;

my $dns = Test::DNS->new();

# the NS record of a domain
$dns->is_ns( 'google.com' => [ map { "ns$_.google.com" } 1 .. 4 ] );

# the A record of NS records of a domain
$dns->is_a( 'ns1.google.com' => '216.239.32.10' );

$dns->is_a( {
    'ns1.google.com' => [ 'ip', 'ip', 'ip' ],
    'ns2.google.com' => [ 'ip', 'ip', 'ip' ],
} );

