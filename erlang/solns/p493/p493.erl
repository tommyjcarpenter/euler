-module(p493).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p493, solve, []).

solve() ->
    %expected value
    2*p2() + 3*p3() + 4*p4() + 5*p5( ) +6*p6() + 7*p7().
    %note p1 is 0; cant select 20 balls of one color when there are only 10 of each


d() -> eulermath:nck(70,20).

p2() ->
    %number of ways to pick two colors from 7 = 7 choose 2
    %given two specific colors, prob of picking all 10 of each of those is
    %(10 choose 10)*(10 choose 10)
    %so total number of successes = 7 choose 2 * (10 choose 10)*(10 choose 10)
    %total number of ways to pick is 70 choose 20
    (eulermath:nck(7,2)*eulermath:nck(10,10)*eulermath:nck(10,10)) / d().

p3() ->
    %here we need all sets of 3 numbers A B C such that A + B + C = 20 and A, B, C at least 1 and at most 10
    %then because it doesnt matter what 3 of A,B,C of the 7 we use, multiple by 7 c 3
    L = lists:seq(1,10),
    P = [{A,B,C} || A <- L, B <- L, C <- L, A + B + C == 20],
    (eulermath:nck(7,3)*lists:sum(lists:map(fun({A,B,C}) -> num_p3(A,B,C) end, P))) / d().
num_p3(A,B,C) ->
    eulermath:nck(10,A)*eulermath:nck(10,B)*eulermath:nck(10,C).

p4() ->
    %and so on
    L = lists:seq(1,10),
    P = [{A,B,C,D} || A <- L, B <- L, C <- L, D<- L, A + B + C + D == 20],
    (eulermath:nck(7,4)*lists:sum(lists:map(fun({A,B,C,D}) -> num_p4(A,B,C,D) end, P))) / d().
num_p4(A,B,C,D) ->
    eulermath:nck(10,A)*eulermath:nck(10,B)*eulermath:nck(10,C)*eulermath:nck(10,D).

p5() ->
    L = lists:seq(1,10),
    P = [{A,B,C,D,E} || A <- L, B <- L, C <- L, D<- L, E <- L, A + B + C + D + E== 20],
    (eulermath:nck(7,5)*lists:sum(lists:map(fun({A,B,C,D,E}) -> num_p5(A,B,C,D,E) end, P))) / d().
num_p5(A,B,C,D,E) ->
    eulermath:nck(10,A)*eulermath:nck(10,B)*eulermath:nck(10,C)*eulermath:nck(10,D)*eulermath:nck(10,E).

p6() ->
    L = lists:seq(1,10),
    P = [{A,B,C,D,E,F} || A <- L, B <- L, C <- L, D<- L, E <- L, F <- L, A + B + C + D + E + F== 20],
    (eulermath:nck(7,6)*lists:sum(lists:map(fun({A,B,C,D,E,F}) -> num_p6(A,B,C,D,E,F) end, P))) / d().
num_p6(A,B,C,D,E,F) ->
    eulermath:nck(10,A)*eulermath:nck(10,B)*eulermath:nck(10,C)*eulermath:nck(10,D)*eulermath:nck(10,E)*eulermath:nck(10,F).

p7() ->
    L = lists:seq(1,10),
    P = [{A,B,C,D,E,F,G} || A <- L, B <- L, C <- L, D<- L, E <- L, F <- L, G<- L, A + B + C + D + E + F + G == 20],
    (eulermath:nck(7,7)*lists:sum(lists:map(fun({A,B,C,D,E,F,G}) -> num_p7(A,B,C,D,E,F,G) end, P))) / d().
num_p7(A,B,C,D,E,F,G) ->
    eulermath:nck(10,A)*eulermath:nck(10,B)*eulermath:nck(10,C)*eulermath:nck(10,D)*eulermath:nck(10,E)*eulermath:nck(10,F)*eulermath:nck(10,G).
