%The first two consecutive numbers to have two distinct prime factors are:

%14 = 2 × 7
%15 = 3 × 5

%The first three consecutive numbers to have three distinct prime factors are:

%644 = 2² × 7 × 23
%645 = 3 × 5 × 43
%646 = 2 × 17 × 19.

%Find the first four consecutive integers to have four distinct prime factors. What is the first of these numbers?
                                                                                                   
-module(p047).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p047, solve, []).

solve() ->
    %seiving takes the most time, so my methodlogy is to seive in chunks
    %and double the size of the seive when we need to
    loopup(644,645,646,647, 100000, eulermath:seive(100000)).

check(X, NewSeive) ->
    F = erlang:get({'check', X}),
    case is_integer(F) of
        true -> X;
        false ->
            L = eulermath:prime_factorization(NewSeive, X),
            R = sets:size(sets:from_list(L)) > 3,
            erlang:put({'check', X}, R),
            R
    end.

loopup(A,B,C,D, SeiveLimit, Seive) ->
    %double the seive range
    if A > SeiveLimit ->
        NewSeiveLimit = SeiveLimit*2,
        NewSeive = eulermath:seive(NewSeiveLimit);
    true ->
        NewSeiveLimit = SeiveLimit,
        NewSeive = Seive
    end,
    case check(A, NewSeive) andalso check(B,NewSeive) andalso check(C,NewSeive) andalso check(D,NewSeive) of %short circuit shoud pass as soon as A fails
        true -> {A,B,C,D};
        _ -> loopup(A+1,B+1,C+1,D+1, NewSeiveLimit, NewSeive)
    end.
         
    
