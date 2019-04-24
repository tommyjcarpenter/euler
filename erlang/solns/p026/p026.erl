-module(p026).
-export([timesolve/0, solve/0]).

%A unit fraction contains 1 in the numerator. The decimal representation of the unit fractions with denominators 2 to 10 are given:
%
%1/2    =   0.5
%1/3    =   0.(3)
%1/4    =   0.25
%1/5    =   0.2
%1/6    =   0.1(6)
%1/7    =   0.(142857)
%1/8    =   0.125
%1/9    =   0.(1)
%1/10   =   0.1
%Where 0.1(6) means 0.166666..., and has a 1-digit recurring cycle. It can be seen that 1/7 has a 6-digit recurring cycle.
%
%Find the value of d < 1000 for which 1/d contains the longest recurring cycle in its decimal fraction part.

timesolve() -> 
    erlang:display(timer:tc(p026, solve, [])).

%https://stackoverflow.com/questions/44186796/get-floating-decimal-portion-of-a-float
frac_to_denom_int(Num, Denom, Precison) ->
    {X, _} = string:to_integer(lists:nth(2, string:tokens(decimal:format(decimal:divide(Num, Denom, [{precision, Precison}])), "."))),
    X.

denom_to_digitized_frac_int(Denom) ->
    %3 to [3,3,3,3,3,3,3]
    %4 to [7,5] as in 1/4 = .75
    %Regarding 1000, making the assumption that I don't have to look farther than 1000 out to find it...
    D = eulerutil:concat([integer_to_list(Denom), ".0"]),
    DenomInt = frac_to_denom_int("1.0", D, 2000),
    eulermath:digitize(DenomInt).

solve() ->
    dosolve(2, -1, -1).

dosolve(1000, Max, MaxD) -> {d, MaxD, length, Max};
dosolve(D, Max, MaxD) ->
    erlang:display(D),
    L = denom_to_digitized_frac_int(D),
    {_, RL} = eulerlist:is_repeating(L),
    case RL > Max of 
        true -> dosolve(D+1, RL, D);
        false -> dosolve(D+1, Max, MaxD)
    end.
