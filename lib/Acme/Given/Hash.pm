package Acme::Given::Hash;
use strict;
use warnings;
use Exporter qw{import};
our @EXPORT = qw{gvn};

#ABSTRACT: is given() too much typing for you?

sub gvn ($) {
  my $when = shift;
  die 'gvn requires a hashref' unless ref($when) eq 'HASH';
  return bless $when, 'Acme::Given::Hash::Object';
}

package Acme::Given::Hash::Object;
use strict;
use warnings;

use overload '~~' => sub{ 
  my ($self, $key) = @_;
  return ref($self->{$key}) eq 'CODE' 
       ? $self->{$key}->() 
       : $self->{$key};
};

1;
