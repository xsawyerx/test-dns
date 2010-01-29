#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 18;
use Test::DNS;

my $dns = Test::DNS->new();

# the PTR record of an IP
$dns->is_ptr( '74.125.148.13' => 's9b1.psmtp.com' );
$dns->is_ptr( '74.125.148.13' => [ 's9b1.psmtp.com' ] );

# the NS record of a domain
$dns->is_ns( 'perl.com' => [ map { "nsauth$_.oreilly.com" } 'a', 'b' ] );

# the A record of NS records of a domain
$dns->is_a( 'ns1.google.com' => '216.239.32.10' );

# the MX records of a domain
$dns->is_mx( 'google.com' => [
    map { "google.com.s9$_.psmtp.com" } qw/ b1 b2 a1 a2 /,
] );

# the CNAME record of a domain
$dns->is_cname( 'www.google.com' => 'www.l.google.com' );

# hash-formatted parameter
# A in hash
$dns->is_a( {
    'ns1.google.com' => [ '216.239.32.10' ],
    'ns2.google.com' =>   '216.239.34.10',
} );

# NS in hash
$dns->is_ns( {
    'perl.com'      => [ map { "nsauth$_.oreilly.com" } 'a', 'b' ],
    'microsoft.com' => [ map { "ns$_.msft.net"        } 1 .. 5   ],
} );

# PTR in hash
$dns->is_ptr( {
    '74.125.148.13' =>   's9b1.psmtp.com',
    '65.55.88.22'   => [ 'mail.global.frontbridge.com' ],
} );

# MX in hash
$dns->is_mx( {
        'google.com' => [
            map { "google.com.s9$_.psmtp.com" } qw/ b1 b2 a1 a2 /,
        ],
        'microsoft.com' => 'mail.messaging.microsoft.com',
} );

# CNAME in hash
$dns->is_cname( {
    'www.google.com' => 'www.l.google.com',
    'www.perl.org'   => 'x3.develooper.com',
} );

# CNAME in hash with test_name
$dns->is_cname( {
    'www.google.com' => 'www.l.google.com',
    'www.perl.org'   => 'x3.develooper.com',
}, 'Checking CNAMES for google.com and perl.org' );

