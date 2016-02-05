%The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
%
%Find the sum of all the primes below two million.
%
-module(soln10).
-import(shared_euler, [isprime/1]).
-export([solve/0]).

solve() ->
    Ps = [I || I <- lists:seq(1, 2000000), isprime(I) == true],
    lists:foldl(fun(X, Sum) -> X + Sum end, 0, Ps).

