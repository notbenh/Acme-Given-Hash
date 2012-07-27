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
my $found = {foo=>bar=>};
my $gvn = gvn [ that  => 'this'
              , qr{x} => 'found an x'
              , [1..5]=> 'one thru five'
              , { foo => 1 , bar => 2 } => $found
              , gvn { ruby => 'matz'
                    , perl => 'lary'
                    } => 'language'
              ];
is 'that'       ~~ $gvn, 'this'          , 'list notation works with a scalar!';
is 'found an x' ~~ $gvn, 'found an x'    , 'list notation works with a regex!';
is 3            ~~ $gvn, 'one thru five' , 'list notation works with an aref!';
is_deeply 'foo' ~~ $gvn, $found          , 'list notation works with a href!';
is 'perl'       ~~ $gvn, 'language'      , 'list notation works with an object!';

is 'kitten'     ~~ $gvn, undef           , 'list notation fails!';

is 'kitten' ~~ $gvn || 'puppy', 'puppy'  , 'list notation fails with default with || case!';
