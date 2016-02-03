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
    [H|T] = L,
    F = erlang:get({'collatz', H}),
    case is_list(F) of 
        true ->
            R = lists:append(F, T);
        false ->
            if H == 1 ->
                R = L;
            true ->  
                if H rem 2 == 0 -> 
                    R = collatz([H div 2 | L]);
                true ->
                    R = collatz([3*H+1 | L])
                end
            end
    end,
    erlang:put({'collatz', lists:last(L)}, R),
    R.

dosolve(N, Max, MaxN, TheList) ->
    if N == 1000000 -> MaxN;
    true ->
        L = collatz([N]),
        M = length(L),
        if M > Max -> dosolve(N+1, M, N, L);
        true -> 
            dosolve(N+1, Max, MaxN, TheList)
        end
    end.

solve() ->
    {Megass, Ss, Micros} = erlang:timestamp(),
     S =     dosolve(1, -1, 1, []),
    {Megase, Se, Microe} = erlang:timestamp(),
    {Megase-Megass, Se-Ss, Microe-Micros, S}.
