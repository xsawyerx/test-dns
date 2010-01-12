#!/usr/bin/perl

use strict;
use warnings;

use Test::DNS;
use Test::More tests => 3;
use Test::Deep::NoTest;

my $dns   = Test::DNS->new( warnings => 0 );
my @g_ips = qw/74.125.77.104 74.125.77.99 74.125.77.147/;

$dns->is_cname( 'www.google.com' => 'www.l.google.com' );
$dns->is_a( 'www.l.google.com' => \@g_ips );

$dns->follow_cname(1);
$dns->is_a( 'www.google.com' => \@g_ips );
