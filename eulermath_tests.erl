-module(eulermath_tests).
-include_lib("eunit/include/eunit.hrl").

-import(eulermath, [b10_to_2/1]).

b10_to_2_test() ->
    ?assert(b10_to_2(585) == 1001001001),
    ?assert(b10_to_2(666) == 1010011010),
    ?assert(b10_to_2(8937245987234598) == 11111110000000110000010111100010101101110001100100110).
 
