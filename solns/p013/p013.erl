-module(p013).
-export([solve/0]).

readlines(FileName) ->
    {ok, Data} = file:read_file(FileName),
    binary:split(Data, [<<"\n">>], [global]).

solve() ->
    F = readlines("t.txt"),
    erlang:display(length(F)),
    F2 = [X || X <- F, X /= <<>>],
    F3 = lists:map(fun(Y) -> erlang:binary_to_integer(Y) end, F2),
    S = lists:sum(F3),
    lists:sublist(shared_euler:digitize(lists:sum(F3)), 10).
