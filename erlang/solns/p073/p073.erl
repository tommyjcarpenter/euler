-module(p073).
-export([timesolve/0, solve/0]).

timesolve() ->
    erlang:display(timer:tc(p073, solve, [])).

% the big thing to realize is that for a given d, all reduced fractions are the set of primes {p} that are relatively prime to d, meaning p1/d....pn/d where pi in {p}
%
%Computing the set of relative primes for 12000 is trivial

solve() ->
    length(iterate(12000)).


iterate(N) -> iterate(N, []).
iterate(1, SoFar) -> SoFar;
iterate(N, SoFar) ->
    L = eulermath:relative_primes(N),
    iterate(N-1, [{X/N} || X <- L, X/N<1/2, X/N>1/3] ++ SoFar).
