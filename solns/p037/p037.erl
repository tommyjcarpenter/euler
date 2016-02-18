%The number 3797 has an interesting property. Being prime itself, it is possible to continuously remove digits from left to right, and remain prime at each stage: 3797, 797, 97, and 7. Similarly we can work from right to left: 3797, 379, 37, and 3.

%Find the sum of the only eleven primes that are both truncatable from left to right and right to left.

%NOTE: 2, 3, 5, and 7 are not considered to be truncatable primes.

-module(p037).
-export([solve/0]).

solve() ->
    Ps = eulermath:seive(1000000),
    erlang:display(lists:sum([X || X <- Ps, X > 9, truncatable(X)])).

truncatable(X) ->
    D = eulermath:digitize(X),
    primedown(D, false) andalso primedown(lists:reverse(D), true).

primedown([], Rev) -> true;
primedown([H|[]], Rev) -> eulermath:isprime(H);
primedown([_|T], Rev) -> 
    if Rev == false -> Trunc = eulermath:digit_list_to_integer(T);
    true -> Trunc = eulermath:digit_list_to_integer(lists:reverse(T))
    end,
    eulermath:isprime(Trunc) andalso primedown(T, Rev). 



