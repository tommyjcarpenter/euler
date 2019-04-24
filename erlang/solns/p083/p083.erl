-module(p083).
-export([timesolve/0, solve/0]).


%This solution works by starting with the solution from 81.
%That gives the optimal matrix assuming you can only go right and down.
%Then it reiterates over it, starting from bottom right to top left (going up the rows before back
%the columns), and checks to see if going in any other direction is better 
%that is, whether (M[I,J] + optimal[(cell next to I]) for any of 4 next to I is better than optimal[I,J]  
%it repeats this iteration process until the matrix never changes.
%
%Interstingly, only 4 re-iterations were needed, so this runs in O(4n^2) = O(N^2)

timesolve() -> timer:tc(p083, solve, []).

solve() ->
    M = eulerfile:file_to_matrix_csv("matrix.txt"),
    A = build_min_matrix(M, 80, 80), 
    go_until_no_change(M, A).


go_until_no_change(M, Last) ->
    Cur = reiterate(M, 80, 80),
    erlang:display({'go', Cur, Last}),
    if Cur =:= Last -> Cur;
    true -> go_until_no_change(M, Cur)
    end.

access_M(M, Row, Col) ->
    lists:nth(Col, lists:nth(Row, M)).

recompute_cell(M, Row, Col) ->
    case {Row, Col} of
    {1,1} ->  V = [erlang:get({'buildmin', Row+1, Col}), erlang:get({'buildmin',Row, Col+1})];
    {1, 80} ->  V = [erlang:get({'buildmin',Row+1, Col}), erlang:get({'buildmin',Row, Col-1})];
    {80, 1} -> V = [erlang:get({'buildmin',Row-1, Col}), erlang:get({'buildmin',Row, Col+1})];  
    {80, 80} -> V = [erlang:get({'buildmin', Row-1, Col}), erlang:get({'buildmin',Row, Col-1})];    
    {_, _} ->  V = [erlang:get({'buildmin', Row-1, Col}), erlang:get({'buildmin',Row+1, Col}), erlang:get({'buildmin',Row, Col-1}), erlang:get({'buildmin',Row, Col+1})]
    end,
    NV = lists:min(V) + access_M(M, Row, Col),
    case NV < erlang:get({'buildmin', Row, Col}) of
        true -> erlang:put({'buildmin', Row, Col}, NV);
        false -> 0
    end.

reiterate(M, 1, 1) ->
    _ = recompute_cell(M, 1, 1), 
    erlang:get({'buildmin', 1, 1});
reiterate(M, Row, Col) ->
    _ = recompute_cell(M, Row, Col), 
    if Row == 1 ->  reiterate(M, 80, Col-1);
    true        ->  reiterate(M, Row-1, Col)
    end.

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
    %erlang:display({Row, Col, V}),
    if Row == 1 ->  build_min_matrix(M, 80, Col-1);
    true        ->  build_min_matrix(M, Row-1, Col)
    end.

