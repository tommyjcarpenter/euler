%
%The sum of the squares of the first ten natural numbers is,
%
%12 + 22 + ... + 102 = 385
%The square of the sum of the first ten natural numbers is,
%
%(1 + 2 + ... + 10)2 = 552 = 3025
%Hence the difference between the sum of the squares of the first ten natural numbers and the square
%of the sum is 3025 − 385 = 2640.
%
%Find the difference between the sum of the squares of the first one hundred natural numbers and the
%square of the sum.
%
-module(soln6).
-export([answer/1]).

squaresum(NNN) -> dosquaresum(NNN, 0).
dosquaresum(1, S) -> S+1;
dosquaresum(I, S) -> dosquaresum(I-1, S + I*I).

sumsquared(NNN) -> dosumsquared(NNN, 0).
dosumsquared(1, S) -> (S+1)*(S+1);
dosumsquared(I, S) -> dosumsquared(I-1, S+I).
        
answer(NNN) -> sumsquared(NNN)-squaresum(NNN).



