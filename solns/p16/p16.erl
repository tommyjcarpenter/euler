-module(p16).
-export([solve/0]).

intpow(Exp, Base) ->
    if Exp == 1 -> Base;
    true -> Base*intpow(Exp-1, Base)
    end.

solve() ->
    lists:sum(shared_euler:digitize(intpow(1000,2))).
