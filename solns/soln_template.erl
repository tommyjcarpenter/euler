-module(pXXX).
-export([timesolve/0, solve/0]).

timesolve() -> 
    erlang:display(timer:tc(pXXX, solve, [])).

solve() ->
    todo
