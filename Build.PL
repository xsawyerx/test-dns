use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::DNS',
    license             => 'perl',
    dist_author         => q{Sawyer X <xsawyerx@cpan.org>},
    dist_version_from   => 'lib/Test/DNS.pm',
    build_requires      => {
        'Test::More' => 0,
    },
    requires            => {
        'Moose'         => 0.80,
        'Net::DNS'      => 0.65,
        'Test::Deep'    => 0,
        'Test::Builder' => 0,
        'Set::Object'   => 0,
    },
    meta_merge          => {
        resources => {
            repository => 'http://github.com/xsawyerx/test-dns',
        },
        keywords   => [ 'DNS' ],
    },
    add_to_cleanup      => [ 'Test-DNS-*' ],
    create_makefile_pl  => 'traditional',
    create_license      => 1,
    create_readme       => 1,
);

$builder->create_build_script();
