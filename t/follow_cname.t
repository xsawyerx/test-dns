#!/usr/bin/perl

use strict;
use warnings;

use Test::DNS;
use Test::More;

plan 'skip_all' => 'requires AUTHOR_TESTING' unless $ENV{'AUTHOR_TESTING'};

my @p_ips = qw/151.101.18.217/;

subtest 'No following CNAME' => sub {
    my $dns   = Test::DNS->new();
    my $cname = 'cdn-fastly.perl.org';
    $dns->is_cname( 'www.perl.org' => $cname );
    $dns->is_a( $cname => \@p_ips );
};

subtest 'CNAME' => sub {
    my $dns = Test::DNS->new( 'follow_cname' => 1 );
    $dns->is_a( 'www.perl.org' => \@p_ips );
};

done_testing();
