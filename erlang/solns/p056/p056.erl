-module(p056).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p056, solve, []).

solve() ->
    lists:max([loop_i_higher(1,1,-1), loop_j_higher(1,1,-1)]).

loop_i_higher(I, 0, Max) -> loop_i_higher(I+1,I+1,Max);
loop_i_higher(100,_,Max) -> Max;
loop_i_higher(I,J,Max) ->
    DS = lists:sum(eulermath:digitize(eulermath:integerpow(I,J))),
    if DS > Max -> loop_i_higher(I,J-1,DS);
    true -> loop_i_higher(I,J-1,Max)
    end.

loop_j_higher(0, J, Max) -> loop_j_higher(J+1,J+1,Max);
loop_j_higher(_,100,Max) -> Max;
loop_j_higher(I,J,Max) ->
    DS = lists:sum(eulermath:digitize(eulermath:integerpow(I,J))),
    if DS > Max -> loop_j_higher(I-1,J,DS);
    true -> loop_j_higher(I-1,J,Max)
    end.


