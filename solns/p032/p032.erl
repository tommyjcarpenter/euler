%We shall say that an n-digit number is pandigital if it makes use of all the digits 1 to n exactly once; for example, the 5-digit number, 15234, is 1 through 5 pandigital.

%The product 7254 is unusual, as the identity, 39 × 186 = 7254, containing multiplicand, multiplier, and product is 1 through 9 pandigital.

%Find the sum of all products whose multiplicand/multiplier/product identity can be written as a 1 through 9 pandigital.

%HINT: Some products can be obtained in more than one way so be sure to only include it once in your sum.
%
%
%
%
%
%
%
%
%TOMMY NOTE
%This problem took me a LONG TIME. But my ending solution is short and nearly instant. 
%
%The trick I was missing for awhile was that the product can only have 4 digits in it. 3 digits and
%the multiplicands and product will have less than 9 digits, and 5 digits (or more) and the
%multiplicands and product will have more than 9 digits. 
%
%I didn't realize this until I knew I had to constrain the space of the problem because there were
%something like 100 billion possible multiplicands to try. 
%
%Once I realized that, it was easy. 

-module(p032).
-export([solve/0]).

solve() ->
    %first we constrain the space of multiplicands we test
    ValidProds = [X || X <- lists:seq(1000,9999)], %if product has more than 4 terms, then sum of digits in multipliers + product > 9
    Facs = lists:map(fun(X) -> eulermath:proper_divisors(X) end, ValidProds),
    %now have a list of list of numbers that might multiply out correcly
    lists:sum(eulerlist:remove_duplicates(lists:flatten(lists:map(fun(L) -> [trypair(X, Y) || X <- L, Y <- L] end, Facs)))).

trypair(I, J) -> 
    ID = eulermath:digitize(I),
    JD = eulermath:digitize(J),
    IJD = eulermath:digitize(I*J),
    case eulermath:is_pandigital_list(ID ++ JD ++ IJD, 9) of 
        true -> I*J;
        _ -> 0
    end.
