%The Fibonacci sequence is defined by the recurrence relation:
%
%Fn = Fn−1 + Fn−2, where F1 = 1 and F2 = 1.
%It turns out that F541, which contains 113 digits, is the first Fibonacci number for which the last
%nine digits are 1-9 pandigital (contain all the digits 1 to 9, but not necessarily in order). And
%F2749, which contains 575 digits, is the first Fibonacci number for which the first nine digits are
%1-9 pandigital.
%
%Given that Fk is the first Fibonacci number for which the first nine digits AND the last nine
%digits are 1-9 pandigital, find k.

-module(p104).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p104, solve, []).

solve() ->recurseup(1, 0, 1).

first9(N) ->
    if N < 1000000000 -> N;
    true -> first9(N div 10)
    end.

recurseup(N, Prev, Prev2) -> 
    F = Prev+Prev2,
    if F < 100000000 -> recurseup(N+1, F, Prev);
    true ->
           %check last 9 first
           L9 = F rem 1000000000,
           case  eulermath:is_pandigital_num(L9) of
               true -> 
                   F9 = first9(F),
                   case eulermath:is_pandigital_num(F9) of 
                       true -> N;
                       false -> recurseup(N+1, F, Prev)
                   end;
               false -> recurseup(N+1, F, Prev)
            end
    end.
