%The prime 41, can be written as the sum of six consecutive primes:
%
%41 = 2 + 3 + 5 + 7 + 11 + 13
%This is the longest sum of consecutive primes that adds to a prime below one-hundred.
%
%The longest sum of consecutive primes below one-thousand that adds to a prime, contains 21 terms,
%and is equal to 953.
%
%Which prime, below one-million, can be written as the sum of the most consecutive primes?

-module(s050).
-import(timer, [tc/2]).
-export([solve/0, dosolve/0]).

%returns the largest sublist (in terms of length) of L that sums to Target, or 0 if not possible
largest_consec_from_build(A, Size, Start, N, Acc) ->
    if Start + N > Size-1  -> 0; %overrun, cant be formed as sum of consec primes
    true ->
        S = Acc + array:get(Start+N, A), 
        if S > 999999 -> {N, Acc}; %largest_consec_from_build(A, Size, Start+1, 1,   0, Target);
        true ->  largest_consec_from_build(A, Size, Start, N+1, S)
        end
    end.

dosolve() ->
    A = array:from_list(shared_euler:seive(999999)),
    Starts = lists:seq(0, 999999),
    Size = array:size(A),
    All_largest = lists:map(fun(X) ->largest_consec_from_build(A, Size, X, 0, 0) end, Starts),
    lists:max([{X, Y} || {X, Y} <- All_largest, shared_euler:isprime(Y) == true]).

solve() ->
    timer:tc(s050, dosolve, []).
    
