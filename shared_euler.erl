-module(shared_euler).
-export([digitize/1, listslice/3]).

digitize(N) when N < 10 -> [N]; %stolen from http://stackoverflow.com/questions/32670978/problems-in-printing-each-digit-of-a-number-in-erlang
digitize(N) -> digitize(N div 10)++[N rem 10].

listslice(StartIndex, EndIndex, L) ->
    {ToE, _} = lists:split(EndIndex, L),
    {_, M} = lists:split(StartIndex-1, ToE),
    M.
