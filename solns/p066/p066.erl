-module(p066).
-export([timesolve/0, solve/0]).

timesolve() ->
    erlang:display(timer:tc(p066, solve, [])).

solve() ->
    find_xs().

isint(N) ->
    erlang:trunc(N) == N.

find_xs() ->
    Xs = plists:map(fun find_smallest/1, lists:seq(1,1000)),
    erlang:display(Xs),
    erlang:display(length(Xs)),
    erlang:display(lists:nth(661, Xs)),
    erlang:display(lists:nth(829, Xs)),
    eulerlist:max_index(Xs).

find_smallest(D) ->
    X = case eulermath:is_square(D) of
        true -> -1;
        false -> do_find_smallest(2,D)
    end,
    erlang:display({D, X}),
    X.

do_find_smallest(X, D) ->
    % First we solve for Y and see if it is an integer
    % X^2 - DY^2 = 1
    % X^2 - 1 = DY^2
    % (X^2 - 1)/D = Y^2
    Y = math:sqrt((X*X - 1)/D),
    case isint(Y) of
        true -> X;  % if Y is an int here, we are done
        false ->
            % at least slightly better is to figure out the next X that makes the next Y an integer
            NextY = erlang:trunc(math:ceil(Y)), % no point in small incremenets in X where Y not integer
            NewX = erlang:trunc(math:ceil(math:sqrt((1+D*NextY*NextY)))),
            case NewX == X of
                true ->
                    erlang:display({"PROBLEM", D, X, NewX, Y, NextY, NewX*NewX - D*NextY*NextY}),
                    do_find_smallest(X+1, D);
                false ->
                    do_find_smallest(NewX, D)
            end
            %do_find_smallest(X+1, D)
    end.
