package Test::DNS;

use Moose;
use Net::DNS;
use Test::Deep 'cmp_bag';
use base 'Test::Builder::Module';

has 'nameservers' => ( is => 'rw', isa => 'ArrayRef', default    => sub { [] } );
has 'object'      => ( is => 'ro', isa => 'Net::DNS::Resolver', lazy_build => 1 );

our $VERSION = '0.01';

my $CLASS = __PACKAGE__;

sub BUILD {
    $Test::Builder::Level += 1;
    return;
}

sub _build_object {
    my $self = shift;

    return Net::DNS::Resolver->new(
        nameservers => $self->nameservers,
    );
}

# A -> IP
sub is_a {
    my ( $self, $domain, $ips, $test_name ) = @_;
    $self->is_record( 'A', $domain, $ips, $test_name );
    return;
}

# PTR -> A
sub is_ptr {
    my ( $self, $ip, $domains, $test_name ) = @_;
    $self->is_record( 'PTR', $ip, $domains );
    return;
}

# Domain -> NS
sub is_ns {
    my ( $self, $domain, $ns, $test_name ) = @_;
    $self->is_record( 'NS', $domain, $ns );
    return;
}

sub get_method {
    my ( $self, $type ) = @_;
    my %method_by_type = (
        'A'   => 'address',
        'NS'  => 'nsdname',
        'PTR' => 'ptrdname',
    );

    my $method = $method_by_type{$type};
    return $method ? $method : 0;
}

sub is_record {
    my ( $self, $type, $input, $expected, $test_name ) = @_;

    my $res        = $self->object;
    my $tb         = $CLASS->builder;
    my $method     = $self->get_method($type);
    my $query_res  = $res->query( $input, $type );
    my $COMMASPACE = q{, };
    my @results    = ();

    ( ref $expected eq 'ARRAY' ) || ( $expected = [ $expected ] );
    $test_name ||= "[$type] $input -> " . join $COMMASPACE, @{$expected};

    if (!$query_res) {
        $self->_warn( $type, "'$input' has no query result" );
        $tb->ok( 0, $test_name );
        return;
    }

    my @records = $query_res->answer;

    foreach my $rr (@records) {
        if ( $rr->type ne $type ) {
            $self->_warn( $type, 'got incorrect RR type: ' . $rr->type );
        }

        push @results, $rr->$method;
    }

    cmp_bag( \@results, $expected, $test_name );

    return;
}

sub _warn {
    my ( $self, $type, $msg ) = @_;
    chomp $msg;
    my $tb = $CLASS->builder;
    $tb->diag("!! Warning: [$type] $msg !!");

    return;
}

1;

__END__

=head1 NAME

Test::DNS - Test DNS queries and zone configuration

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

This module helps you write tests for DNS queries. You could test your domain configuration in the world or on a specific DNS server, for example.

    use Test::DNS;
    use Test::More tests => 4;

    my $dns = Test::DNS->new();

    $dns->is_ptr( '1.2.3.4' => 'single.ptr.record.com' );
    $dns->is_ptr( '1.2.3.4' => [ 'one.ptr.record.com', 'two.ptr.record.com' ] );
    $dns->is_ns( 'google.com' => [ map { "ns$_.google.com" } 1 .. 4 ] );
    $dns->is_a( 'ns1.google.com' => '216.239.32.10' );

    ...

=head1 EXPORT

This module is completely Object Oriented, nothing is exported.

=head1 SUBROUTINES/METHODS

=head2 is_a

Check the A record resolving of domain or subdomain.

    $dns->is_a( 'domain' => 'IP' );

    $dns->is_a( 'domain', [ 'IP1', 'IP2' ] );

=head2 is_ns

Check the NS record resolving of a domain or subdomain.

    $dns->is_ns( 'domain' => 'IP' );

    $dns->is_ns( 'domain', [ 'IP1', 'IP2' ] );

=head2 is_ptr

Check the PTR records of an IP.

    $dns->is_ptr( 'IP' => 'ptr.records.domain' );

    $dns->is_ptr( 'IP', [ 'first.ptr.domain', 'second.ptr.domain' ] );

=head1 DEPENDENCIES

L<Moose>

L<Net::DNS>

L<Test::Deep>

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-dns at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-DNS>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::DNS

You can also look for information at:

=over 4

=item * Github

L<http://github.com/xsawyerx/test-dns>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-DNS>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-DNS>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-DNS>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-DNS/>

=back

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Sawyer X.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

