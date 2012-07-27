#!/usr/bin/env perl 
use strict;
use warnings;

use Test::More qw{no_plan};

require_ok q{Acme::Given::Hash};
use Acme::Given::Hash;

#---------------------------------------------------------------------------
#  HASHREF notation
#---------------------------------------------------------------------------
is 'this' ~~ gvn { this => 'that'} , 'that', q{works!};
is 'that' ~~ gvn { that => do{1+1}}, 2     , q{works!};
is 'that' ~~ gvn { that => sub{3}} , 3     , q{works!};

is 'that' ~~ gvn { moo  => 3 }     , undef , q{fails!};

is 'that' ~~ gvn { moo  => 3 } || 'kitten' , 'kitten' , q{default};

#---------------------------------------------------------------------------
#  LIST NOTATION
#---------------------------------------------------------------------------
my $gvn = gvn [ that => 'this'];
is 'that' ~~ $gvn, 'this', 'list notation works!';
