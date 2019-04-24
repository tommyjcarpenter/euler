-module(p033).
-export([timesolve/0, solve/0]).

timesolve() -> 
    erlang:display(timer:tc(p033, solve, [])).

%The fraction 49/98 is a curious fraction, as an inexperienced mathematician in attempting to simplify it may incorrectly believe that 49/98 = 4/8, which is correct, is obtained by cancelling the 9s.
%
%We shall consider fractions like, 30/50 = 3/5, to be trivial examples.
%
%There are exactly four non-trivial examples of this type of fraction, less than one in value, and containing two digits in the numerator and denominator.
%
%If the product of these four fractions is given in its lowest common terms, find the value of the denominator.

is_special_flower(Num, Denom) ->

    Float = Num / Denom,

    NumDigits = eulermath:digitize(Num),
    DenomDigits = eulermath:digitize(Denom),
    erlang:display({NumDigits, DenomDigits, Float}),

    %[1]2 / [3]4
    A = lists:nth(1, DenomDigits) /= 0 andalso %div0..
        lists:nth(1, NumDigits) / lists:nth(1, DenomDigits) =:= Float andalso 
        lists:nth(2, NumDigits) =:= lists:nth(2, DenomDigits) andalso
        lists:nth(2, NumDigits) /= 0, %no trivial

    %[1]2 / 3[4]
    B = lists:nth(2, DenomDigits) /= 0 andalso %div0..
        lists:nth(1, NumDigits) / lists:nth(2, DenomDigits) =:= Float andalso
        lists:nth(2, NumDigits) =:= lists:nth(1, DenomDigits),

    %1[2] / [3]4
    C = lists:nth(1, DenomDigits) /= 0 andalso %div0..
        lists:nth(2, NumDigits) / lists:nth(1, DenomDigits) =:= Float andalso
        lists:nth(1, NumDigits) =:= lists:nth(2, DenomDigits),

    %1[2] / 3[4]
    D = lists:nth(2, DenomDigits) /= 0 andalso %div0..
        lists:nth(2, NumDigits) / lists:nth(2, DenomDigits) =:= Float andalso
        lists:nth(1, NumDigits) =:= lists:nth(1, DenomDigits),

    A orelse B orelse C orelse D.

solve() -> 
    [{A,B},{C,D},{E,F},{G,H}] = dosolve(10,10,[]),
    Num = A*C*E*G,
    Denom = B*D*F*H,
    GCD = eulermath:gcd(Num, Denom),
    erlang:display({[{A,B},{C,D},{E,F},{G,H}], Num, Denom, GCD}),
    Denom / GCD.

dosolve(_, 100, ReturnL) -> ReturnL;
dosolve(N, D, ReturnL) ->
    case N >= D of %says < 1, so it's a triangle
        true -> dosolve(10, D+1, ReturnL);
        false ->
            case is_special_flower(N, D) of 
                true ->  dosolve(N+1, D, [{N,D} | ReturnL]);
                false -> dosolve(N+1, D, ReturnL)
            end
    end.
