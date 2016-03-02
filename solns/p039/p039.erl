%If p is the perimeter of a right angle triangle with integral length sides, {a,b,c}, there are
%exactly three solutions for p = 120.
%
%{20,48,52}, {24,45,51}, {30,40,50}
%
%For which value of p ≤ 1000, is the number of solutions maximised?

-module(p039).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p039, solve, []).

solve() -> 
    eulermath:mode(formposstriangles(1,1,1)).
                
formposstriangles(A,B,C) ->
    if A + B + C > 1000 orelse B < A orelse C < B ->  [];
    true ->
        F = erlang:get({'triangles',A,B,C}),
        if is_list(F) -> [];
        true -> 
            R = istri(A,B,C) ++ formposstriangles(A+1,B,C) ++ formposstriangles(A,B+1,C) ++ formposstriangles(A,B,C+1),
            erlang:put({'triangles',A,B,C}, R),
            R
        end
    end.

istri(A,B,C) ->
    if A*A + B*B == C*C -> [A+B+C];
    true -> []
    end.
    

