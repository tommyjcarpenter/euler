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
-export([solve/0]).

sublistsum(L, Start, N) -> lists:sum(lists:sublist(L, Start, N)).

%returns the largest sublist (in terms of length) of L that sums to Target, or 0 if not possible
largest_consec_from_build_launcher(L, Target) -> largest_consec_from_build(L, 1, 1, Target).
largest_consec_from_build(L, Start, N, Target) ->
    if Start > length(L) orelse N  > length(L)-Start -> 0;
    true ->
        S =  sublistsum(L, Start, N), 
        if S == Target -> N;
        true ->
            if S > Target -> largest_consec_from_build(L, Start+1, 1, Target);
            true -> largest_consec_from_build(L, Start, N+1, Target)
            end
        end
    end.

solve() ->
    largest_consec_from_build_launcher(shared_euler:seive(953), 953).
    
