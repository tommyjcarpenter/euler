%Surprisingly there are only three numbers that can be written as the sum of fourth powers of their
%digits:
%
%1634 = 14 + 64 + 34 + 44
%8208 = 84 + 24 + 04 + 84
%9474 = 94 + 44 + 74 + 44
%As 1 = 14 is not a sum it is not included.
%
%The sum of these numbers is 1634 + 8208 + 9474 = 19316.
%
%Find the sum of all the numbers that can be written as the sum of fifth powers of their digits.


-module(p030).
-export([solve/0]).
-import(math, [pow/2]).

solve() ->
    goup(10, pow(9,5)).

goup(I, N5) ->
    DigList = eulermath:digitize(I),
    PS = lists:sum(lists:map(fun(X) -> pow(X, 5) end, DigList)),
    NinesSum = N5*length(DigList), %see p34 explanation
    erlang:display(NinesSum),
    erlang:display(PS),
    if I > NinesSum -> 0;
    true -> if PS == I -> I + goup(I+1, N5);
            true -> goup(I+1, N5)
            end
    end.
