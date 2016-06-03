-module(p112).
-export([timesolve/0, solve/0]).

%Working from left-to-right if no digit is exceeded by the digit to its left it is called an
%increasing number; for example, 134468.
%
%Similarly if no digit is exceeded by the digit to its right it is called a decreasing number; for
%example, 66420.
%
%We shall call a positive integer that is neither increasing nor decreasing a "bouncy" number; for
%example, 155349.
%
%Clearly there cannot be any bouncy numbers below one-hundred, but just over half of the numbers
%below one-thousand (525) are bouncy. In fact, the least number for which the proportion of bouncy
%numbers first reaches 50% is 538.
%
%Surprisingly, bouncy numbers become more and more common and by the time we reach 21780 the
%proportion of bouncy numbers is equal to 90%.
%
%Find the least number for which the proportion of bouncy numbers is exactly 99%.

timesolve() -> timer:tc(p112, solve, []).

solve() ->
   goup(1, 0).

goup(N, Acc) ->
    case eulermath:is_bouncy(N) of
        true ->NewAcc = Acc + 1;
        false -> NewAcc = Acc
    end,
    P = NewAcc / N,
    if P =:= 0.99 -> N;
    true -> goup(N+1, NewAcc)
    end.


