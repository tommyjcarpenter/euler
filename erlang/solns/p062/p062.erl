-module(p062).
-export([timesolve/0, solve/0]).

timesolve() ->
    code:add_path("/Users/tommy/Development/github/euler"),
    {T,A} = timer:tc(p062, solve, []),
    erlang:display({trunc(T/1000000), A}). % timer reports in millionths of a second

solve() ->
    N = 10000,
    recurse_cubes(1, 2, 0, N).


recurse_cubes(I, _, _, N) when I > N ->
    notfound;
recurse_cubes(I, J, _, N) when J > N ->
    recurse_cubes(I+1, 1, 0, N);
recurse_cubes(I, J, Curr, N) ->
    case Curr == 5 of
        true ->
            erlang:display({I, J, I*I*I, Curr}),
            done;
        false ->
            Iindex = I*I*I,
            Jindex = J*J*J,
            case eulermath:is_perm_of(Iindex, Jindex) of
                true ->
                    erlang:display({hit, I, J, Iindex, Jindex}),
                    recurse_cubes(I, J+1, Curr+1, N);
                false ->
                    recurse_cubes(I, J+1, Curr, N)
            end
    end.
