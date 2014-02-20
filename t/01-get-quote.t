#!perl -T

use strict;
use warnings;

use Test::More tests => 3;
use WWW::BashOrg;

my $b = WWW::BashOrg->new;
isa_ok($b, 'WWW::BashOrg');

my $q = $b->get_quote(443);

my $expected = "<VicViper> dorm = jail cell with internet\r\n<SYc"
    . "h0> w/ fast internet";

SKIP:{
    if ( $b->error and $b->error =~ /^Network/ ) {
        skip 2, 'Got network error: ' . $b->error;
    }

    is( $q, $expected, 'Got an expected quote' );
    is( "$b", $expected, 'Got an expected quote (interpolating object)' );
}