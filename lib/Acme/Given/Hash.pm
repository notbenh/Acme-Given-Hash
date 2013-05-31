package Acme::Given::Hash;
use strict;
use warnings;
require 5.014;
use List::MoreUtils qw{natatime};
use Exporter qw{import};
use v5.10;
no if $] >= 5.018, warnings => "experimental::smartmatch";
our @EXPORT = qw{gvn};

#ABSTRACT: is given() too much typing for you?

sub gvn ($) {
  my $when = shift;
  # old hashref notation
  if ( ref($when) eq 'HASH' ) {
    return bless {exact => $when, calculate => []}, 'Acme::Given::Hash::Object';
  }
  # new arrayref notation
  elsif ( ref($when) eq 'ARRAY' ) {
    my $input = natatime 2, @{ $_[0] };
    my $self = {exact=>{}, calculate=>[]};
    my $it = natatime 2, @$when;
    while (my @pairs = $it->()) {
      if( ref($pairs[0]) eq '' ) {
        $self->{exact}->{$pairs[0]} = $pairs[1];
      }
      else {
        push @{ $self->{calculate} }, {match => $pairs[0], value => $pairs[1]};
      }
    }
    return bless $self, 'Acme::Given::Hash::Object';
  }
  die 'gvn only takes hashrefs and arrayrefs, you have passed soemthing else';
}

package Acme::Given::Hash::Object;
use strict;
use warnings;
use v5.10;
no if $] >= 5.018, warnings => "experimental::smartmatch";

use overload '~~' => sub{
  my ($self, $key) = @_;
  if( exists $self->{exact}->{$key} ){
    return ref($self->{exact}->{$key}) eq 'CODE'
         ?  $self->{exact}->{$key}->()
         :  $self->{exact}->{$key}
         ;
  }

  foreach my $pair (@{ $self->{calculate} } ) {
    my $match;
    # 'string' ~~ [1..10] thows a warning, this disables this just for the check
    { no warnings qw{numeric};
      $match = $key ~~ $pair->{match};
    }

    if( $match ){
      return ref($pair->{value}) eq 'CODE'
           ?  $pair->{value}->()
           :  $pair->{value}
           ;
    }
  }
  return undef; # no matches found
};

1;
