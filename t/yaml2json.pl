#!/usr/bin/env perl

use Modern::Perl;
use JSON::PP qw( encode_json );
use YAML::Syck qw(Load);
use Data::Dump qw( dump );

my $yaml;
while (<>) {
    $yaml .= $_;
}
#say $yaml;

my @ref = Load( $yaml );
#say dump \@ref;



my %hash = ( );
foreach my $agent ( @ref ) {
    my $name = delete $agent->{useragent};
    $hash{ $name } = $agent; 
}

my $json = JSON::PP->new->ascii->pretty->allow_nonref->canonical(1)->encode( \%hash );
say $json;


#$json->canonical( 1 );

#print $json->encode_json( \%hash );
#say dump \%hash;

