#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;
use Test::DNS;

my $dns = Test::DNS->new();

TODO: {
    local $TODO = 'not implemented yet';

    # hash-formatted parameter
    $dns->is_a( {
        'ns1.google.com' => [ 'ip', 'ip', 'ip' ],
        'ns2.google.com' => [ 'ip', 'ip', 'ip' ],
    } );

}
