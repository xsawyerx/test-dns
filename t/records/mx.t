#!perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::DNS;

my $dns = Test::DNS->new();

# the MX records of a domain
$dns->is_mx( 'google.com' => [
    'aspmx.l.google.com',
    map { "alt$_.aspmx.l.google.com" } 1 .. 4,
] );

# MX in hash
$dns->is_mx( {
        'google.com' => [
            'aspmx.l.google.com',
            map { "alt$_.aspmx.l.google.com" } 1 .. 4,
        ],
        'microsoft.com' => 'mail.messaging.microsoft.com',
} );

