%The 5-digit number, 16807=75, is also a fifth power. Similarly, the 9-digit number, 134217728=89,
%is a ninth power.
%
%How many n-digit positive integers exist which are also an nth power?

-module(p063).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p063, solve, []).

solve() -> length(concat()).
concat() -> doconcat(0).
doconcat(N) ->
    case N < 10 of 
        true -> powers_of_K_of_length_K(N) ++ doconcat(N+1);
        false -> []
    end.

powers_of_K_of_length_K(K) -> 
    Min = eulermath:integerpow(10, K-1),
    [X || X <- doall(1, K), X >= Min]. %filter out those with < K digits so left with exactly K             

doall(N, K) -> %all powers of K less with <= K digits
    L = eulermath:integerpow(10, K),
    Ans = eulermath:integerpow(N, K),
    case Ans < L of 
        true -> [Ans | doall(N+1, K)];
        false -> []
    end.

