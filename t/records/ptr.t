#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Test::DNS;

my $dns = Test::DNS->new();

# the PTR record of an IP
$dns->is_ptr( '74.125.148.13' => 's9b1.psmtp.com' );
$dns->is_ptr( '74.125.148.13' => [ 's9b1.psmtp.com' ] );

# PTR in hash
$dns->is_ptr( {
    '74.125.148.13' =>   's9b1.psmtp.com',
    '65.55.88.22'   => [ 'mail.global.frontbridge.com' ],
} );

