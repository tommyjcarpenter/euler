-module(p055).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p055, solve, []).

solve() -> length([X || X <- lists:seq(1,9999), check_Lychrel(X) == true]).

check_Lychrel(P) -> down(P, 50).
down(P, T) ->
    Next = P + eulermath:int_reverse(P),
    case eulermath:is_palindrome(Next) of 
        true -> false; %Lychrel is not paliondromable
        false ->
            Left = T - 1,
            if Left == 0 -> true;
            true -> down(Next, Left)
            end
    end.
