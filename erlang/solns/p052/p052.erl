%It can be seen that the number, 125874, and its double, 251748, contain exactly the same digits,
%but in a different order.
%
%Find the smallest positive integer, x, such that 2x, 3x, 4x, 5x, and 6x, contain the same digits.

-module(p052).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p052, solve, []).

solve() ->
    recurseup(1).

recurseup(I) ->
    case eulermath:is_perm_of(I, 2*I) andalso
         eulermath:is_perm_of(I, 3*I) andalso
         eulermath:is_perm_of(I, 4*I) andalso
         eulermath:is_perm_of(I, 5*I) andalso
         eulermath:is_perm_of(I, 6*I) of
         true -> I;
         false -> recurseup(I+1)
    end.
