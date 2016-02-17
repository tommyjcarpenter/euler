%The arithmetic sequence, 1487, 4817, 8147, in which each of the terms increases by 3330, is unusual
%in two ways: (i) each of the three terms are prime, and, (ii) each of the 4-digit numbers are
%permutations of one another.
%
%There are no arithmetic sequences made up of three 1-, 2-, or 3-digit primes, exhibiting this
%property, but there is one other 4-digit increasing sequence.
%
%What 12-digit number do you form by concatenating the three terms in this sequence?

-module(p049).
-export([solve/0]).

solve() ->
    Ps = shared_euler:seive(10000),
    [{X, Y, Z} || X <- Ps, X > 999,
                  Y <- Ps, Y > 999,
                  Z <- Ps, Z > 999,
                  Z - Y =:= Y - X, 
                  shared_euler:is_perm_of(X, Y),
                  shared_euler:is_perm_of(Y, Z),
                  X < Y,
                  Y < Z].
