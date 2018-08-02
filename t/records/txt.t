#!perl

use strict;
use warnings;

use Test::More;
use Test::DNS;

plan skip_all => 'requires AUTHOR_TESTING' unless $ENV{'AUTHOR_TESTING'};

my $dns = Test::DNS->new();

# TXT in hash
$dns->is_txt( {
    'godaddy.com' => [ '2a45ru87chs6nhv27gdqngf8k',
                       '2d0rdkunbj9p7091ngqg6evdn1',
                       '2hi8r7d3pk4bs957dd39cokgcb',
                       '2rjtnv1sssfm5j74g8nm5h1g3d',
                       '3irs7snc5skkhnj097aenspegc',
                       '5d2309ht80u30f4nirdm5aspps',
                       '6lkruf960d04qo2t20upe39qgo',
                       '7aqjms9d0u56v223jnm2634e8v',
                       '7oZZbMavd5aj2djFeYFY58d1EAodffVMC9RJbSpi9zw4i8R9dVR+LZ4Xcdy4QNMH8t4G/bHO/yPVRxW9Q01lNQ==',
                       '8oklrp9tjp3l0u405gp93rbsk0',
                       'IPROTA_D17829-XXX.TXT',
                       'MS=ms83569812',
                       'a40s42h4g046o5li509peke464',
                       'adobe-idp-site-verification=2a5d58f1-1f72-48f5-9dee-65553c77beea',
                       'dropbox-domain-verification=xl2s10u0jrq0',
                       'lhscuoepa72tkutgmvrjf4bgr2',
                       'lt733netied61g2n8el728djv4',
                       'm6hugln5oed61usbilj80t08pt',
                       'mailru-verification: 51155022e43530db',
                       'pejiu4ubbprb1kaa2g3s2d7kdc',
                       'pnfrs6788jopil2a8m5poa1nd8',
                       'rokanf6dp2md3due8rqeqlsh32',
                       'tsd5veiu1sjc5spsj9ogm0lfnm',
                       'v=spf1 ip4:207.200.21.144/28 ip4:12.151.77.31 ip4:69.64.33.132 ip4:68.233.77.16 ip4:184.168.131.0/24 ip4:173.201.192.0/24 ip4:182.50.132.0/24 ip4:170.146.0.0/16 ip4:174.128.1.0/24 ip4:173.201.193.0/24 include:spf-2.domaincontrol.com -all' ],
} );

done_testing();

