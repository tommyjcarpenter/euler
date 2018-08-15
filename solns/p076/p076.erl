-module(p076).
-export([timesolve/0, solve/0]).

timesolve() ->
    erlang:display(timer:tc(p076, solve, [])).

solve() ->
    ways(100)-1. % we minus 1 because 100 itself doesnt count

ways(N) ->
    % Ways to make 6 is  ways to make 6 with using a 6, + ways to make 6 without using a 6
    ways(N, [N], [])  + ways(N, [], [N]).

ways(Target, MustUse, CantUse) ->
    C = erlang:get({Target, MustUse, CantUse}),
    if is_integer(C) -> C;
    true ->
        NewTarget = Target - lists:sum(MustUse),
        A = case NewTarget of
            0 -> erlang:display({soln, Target, MustUse, CantUse}), 1;
            1 -> erlang:display({soln_1, Target, MustUse, CantUse}), 1;
            _ ->
                Available = lists:subtract(lists:seq(1, NewTarget), CantUse),
                case Available == [] of
                    true -> 0;
                    false ->
                        NextLargest = lists:max(Available),
                        NewCant = [X || X <- [NextLargest | CantUse], X=< NewTarget],
                        ways(NewTarget, [NextLargest], CantUse) + ways(NewTarget, [], NewCant)
                end
        end,
        erlang:put({Target, MustUse, CantUse}, A),
        A
    end.
