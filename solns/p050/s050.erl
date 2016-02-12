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

%returns the largest sublist (in terms of length) of L that sums to Target, or 0 if not possible
largest_consec_from_build(A, Size, Start, N, Acc, Target) ->
    if Start + N > Size-1  -> 0; %primes monotonucally increasing, so if H > T/2, then H + Hnext > Target 
    true ->
        S = Acc + array:get(Start+N, A), 
        %sublistsum(L, N), %I believe the first substring of primes that sums to the target is necessarily the longest. Because the primes are monotonically increasing, any substring summing to the same amount with a higher start index necessarily has les terms. So, return the first substring that sums to the target. 
        if S == Target -> {N, Target};
        true ->
            if S > Target -> largest_consec_from_build(A, Size, Start+1, 1,   0, Target);
            true ->          largest_consec_from_build(A, Size, Start,   N+1, S, Target)
            end
        end
    end.

solve() ->
    Ps = shared_euler:seive(999999),
    A = array:from_list(Ps),
    Size = array:size(A),
    lists:max(lists:map(fun(X) ->largest_consec_from_build(A, Size, 0, 1, 0, X) end, Ps)).

    
