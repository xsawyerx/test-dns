#!/usr/bin/perl

use strict;
use warnings;

use Test::DNS;
use Test::More tests => 3;
use Test::Deep::NoTest;

my $dns   = Test::DNS->new( warnings => 0 );
my @p_ips = qw/207.171.7.63/;

$dns->is_cname( 'www.perl.org' => 'x3.develooper.com' );
$dns->is_a( 'x3.develooper.com' => \@p_ips );

$dns->follow_cname(1);
$dns->is_a( 'www.perl.org' => \@p_ips );
