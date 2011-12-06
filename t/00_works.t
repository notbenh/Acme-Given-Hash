#!/usr/bin/env perl 
use strict;
use warnings;

use Test::More qw{no_plan};

require_ok q{Acme::Given::Hash};
use Acme::Given::Hash;

is 'this' ~~ gvn { this => 'that'} , 'that', q{works!};
is 'that' ~~ gvn { that => do{1+1}}, 2     , q{works!};
is 'that' ~~ gvn { that => sub{3}} , 3     , q{works!};

is 'that' ~~ gvn { moo  => 3 }     , undef , q{fails!};




