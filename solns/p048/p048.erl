%The series, 11 + 22 + 33 + ... + 1010 = 10405071317.
%
%Find the last ten digits of the series, 11 + 22 + 33 + ... + 10001000.

-module(p048).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p048, solve, []).

solve() ->
    TheDigs = eulermath:digitize(recurseup(1,1000, 0)),
    eulermath:digit_list_to_integer(lists:sublist(TheDigs, length(TheDigs)-9, 10)).

recurseup(I, Target, Acc) ->
    V = Acc + eulermath:integerpow(I,I),
    if I == Target -> V;
    true -> recurseup(I+1, Target, V)
    end.
