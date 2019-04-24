%Let d(n) be defined as the sum of proper divisors of n (numbers less than n which divide evenly into n).
%If d(a) = b and d(b) = a, where a ≠ b, then a and b are an amicable pair and each of a and b are called amicable numbers.

%For example, the proper divisors of 220 are 1, 2, 4, 5, 10, 11, 20, 22, 44, 55 and 110; therefore d(220) = 284. The proper divisors of 284 are 1, 2, 4, 71 and 142; so d(284) = 220.

%Evaluate the sum of all the amicable numbers under 10000.
%
-module(p021).
-export([solve/0]).

solve() ->
    lists:sum(eulerlist:remove_duplicates(recurseup(1, 10000))).

propsum(N) -> lists:sum(eulermath:proper_divisors(N)).

recurseup(N, Target) ->
    if N == Target -> [];
    true ->
        A = propsum(N),
        B = propsum(A),
        if A < 10000 andalso N == B andalso A /= B->
            [N, A] ++ recurseup(N+1, Target);
        true ->
            recurseup(N+1, Target)
        end
    end.


    
