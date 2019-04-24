-module(p081).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p081, solve, []).

solve() ->
    M = eulerfile:file_to_matrix_csv("matrix.txt"),
    build_min_matrix(M, 80, 80).

access_M(M, Row, Col) ->
    lists:nth(Col, lists:nth(Row, M)).

compute_cell(M, 80, 80) -> access_M(M, 80, 80);
compute_cell(M, Row, 80) ->  access_M(M, Row, 80) + erlang:get({'buildmin', Row+1, 80});
compute_cell(M, 80, Col) ->  access_M(M, 80, Col) + erlang:get({'buildmin', 80, Col+1});
compute_cell(M, Row, Col) ->
    %see if we can check right
    A = erlang:get({'buildmin', Row, Col+1}),
    B = erlang:get({'buildmin', Row+1, Col}),
    access_M(M, Row, Col) + erlang:min(A, B).

build_min_matrix(_, _, 0) -> 0;
build_min_matrix(_, 0, _) -> 0;
build_min_matrix(M, 1, 1) -> compute_cell(M, 1, 1);
%we start from bottom right, go up, then when we hit top, to to last row in Col-1
build_min_matrix(M, Row, Col) ->
    V = compute_cell(M, Row, Col),
    erlang:put({'buildmin', Row, Col}, V),
    erlang:display({Row, Col, V}),
    if Row == 1 ->  build_min_matrix(M, 80, Col-1);
    true        ->  build_min_matrix(M, Row-1, Col)
    end.

