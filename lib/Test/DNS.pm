package Test::DNS;

use Moose;
use Net::DNS;
use Test::Deep 'cmp_bag';
use Set::Object 'set';
use base 'Test::Builder::Module';

has 'nameservers' => ( is => 'rw', isa => 'ArrayRef', default    => sub { [] } );
has 'object'      => ( is => 'ro', isa => 'Net::DNS::Resolver', lazy_build => 1 );

has 'follow_cname' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'warnings'     => ( is => 'rw', isa => 'Bool', default => 1 );

our $VERSION = '0.02';

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

# Domain -> MX
sub is_mx {
    my ( $self, $domain, $mx, $test_name ) = @_;
    $self->is_record( 'MX', $domain, $mx );
    return;
}

# Domain -> CNAME
sub is_cname {
    my ( $self, $domain, $cname, $test_name ) = @_;
    $self->is_record( 'CNAME', $domain, $cname );
    return;
}

sub _get_method {
    my ( $self, $type ) = @_;
    my %method_by_type = (
        'A'     => 'address',
        'NS'    => 'nsdname',
        'MX'    => 'exchange',
        'PTR'   => 'ptrdname',
        'CNAME' => 'cname',
    );

    my $method = $method_by_type{$type};
    return $method ? $method : 0;
}

sub _recurse_a_records {
    my ( $self, $set, $rr ) = @_;
    my $res = $self->object;

    if ( $rr->type eq 'CNAME' ) {
        my $cname_method = $self->_get_method('CNAME');
        my $cname        = $rr->$cname_method;
        my $query        = $res->query( $cname, 'A' );

        if ($query) {
            my @records = $query->answer;
            foreach my $record (@records) {
                $self->_recurse_a_records( $set, $record );
            }
        }
    } elsif ( $rr->type eq 'A' ) {
        my $a_method = $self->_get_method('A');
        $set->insert( $rr->$a_method );
    }

    return;
}

sub is_record {
    my ( $self, $type, $input, $expected, $test_name ) = @_;

    my $res        = $self->object;
    my $tb         = $CLASS->builder;
    my $method     = $self->_get_method($type);
    my $query_res  = $res->query( $input, $type );
    my $COMMASPACE = q{, };
    my $results    = set();

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
            if ( $rr->type eq 'CNAME' && $self->follow_cname ) {
                $self->_recurse_a_records( $results, $rr );
            } else {
                $self->_warn( $type, 'got incorrect RR type: ' . $rr->type );
            }
        } else {
            $results->insert( $rr->$method );
        }
    }

    cmp_bag( [ $results->members ], $expected, $test_name );

    return;
}

sub _warn {
    my ( $self, $type, $msg ) = @_;

    $self->warnings || return;

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

Version 0.02

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

=head1 ATTRIBUTES

=head2 nameservers

Same as in L<Net::DNS>. Sets the nameservers, accepts an arrayref.

    $dns->nameservers( [ 'IP1', 'DOMAIN' ] );

=head2 warnings

Do you want to output warnings from the module, such as when a record doesn't a query result or incorrect types?

This helps avoid common misconfigurations. You should probably keep it, but if it bugs you, you can stop it using:

    $dns->warnings(0);

Default: 1 (on).

=head2 follow_cname

When fetching an A record of a domain, it may resolve to a CNAME instead of an A record. That would result in a false-negative of sorts, in which you say "well, yes, I meant the A record the CNAME record points to" but L<Test::DNS> doesn't know that.

If you want want Test::DNS to follow every CNAME till it reaches the actual A record and compare B<that> A record, use this option.

    $dns->follow_cname(1);

Default: 0 (off).

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

=head2 is_mx

Check the MX records of a domain.

    $dns->is_mx( 'domain' => 'mailer.domain' );

    $dns->is_ptr( 'domain', [ 'mailer1.domain', 'mailer2.domain' ] );

=head2 is_cname

Check the CNAME records of a domain.

    $dns->is_cname( 'domain' => 'sub.domain' );

    $dns->is_cname( 'domain', [ 'sub1.domain', 'sub2.domain' ] );

=head2 is_record

The general function all the other is_* functions run.

    $dns->is_record( 'CNAME', 'domain', 'sub.domain', 'test_name' );

=head1 DEPENDENCIES

L<Moose>

L<Net::DNS>

L<Test::Deep>

L<Set::Object>

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

