-module(pXXX).
-export([timesolve/0, solve/0]).

timesolve() ->
    code:add_path("/Users/tommy/Development/github/euler"),
    erlang:display(timer:tc(pXXX, solve, [])).

solve() ->
    todo
