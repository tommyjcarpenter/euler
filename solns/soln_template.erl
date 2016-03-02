-module(pXXX).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(pXXX, solve, []).

solve() ->
    todo
