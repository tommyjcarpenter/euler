-module(eulermath_tests).
-include_lib("eunit/include/eunit.hrl").

-import(eulermath, [b10_to_2/1,
                    isprime/1,
                    pascal/1]).

b10_to_2_test() ->
    ?assert(b10_to_2(585) == 1001001001),
    ?assert(b10_to_2(666) == 1010011010),
    ?assert(b10_to_2(8937245987234598) == 11111110000000110000010111100010101101110001100100110).

isprime_test() ->
    ?assert(isprime(11) == true),
    ?assert(isprime(-11) == false),
    ?assert(isprime(-2) == false),
    ?assert(isprime(2) == true).

pasal_test() ->
    ?assert(pascal(3) == [[1],[1,1],[1,2,1],[1,3,3,1]]),
    ?assert(pascal(5) == [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1],[1,5,10,10,5,1]]),
    ?assert(pascal(7) == [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1],[1,5,10,10,5,1],[1,6,15,20,15,6,1],[1,7,21,35,35,21,7,1]]).
