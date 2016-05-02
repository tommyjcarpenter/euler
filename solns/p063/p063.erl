%The 5-digit number, 16807=75, is also a fifth power. Similarly, the 9-digit number, 134217728=89,
%is a ninth power.
%
%How many n-digit positive integers exist which are also an nth power?

-module(p063).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p063, solve, []).

solve() -> length(concat()).
concat() -> doconcat(1,inflection_point()).
doconcat(N, M) ->
    case N =< M of 
        true -> powers_of_K_of_length_K(N) ++ doconcat(N+1, M);
        false -> []
    end.

%for this problem to be feasible, there must be an inflection point for some K such that
% 9^K has K digits but 9^k+1 has < K digits
% otherwise the space of K for which there might be a K digit power of K is infinite
% We check 9^K because clearly 9^K maximizes the number of digits over 1^K,...8^K,9^K
%
% Here, we find that inflection point
inflection_point() -> do_inflection_point(1).
do_inflection_point(K) ->
    case eulermath:num_digits(eulermath:integerpow(9, K)) == K of
        true -> do_inflection_point(K+1);
        false -> K-1 %last one as this one failed
    end.
        
%10^K has K+1 digits. Then for any X > 10, X^K has at least K+1 digits
%K+1 digits for a power of K does not fit the criteria. 
%We care only about K digits for a power of K. 
powers_of_K_of_length_K(K) -> 
    Min = eulermath:integerpow(10, K-1),
    [X || X <- doall(1, K), X >= Min]. %filter out those with < K digits so left with exactly K             
doall(10, K) -> [];
doall(N, K) -> %all powers of K less with <= K digits
    L = eulermath:integerpow(10, K),
    Ans = eulermath:integerpow(N, K),
    case Ans < L of 
        true -> [Ans | doall(N+1, K)];
        false -> []
    end.

