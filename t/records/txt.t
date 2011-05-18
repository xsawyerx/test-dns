#!perl

use strict;
use warnings;

use Test::More tests => 1;
use Test::DNS;

my $dns = Test::DNS->new();

# TXT in hash
$dns->is_txt( {
    'godaddy.com' => 'v=spf1 include:spf.secureserver.net -all',
} );

