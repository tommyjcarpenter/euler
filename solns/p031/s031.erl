%In England the currency is made up of pound, £, and pence, p, and there are eight coins in general circulation:

%1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) and £2 (200p).
%It is possible to make £2 in the following way:

%1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p
%How many different ways can £2 be made using any number of coins?
%
-module(s031).
-export([solve/0]).


% TOMMY NOTE:
% I did this one early on, before learning that Erlang has a dict
% The below is not as effiecient as solution p076
% p076 is essentially the same thing, but using dicts, so all the lists:set_nth turn into 0(1) operations
% but I didn't feel like rewriting this
% So, see the answer to 76 for a more efficient version than this that uses dicts instead of lists

%computes the score of a list
score([], Index) -> 0;
score([H|T], Index) ->
    case Index of
        1 -> V = 1;
        2 -> V = 2;
        3 -> V = 5;
        4 -> V = 10;
        5 -> V = 20;
        6 -> V = 50;
        7 -> V = 100
    end,
    V*H + score(T, Index+1).

solve() ->
    ru([0,0,0,0,0,0,0]) + 1. %+1 for the 1 way of making it with a 2L piece.

ru(L) ->
    F = erlang:get({'ru', L}),
    case is_integer(F)  of
        true ->  0;
        false ->
            S = score(L, 1),
            if S > 200 ->
                R = 0;
            true  ->
                if S == 200 -> R = 1;
                true ->
                    R = ru(shared_euler:setnth(L,1,lists:nth(1,L)+1))+ru(shared_euler:setnth(L,2,lists:nth(2,L)+1))+ru(shared_euler:setnth(L,3,lists:nth(3,L)+1))+ru(shared_euler:setnth(L,4,lists:nth(4,L)+1))+ru(shared_euler:setnth(L,5,lists:nth(5,L)+1))+ru(shared_euler:setnth(L,6,lists:nth(6,L)+1))+ru(shared_euler:setnth(L,7,lists:nth(7,L)+1))
                end
            end,
            erlang:put({'ru', L}, R),
            R
    end.



