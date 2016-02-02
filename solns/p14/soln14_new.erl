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

collatz(N, [H|T], Max, MaxN) ->
    erlang:display(N),
    if N == 1000000 
       -> MaxN;
    true -> 
        F = erlang:get({'collatz', H}),
        if is_list(F) ->
            L = [F | T],
            if length(L) > Max  -> 
                collatz(N+1, [N+1], length(L), N);
            true ->
                collatz(N+1, [N+1], Max, MaxN)
            end;
        true ->  
            if H == 1 ->
                L = [H | T];
            true ->
                if H rem 2 == 0 -> 
                    L = collatz(N, [H div 2 | [H | T]], Max, MaxN);
                true -> 
                    L = collatz(N, [3*H+1 | [H | T]], Max, MaxN)
                end
            end,
            erlang:put({'collatz', H}, L),
            collatz(N, [H|T], Max, MaxN)
        end
    end.
    
solve() ->
    collatz(1, [1], 1, 1).
