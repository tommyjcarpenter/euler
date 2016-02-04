-module(p018).
-export([solve/0]).

solve() ->
    L1 =  [75],
    L2 =  [95,64],
    L3 =  [17,47,82],
    L4 =  [18,35,87,10],
    L5 =  [10,04,82,47,65],
    L6 =  [19,01,23,75,03,34],
    L7 =  [88,02,77,73,07,63,67],
    L8 =  [99,65,04,28,06,16,70,92],
    L9 =  [41,41,26,56,83,40,80,70,33],
    L10 = [41,48,72,33,47,32,37,16,94,29],
    L11 = [53,71,44,65,25,43,91,52,97,51,14],
    L12 = [70,11,33,28,77,73,17,78,39,68,17,57],
    L13 = [91,71,52,38,17,14,91,43,58,50,27,29,48],
    L14 = [63,66,04,68,89,53,67,30,73,16,69,87,40,31],
    L15 = [04,62,98,27,23,09,70,98,73,93,38,53,60,04,23],
    
    dosolve([L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14, L15]).

dosolve(L) -> 
    erlang:display(L),
    if length(L) == 1 -> L;
    true ->
        {L1, L2} = lists:split(length(L) - 2, L),
        erlang:display(merge_row_below(L2)),
        dosolve(L1 ++ [merge_row_below(L2)])
    end.

merge_row_below(L) ->
    %this merges the mini triangles
    %turns [D,E]
    %     [A,B,C]
    % into [D+Max(A,B), E+Max(B,C)]
    [LAbove, LBottom] = L,
    ReducedBottom  = compress_max_row(1, LBottom, []),
    lists:map(fun(X) -> {A,B} = X, A+B  end, lists:zip(ReducedBottom, LAbove)).

compress_max_row(I, L, LNew) ->
    %this is half the step of merging the mini triangles
    %[A,B,C] into [max(A,B), max(B,C)]
    if I + 1 > length(L) -> lists:reverse(LNew);
    true ->
        S = lists:sublist(L, I, 2),
        compress_max_row(I+1, L, [lists:max(S) | LNew])
    end.
