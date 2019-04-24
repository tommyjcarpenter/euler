-module(p036).
-export([timesolve/0, solve/0]).

%The decimal number, 585 = 10010010012 (binary), is palindromic in both bases.
%
%Find the sum of all numbers, less than one million, which are palindromic in base 10 and base 2.
%
%(Please note that the palindromic number, in either base, may not include leading zeros.)

timesolve() -> 
    erlang:display(timer:tc(p036, solve, [])).

solve() ->
    %first filter by those that are P in b10
    PinB10 = [X || X<-lists:seq(1,999999), eulermath:is_palindrome(X)],
    PinBoth = [X || X <- PinB10, eulermath:is_palindrome(eulermath:b10_to_2(X))],
    lists:sum(PinBoth).
