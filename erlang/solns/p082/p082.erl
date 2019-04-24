-module(p082).
-export([timesolve/0, solve/0]).

%My solution works from bottom right to upper left. It is o(n^3). This could be optimized down into
%O(n^2) with some caching but it ran in about 2s and so i'd rather move onto another problem.
%
%When it visits each node(i,j), it computes the cell as:
%
%minimum_over_all_i_in_{1,80} [path to node(i,J) + cell(i,J+1)]
%
%where all cells to the right (J+1) are already computed. That is, the minimum path to get to any i
%in the same column then go right. all columns to the right of J are already done, so when computing
%node(i,j) you just need to figure out what cell in J to get to. 

timesolve() -> timer:tc(p082, solve, []).

solve() ->
    M = eulerfile:file_to_matrix_csv("matrix.txt"),
    build_min_matrix(M, 80, 80).

access_M(M, Row, Col) ->
    lists:nth(Col, lists:nth(Row, M)).

compute_cell(M, Row, 80) ->  access_M(M, Row, 80); %already in last row
compute_cell(M, 1, Col) -> %cant go up 
    lists:min(lists:map(fun(X) -> form_path(M, 1, Col, 1, X, 'down', 0) end, lists:reverse(lists:seq(1, 80)))); %do longest first due to caching
compute_cell(M, 80, Col) -> %cant go down 
    lists:min(lists:map(fun(X) -> form_path(M, 80, Col, 80, X, 'up', 0) end, lists:seq(1, 80)));
compute_cell(M, Row, Col) -> %can go both
    L =  lists:map(fun(X) -> form_path(M, Row, Col, Row, X, 'down', 0) end, lists:reverse(lists:seq(Row, 80))) %doesnt matter if going 'down' or 'up' for the middle element
      ++ lists:map(fun(X) -> form_path(M, Row, Col, Row, X, 'up', 0) end, lists:seq(1, Row-1)),
    lists:min(L).

%this does not currently do partial sum caching, but it could. 
%this is somewhat wasteful, but at this time, it's not worth overengineering this, as even if 
%we didn't do any caching at all, the total solution would only be o(80^3)
form_path(M, Start_Row, Start_Col, Cur_Row, End_Row, UpOrDown, Acc) ->
    %from a given row and col, sums to the target row, then goes right one. 
    if Cur_Row == End_Row -> %works when all you want to do is go right too
        Acc + access_M(M, Cur_Row, Start_Col) + erlang:get({buildmin, Cur_Row, Start_Col+1});
    true ->
            ToHere = Acc + access_M(M, Cur_Row, Start_Col),
            if UpOrDown == 'up' ->
                form_path(M, Start_Row, Start_Col, Cur_Row-1, End_Row, UpOrDown, ToHere);
            true ->
                form_path(M, Start_Row, Start_Col, Cur_Row+1, End_Row, UpOrDown, ToHere)
            end
    end.

build_min_matrix(M, 1, 1) ->
    V = compute_cell(M, 1, 1),
    erlang:put({'buildmin', 1, 1}, V),
    lists:min(lists:map(fun(X) -> erlang:get({'buildmin', X, 1}) end, lists:seq(1,80)));
build_min_matrix(M, Row, Col) ->
    V = compute_cell(M, Row, Col),
    erlang:put({'buildmin', Row, Col}, V),
    if Row == 1 ->  build_min_matrix(M, 80, Col-1);
    true        ->  build_min_matrix(M, Row-1, Col)
    end.

