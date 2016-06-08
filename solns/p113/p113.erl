-module(p113).
-export([timesolve/0, solve/0]).

%8> p113:timesolve().
%{1542011,51161058134250}
%
%Working from left-to-right if no digit is exceeded by the digit to its left it is called an
%increasing number; for example, 134468.
%
%Similarly if no digit is exceeded by the digit to its right it is called a decreasing number; for
%example, 66420.
%
%We shall call a positive integer that is neither increasing nor decreasing a "bouncy" number; for
%example, 155349.
%
%As n increases, the proportion of bouncy numbers below n increases such that there are only 12951
%numbers below one-million that are not bouncy and only 277032 non-bouncy numbers below 1010.
%
%How many numbers below a googol (10100) are not bouncy?
%
%
%
%
%
%
%I went through MANY interations with this. 
%My final solution is a map reduce program that runs in 1.5 seconds.
%
%It is a highly optimized version of "store all lists from the previous depth, and prepend onto all
%of those, all possible values, at the next depth".
%
%The optimizations are:
%1) instead of storing all lists from the previous depth, the first optimization was to just store
%the head and the direction the list was going, one of `inc`, `dec, `both`. 
%
%2) Then, upon realizing once you did that you ended up with many repeats, like:
%[{1, inc}, {2,inc}, {2,inc}, {2, inc}, {2,both}, {2,both}.....]
%
%I realized that prepending to the three {2,inc}s was redundant work, and we should just do that work 
%once and multiply by three, and thus the reduce function was born (naming the prepending phase the
%map function). Thus we reduce this to:
%
%%[{1, inc}, {3, 2, inc}, {2, 2,both},.....]
%
% And at each depth we just sum those values to the values from the previous depth. 
%

timesolve() -> timer:tc(p113, solve, []).

solve() -> solve_0(100).
solve_0(Zeros) -> nextlevel([[]], 0, Zeros,0) - Zeros.

nextlevel(Sets, Depth, StoppingDepth, SolnsSoFar) ->
            M = lists:foldl(fun(Y, Acc) -> Y ++ Acc end, [], 
                   plists:map(fun(X) -> mapp(X) end, Sets, {processes, schedulers})),
            L = reduce(M),
            NewTotal = lists:sum([X || {X,_,_} <- L]) + SolnsSoFar,
        if Depth+1 == StoppingDepth -> 
               NewTotal;
        true-> nextlevel(L, Depth+1, StoppingDepth, NewTotal)
        end.

reduce(Sets) ->
    F = eulerlist:list_to_freq_map(Sets),
    [{X*Y, D, Dir} || {{X, D, Dir},Y} <- dict:to_list(F)].

mapp([]) ->
    lists:map(fun(X) -> {1, X, both} end, lists:seq(0,9));
mapp({Multiplier, H, Dir}) ->
    case H == 0 of %only nextlevel a 0 if its all 0s
      true -> lists:map(fun(X) -> {Multiplier, X, dec} end, lists:seq(1, 9)) ++ [{Multiplier, 0, dec}];
      false ->
         if Dir == both  ->   %if we have just one digit, or a string with all the same like 22222, add all 9
           lists:map(fun(X) -> {Multiplier, X, inc} end, lists:seq(1, H-1)) 
           ++ [{Multiplier, H, both}] 
           ++ lists:map(fun(X) -> {Multiplier, X, dec} end, lists:seq(H+1, 9));
         true ->    
           if Dir == dec -> 
             lists:map(fun(X) -> {Multiplier, X, dec} end, lists:seq(H, 9));
           true ->
             lists:map(fun(X) -> {Multiplier, X, inc} end, lists:seq(1, H))
           end
       end
    end.

