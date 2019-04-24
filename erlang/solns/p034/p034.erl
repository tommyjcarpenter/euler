%145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.
%
%Find the sum of all numbers which are equal to the sum of the eulermath:factorial of their digits.
%
%Note: as 1! = 1 and 2! = 2 are not sums they are not included.

-module(p034).
-export([solve/0]).

solve() ->
    goup(10, eulermath:factorial(9)).

goup(I, NFac) ->
    DigList = eulermath:digitize(I),
    FS = lists:sum(lists:map(fun(X) -> eulermath:factorial(X) end, DigList)),
    NinesSum = NFac*length(DigList), %the biggest FS can possibly be. if I already greater than this, there is no hope. When I rolls over and we have another digit, it will get multiplied by more than 9!. 
    if I > NinesSum -> 0;
    true -> if FS =:= I -> I + goup(I+1, NFac);
            true -> goup(I+1, NFac)
            end
    end.
