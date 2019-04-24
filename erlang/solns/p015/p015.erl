-module(p015).
-export([timesolve/0, solve/0]).

%%%
%%%Starting in the top left corner of a 2×2 grid, and only being able to move to the right and down, there are exactly 6 routes to the bottom right corner.
%%%
%%%How many such routes are there through a 21×21 grid?

timesolve() -> timer:tc(p015, solve, []).

%i did 81 before this problem so i basically copied that answer here and modified it 
%as it is a much harder version of this problem. 
solve() ->
    build_min_matrix(21, 21).

compute_cell(21, 21) -> 1;
compute_cell(Row, 21) ->  %already in far right col can only go down
    erlang:get({'buildmin', Row+1, 21});
compute_cell(21, Col) ->  %in last row can only go right
    erlang:get({'buildmin', 21, Col+1});
compute_cell(Row, Col) ->
    %see if we can check right
    erlang:get({'buildmin', Row, Col+1}) + erlang:get({'buildmin', Row+1, Col}).

build_min_matrix(_, 0) -> 0; %too far left
build_min_matrix(0, _) -> 0; %too far up
build_min_matrix(1, 1) -> compute_cell(1, 1);
%we start from bottom right, go up, then when we hit top, to to last row in Col-1
build_min_matrix(Row, Col) ->
    V = compute_cell(Row, Col),
    erlang:put({'buildmin', Row, Col}, V),
    erlang:display({Row, Col, V}),
    if Row == 1 ->  build_min_matrix(21, Col-1);
    true        ->  build_min_matrix(Row-1, Col)
    end.



