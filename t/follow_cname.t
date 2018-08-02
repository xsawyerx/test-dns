#!/usr/bin/perl

use strict;
use warnings;

use Test::DNS;
use Test::More;

plan skip_all => 'requires AUTHOR_TESTING' unless $ENV{'AUTHOR_TESTING'};

my $dns   = Test::DNS->new( warnings => 0 );

my $cname = 'dualstack.h2.shared.global.fastly.net';
my @p_ips = qw/151.101.186.49/;

$dns->is_cname( 'www.perl.org' => $cname );
$dns->is_a( $cname => \@p_ips );

$dns->follow_cname(1);
$dns->is_a( 'www.perl.org' => \@p_ips );

done_testing();
