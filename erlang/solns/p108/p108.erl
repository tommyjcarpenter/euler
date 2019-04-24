-module(p108).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p108, solve, []).

solve() ->
    N = 1000,
    incN(1, N).

incN(N, StoppingDistinct) ->
    Solns = plists:map(fun(X) -> {do(X,X,99999000000000000000000,[]), X} end, lists:seq(N,N+100)),
    erlang:display(N),
    {M, TheN} = lists:max(Solns),
    if M >= StoppingDistinct -> TheN; %BUG: FIX LATER, JUST BECAUSE M IS OVER THERE COULD BE ANOTHER IN LIST ALSO OVER
    true -> incN(N+100, StoppingDistinct)
    end.

do(X, N, MaxX, SoFar) ->
    if X >= MaxX -> 
        length(SoFar);
    true ->
        {IsSoln,Y} = test_Y_with_X_and_N_fixed(X,N),
        if IsSoln -> 
               %so that we can easily filter out using a hashmap later, transpose X to be biggest always
               SolnY = erlang:round(Y),
               if X >= SolnY -> 
                    A = X,
                    B= SolnY;
               true -> 
                    A = SolnY,
                    B = X
               end,
               %ive noticed empirically that this algorithm finds solutions such that the maximum of the 
               %pair, {X,Y}, is never exceeded again. Moreover, all future solutions {X,Y} are greater than the minumum of that pair. So you can continuously recap X at the minimum
               %maximum of prior solutions.
               NewMX = A, 
               NewSoFar= [{A,B}|SoFar],
         %      erlang:display({X,N,MaxX,A,B}),
               do(X+1, N, NewMX, NewSoFar);
        true -> 
            do(X+1, N, MaxX, SoFar)
        end
        end.
    
test_Y_with_X_and_N_fixed(X, N) ->
    D = 1/N-1/X,
    if D == 0 -> {false, -1};
    true -> 
    Y = 1/D,
    {erlang:abs(erlang:round(Y) - Y) < 0.0001 andalso Y > 0, Y}
    end.
