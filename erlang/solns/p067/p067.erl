%By starting at the top of the triangle below and moving to adjacent numbers on the row below, the maximum total from top to bottom is 23.

%3
%7 4
%2 4 6
%8 5 9 3

%That is, 3 + 7 + 4 + 9 = 23.

%Find the maximum total from top to bottom in triangle.txt (right click and 'Save Link/Target As...'), a 15K text file containing a triangle with one-hundred rows.

%NOTE: This is a much more difficult version of Problem 18. It is not possible to try every route to solve this problem, as there are 299 altogether! If you could check one trillion (1012) routes every second it would take over twenty billion years to check them all. There is an efficient algorithm to solve it. ;o)
-module(p067).
-export([solve/0]).

solve() ->
    dosolve(eulerfile:file_to_matrix_space("p067_triangle.txt")).

%%%
%%%Code here below was copy and pasted directly from p018
%%%
dosolve(L) -> 
    if length(L) == 1 -> L;
    true ->
        {L1, L2} = lists:split(length(L) - 2, L),
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
