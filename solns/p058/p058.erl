-module(p058).
-export([timesolve/0, solve/0]).

timesolve() ->
    erlang:display(timer:tc(p058, solve, [])).

solve() ->
    level().

level() -> level(1,1, 0).
level(Level, LastInt, PriorDiagPrimes) ->
    Length = 8*Level,
    Gap = Level*2,
    % we add a dummy member to begining of list so gap counting works
    % Hence LastInt instead of LastInt+1
    [_ | Diags] = lists:seq(LastInt, LastInt+Length, Gap),

    PrimeDiags = lists:filter(fun(X) -> eulermath:isprime(X) end, Diags),
    NewDiagPrimes = PriorDiagPrimes + length(PrimeDiags),
    NewTotal = 4*Level+1,
    Ratio = (NewDiagPrimes / NewTotal)*100,
    SideLength = 3 + 2*(Level-1),
    erlang:display({level, Level, li, LastInt, ratio, Ratio, gap, Gap, sl, SideLength, ndp, NewDiagPrimes, nt, NewTotal}),
    case Ratio < 10 of
        true -> SideLength;
        false -> level(Level+1, lists:nth(length(Diags), Diags), NewDiagPrimes)
    end.


