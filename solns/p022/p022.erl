-module(p022).
-export([solve/0]).

readlines(FileName) ->
    {ok, Data} = file:read_file(FileName),
    binary:split(Data, [<<",">>], [global]).

solve() ->
    L1 = lists:sort(readlines("p022_names.txt")),
    L2 = lists:map(fun(X) -> re:replace(X, "\"", "", [global, {return, binary}]) end, L1),
    L3 = lists:map(fun(X) -> [Y || <<Y:1/binary>> <= X]  end, L2), %http://stackoverflow.com/questions/29472556/split-erlang-utf8-binary-by-characters
    recursedown(L3, 1).

recursedown([], Index) -> 0;
recursedown([H|T], Index) ->
    Index*lists:sum(lists:map(fun(X) -> eulerlist:alphabetnum(X) end, H)) + recursedown(T, Index+1).
