%What is the index of the first term in the Fibonacci sequence to contain 1000 digits?

-module(p025).
-export([solve/0]).

solve() -> goup(1).
goup(I) ->
    F = eulermath:fib(I),
    D = eulermath:digitize(F),
    if length(D) >= 1000 -> I;
    true -> goup(I+1)
    end.

