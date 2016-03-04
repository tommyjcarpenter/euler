-module(function_speed_tester).
-export([compare/0, solve1/0, solve2/0]).

compare() ->
    erlang:display(timeforversion1),
    {T1,_} = timer:tc(function_speed_tester, solve1, []),
    erlang:display(T1),
    
    erlang:display(timeforversion2),
    {T2,_} = timer:tc(function_speed_tester, solve2, []),
    erlang:display(T2),

    TD = T2-T1,
    erlang:display(TD).

solve1() ->
    eulermath:integerpow(455,175557).

solve2() ->
    eulermath:integerpow2(455,175557).
