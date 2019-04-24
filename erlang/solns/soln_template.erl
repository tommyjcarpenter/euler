-module(pXXX).
-export([timesolve/0, solve/0]).

timesolve() ->
    code:add_path("/Users/tommy/Development/github/euler"),
    {T,A} = timer:tc(pXXX, solve, []),
    erlang:display({trunc(T/1000000), A}). % timer reports in millionths of a second

solve() ->
    todo
