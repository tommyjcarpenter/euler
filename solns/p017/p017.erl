-module(p017).
-export([timesolve/0, solve/0]).

%If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
%
%If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, how many letters would be used?
%
%
%NOTE: Do not count spaces or hyphens. For example, 342 (three hundred and forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20 letters. The use of "and" when writing out numbers is in compliance with British usage.

%
timesolve() -> 
    erlang:display(timer:tc(p017, solve, [])).

solve() -> length(lists:flatten(["onethousand" | do(999)])).

tens(Tens, Ones) ->
    Ty = st(Tens*10),
    case Tens >= 2 of  
        true ->
            [Ty | lists:map(fun(X) -> eulerutil:concat([Ty, X]) end, [st(X) || X <- lists:seq(1, Ones)])];
        false -> %19 or lower
            [st(X) || X <- lists:seq(1, Tens*10+Ones)]
    end.

hunds(Hunds, Tens, Ones) ->
    Hu = eulerutil:concat([st(Hunds) , "hundred"]),
    HUAnd = eulerutil:concat([Hu, "and"]),
    case Tens >= 2 of
        true ->
            lists:map(fun(X) -> eulerutil:concat([HUAnd, X]) end, tens(Tens, Ones));
        false ->
            case Tens of 
                1 -> [Hu | lists:map(fun(X) -> eulerutil:concat([HUAnd, X]) end, tens(Tens, Ones))];
                0 -> [] %alredy handled by Tens(1) case
            end
    end.

do(N) when N > 1 -> 
    IasL = eulermath:digitize(N),
    case length(IasL) of 
        2 -> 
             Tens = lists:nth(1, eulermath:digitize(N)),
             Ones = lists:nth(2, eulermath:digitize(N)),
             case Tens >= 2 of 
                 true ->  tens(Tens, Ones) ++ do(N - (N rem 10) -1);
                 false -> tens(Tens, Ones)
             end;
        3 -> hunds(lists:nth(1, IasL), lists:nth(2, IasL), lists:nth(3, IasL)) ++ do(N - (N rem 10) -1)
    end;
do(_) -> "".


st(90) -> "ninety";
st(80) -> "eighty";
st(70) -> "seventy";
st(60) -> "sixty";
st(50) -> "fifty";
st(40) -> "forty";
st(30) -> "thirty";
st(20) -> "twenty";
st(19) -> "nineteen";
st(18) -> "eighteen";
st(17) -> "seventeen";
st(16) -> "sixteen";
st(15) -> "fifteen";
st(14) -> "fourteen";
st(13) -> "thirteen";
st(12) -> "twelve";
st(11) -> "eleven";
st(10) -> "ten";
st(9) -> "nine" ;
st(8) -> "eight";
st(7) -> "seven";
st(6) -> "six";
st(5) -> "five";
st(4) -> "four";
st(3) -> "three";
st(2) -> "two";
st(1) -> "one".
