#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;
use Test::DNS;

my $dns = Test::DNS->new();

# the PTR record of an IP
$dns->is_ptr( '74.125.148.13' => 's9b1.psmtp.com' );
$dns->is_ptr( '74.125.148.13' => [ 's9b1.psmtp.com' ] );

# the NS record of a domain
$dns->is_ns( 'google.com' => [ map { "ns$_.google.com" } 1 .. 4 ] );

# the A record of NS records of a domain
$dns->is_a( 'ns1.google.com' => '216.239.32.10' );

# the MX records of a domain
$dns->is_mx( 'google.com' => [
    map { "google.com.s9$_.psmtp.com" } qw/ b1 b2 a1 a2 /,
] );

# the CNAME record of a domain
$dns->is_cname( 'www.google.com' => 'www.l.google.com' );

