package Acme::Given::Hash;
use strict;
use warnings;
require 5.014;
use List::MoreUtils qw{natatime};
use Exporter qw{import};
our @EXPORT = qw{gvn};

#ABSTRACT: is given() too much typing for you?

sub gvn ($) {
  my $when = shift;
  # old hashref notation 
  if ( ref($when) eq 'HASH' ) {
    return bless {exact => shift, calculate => []}, 'Acme::Given::Hash::Object';
  }
  # new arrayref notation 
  elsif ( ref($when) eq 'ARRAY' ) {
    my $input = natatime 2, @{ $_[0] };
    my $self = {exact=>{}, calculate=>[]};
    my $it = natatime 2, @_;
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


use overload '~~' => sub{ 
  my $ror = sub {
    my $thing = shift;
warn qq{ ROR: $thing};
    return $thing->() if ref($thing) eq 'CODE';
    return $thing;
  };
  my ($self, $key) = @_;
  if( exists $self->{exact}->{$key} ){
    return ref($self->{exact}->{$key}) eq 'CODE'
         ?  $self->{exact}->{$key}->()
         :  $self->{exact}->{$key} 
         ;
  }

  foreach my $pair (@{ $self->{calculate} } ) {
    if( $pair->{match} ~~ $key ) {
      return ref($pair->{value}) eq 'CODE'
           ?  $pair->{value}->{$key}->()
           :  $pair->{value}->{$key} 
           ;
    }
  }
  return undef; # no matches found 
};

1;
