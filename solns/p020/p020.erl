
-module(p020).
-export([solve/0]).

fac(N) ->
    if N == 1 -> 1;
    true -> N*fac(N-1)
    end.

solve() ->
    lists:sum(shared_euler:digitize(fac(100))).
