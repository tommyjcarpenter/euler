-module(p070p).
-export([timesolve/0, solve/0]).

timesolve() ->
    erlang:display(timer:tc(p070p, solve, [])).

solve() ->
    %in problem 69 we MAXIMIZED the ratio by having the largest number of unique primes.$
    %Which means we MINIMIZE the ration by having the smallest number of unique primes
    %
    %The ratio is n / n*(1 - 1/p_1)*...(1-1/p_n)
    %Or simply 1 / (1 - 1/p_1)*...(1-1/p_n)
    %
    %To minimize this we want the bottom to be large
    %
    %We want LARGE PRIMES and a SMALL NUMBER of terms
    %(1 - 1/p_1)*...(1-1/p_n)
    %Each of these terms are maximized when p is LARGE (1-~0) and
    %when there are a small number of terms .9*.9 etc
    %
    %This leads to the lowest possible denominator of the ratio, minimuzing the ratio
    %
    %If primes are SMALL, or there are MANY terms, then we have
    %(1-1/small) (e.g., 2) = 0.5, 0.5*0.5*.... is going to by tiny etc.
    %
    %9999*9999 is 99 million, so we don't need more than 9999 primes under the
    %hypothesis that we essentially want 2 large primes
    erlang:display("Seiving"),
    S = eulermath:seive(9999),
    AllPairs = [[X, Y] || X <- S, Y <- S, X*Y<10000000],
    Tots = lists:map(fun([X,Y]) -> totient(X*Y, [X,Y]) end, AllPairs),
    TotsValids = lists:filter(fun({_, T, _, _}) -> eulermath:is_int(T) end, Tots),
    TotsInts = lists:map(fun({R, T, N, Facs}) -> {R,trunc(T),N,Facs} end, TotsValids),
    TotsPerms = lists:filter(fun({_, T, N, _}) -> eulermath:is_perm_of(T, N) end, TotsInts),
    {_,_,N,_} = lists:nth(1, lists:sort(TotsPerms)),
    N.

totient(N, Facs) ->
    % from https://en.wikipedia.org/wiki/Euler%27s_totient_function
    Terms = [1 - 1/X || X <- Facs],
    % this time we return {rat, tot, index} so we can quickly start palindroming from the top
    Tot = N*eulerlist:multiply(Terms),
    {N/Tot, Tot, N, Facs}.
