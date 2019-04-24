-module(p028).
-export([timesolve/0, solve/0]).

%Starting with the number 1 and moving to the right in a clockwise direction a 5 by 5 spiral is formed as follows:
%
%21 22 23 24 25
%20  7  8  9 10
%19  6  1  2 11
%18  5  4  3 12
%17 16 15 14 13
%
%It can be verified that the sum of the numbers on the diagonals is 101.
%
%What is the sum of the numbers on the diagonals in a 1001 by 1001 spiral formed in the same way?

timesolve() -> 
    erlang:display(timer:tc(p028, solve, [])).

solve() ->
    doiterate(1,-1,-1,0).

%SEE NOTES.TXT
%I had to expand this a few more times to find the pattern
%I saw the pattern on the upper right diagnol, easy to see they were squares, from there it was easy to play around

doiterate(1,_,_,0)     -> doiterate(2, 3, 2, 1);
doiterate(3, 3, 2, 1)  -> doiterate(3, 5, 4, 25); 
doiterate(1002, _, _, DiagSum) -> DiagSum;
doiterate(Level, Base, Minus, DiagSum) ->
    UpperRight = Base*Base,
    UpperLeft = UpperRight-Minus,
    BottomLeft = UpperLeft-Minus,
    BottomRight = BottomLeft-Minus,
    doiterate(Level+2, Base+2, Minus+2, DiagSum + UpperRight+UpperLeft+BottomLeft+BottomRight).
