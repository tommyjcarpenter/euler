%The following iterative sequence is defined for the set of positive integers:

%n → n/2 (n is even)
%n → 3n + 1 (n is odd)

%Using the rule above and starting with 13, we generate the following sequence:

%13 → 40 → 20 → 10 → 5 → 16 → 8 → 4 → 2 → 1
%It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.
%
%Which starting number, under one million, produces the longest chain?
-module(soln14).
-export([solve/0]).

collatz(L) ->
    [H|_] = L,
    F = erlang:get({'collatz', H}),
    if F /= undefined -> 
        erlang:display(F),
        L;
    true -> 
        if H == 1 -> 
            erlang:put({'collatz', H}, {L}),
            F2 = erlang:get({'collatz', H}),
             erlang:display(F2),
            L;
        true ->  
            if H rem 2 == 0 -> 
                collatz([H div 2 | L]);
            true ->
                collatz([3*H+1 | L])
            end
        end
    end.

dosolve(N, Max, MaxN) ->
    erlang:display(N),
    if N == 1000000 -> MaxN;
    true ->
        M = length(collatz([N])),
        if M > Max -> dosolve(N+1, M, N);
        true -> 
            dosolve(N+1, Max, MaxN)
        end
    end.

solve() ->
    {Megass, Ss, Micros} = erlang:timestamp(),
    S =     dosolve(1, -1, 1),
    {Megase, Se, Microe} = erlang:timestamp(),
    {Megase-Megass, Se-Ss, Microe-Micros, S}.
