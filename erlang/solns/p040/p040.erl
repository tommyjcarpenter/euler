%An irrational decimal fraction is created by concatenating the positive integers:
%
%0.123456789101112131415161718192021...
%
%It can be seen that the 12th digit of the fractional part is 1.
%
%If dn represents the nth digit of the fractional part, find the value of the following expression.
%
%d1 × d10 × d100 × d1000 × d10000 × d100000 × d1000000

%not sure why the fraction part of this is important,
%seems like just an int will work...
%
-module(p040).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p040, solve, []).

solve() ->
    L = lists:flatten(form_linked_list(1,0,1000000)),
    lists:nth(1,L)*lists:nth(10,L)*lists:nth(100,L)*lists:nth(1000,L)*lists:nth(10000,L)*lists:nth(100000,L)*lists:nth(1000000,L).

form_linked_list(CurInt, DigSoFar, DigitsTarget) ->
    if DigSoFar > DigitsTarget -> [];
    true ->
        L = eulermath:digitize(CurInt),
        [L | form_linked_list(CurInt+1, DigSoFar+length(L), DigitsTarget)]
    end.
        


