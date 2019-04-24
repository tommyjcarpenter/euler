-module(p102).
-export([timesolve/0, solve/0]).

%Three distinct points are plotted at random on a Cartesian plane, for which -1000 ≤ x, y ≤ 1000,
%such that a triangle is formed.
%
%Consider the following two triangles:
%
%A(-340,495), B(-153,-910), C(835,-947)
%
%X(-175,41), Y(-421,-714), Z(574,-645)
%
%It can be verified that triangle ABC contains the origin, whereas triangle XYZ does not.
%
%Using triangles.txt (right click and 'Save Link/Target As...'), a 27K text file containing the
%co-ordinates of one thousand "random" triangles, find the number of triangles for which the
%interior contains the origin.

%ALGORITHM:
%Initial attempt after drawing a bunch of triangles on paper:
%if it is NOT true that all X < 0 or ALL X > 0
%and it is also NOT true that all Y < 0 or all Y > 0
%then find the two Y intercepts and if one < 0 and one > 0 it contains origin
timesolve() -> timer:tc(p102, solve, []).

solve() ->
    M = eulerfile:file_to_matrix_csv("p102_triangles.txt"),
    length(lists:filter(fun(X) -> process_point(X) end, M)).

process_point([X1,Y1,X2,Y2,X3,Y3])->
        %WARNING: HANDLE TWO POINTS ON X=0 ORIGIN CASE (actually there were none in file that did
        %this but if there were I may have had a bug)
        if X1 < 0 -> LHS1 = [{X1,Y1}], RHS1 = [];
        true -> LHS1 = [], RHS1 = [{X1,Y1}]
        end,
        if X2 < 0 -> LHS2 = [{X2,Y2}], RHS2 = [];
        true -> LHS2 = [], RHS2 = [{X2,Y2}]
        end,
        if X3 < 0 -> LHS3 = [{X3,Y3}], RHS3 = [];
        true -> LHS3 = [], RHS3 = [{X3,Y3}]
        end,
        LHS = LHS1 ++ LHS2 ++ LHS3,
        RHS = RHS1 ++ RHS2 ++ RHS3,
        case length(LHS) of 
            2 ->
                [{P1X,P1Y},{P2X,P2Y}] = LHS,
                [{P3X,P3Y}] = RHS,
                Slope1 = (P3Y-P1Y)/(P3X-P1X),
                Yint1 = P1Y-Slope1*P1X,
                Slope2 = (P3Y-P2Y)/(P3X-P2X),
                Yint2 = P2Y-Slope2*P2X,
                case (Yint1 > 0 andalso Yint2 < 0) orelse (Yint1 < 0 andalso Yint2 > 0) of
                    true -> true;
                    false -> false
                end;
            1 ->
               [{P1X,P1Y}] = LHS,
               [{P2X,P2Y},{P3X,P3Y}] = RHS,
               Slope1 = (P2Y-P1Y)/(P2X-P1X), 
               Yint1 = P1Y-Slope1*P1X,
               Slope2 = (P3Y-P1Y)/(P3X-P1X),
               Yint2 = P1Y-Slope2*P1X,
               case (Yint1 > 0 andalso Yint2 < 0) orelse (Yint1 < 0 andalso Yint2 > 0) of
                   true -> 
                       %erlang:display({LHS,RHS,[X1,Y1,X2,Y2,X3,Y3],Slope1,Yint1,Slope2,Yint2}),
                       true;
                   false -> false
               end;
            0 -> false;
            3 -> false
       end.






       
