-module(eulerlist_tests).
-include_lib("eunit/include/eunit.hrl").

-import(eulerlist, [is_repeating/1,
                   num_distinct_elements/1]).

do_is_repeating_test() ->
    ?assert(is_repeating([1,2,3,1,2,3]) == {[1,2,3],3}),
    ?assert(is_repeating([1,2,3,1,2,3,1]) == {[1,2,3],3}),
    ?assert(is_repeating([1,2,3,1,2,3,1,2]) == {[1,2,3],3}),
    ?assert(is_repeating([1,2,3,1,2,3,1,4]) == {[],0}),
    ?assert(is_repeating([1,2,3,1,2,3,1,2,4]) == {[],0}),
    ?assert(is_repeating([1,1,1,1,1]) == {[1],1}),
    ?assert(is_repeating([1,2,1,2,1]) == {[1,2],2}),
    ?assert(is_repeating([1,2,1,3,1]) == {[],0}),
    ?assert(is_repeating([1,2,1,2,1,2,1,2]) == {[1,2],2}).

num_distinct_elements_test() ->
    ?assert(num_distinct_elements([1,2,1]) == 2).
