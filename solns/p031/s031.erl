%In England the currency is made up of pound, £, and pence, p, and there are eight coins in general circulation:

%1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) and £2 (200p).
%It is possible to make £2 in the following way:

%1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p
%How many different ways can £2 be made using any number of coins?
%
-module(s031).
-export([solve/0]).

%keytotal(Key) ->
%    A = string:tokens(Key, " "),
%    L = lists:map(fun(X) -> {Keep, _} = string:to_integer(X), Keep end, string:tokens(Key, " ")),
%    score(L, 1).

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

setnth([_|Rest], 1, New) -> [New|Rest];
setnth([E|Rest], I, New) -> [E|setnth(Rest, I-1, New)].

solve() ->
    sets:from_list(ru([0,0,0,0,0,0,0])).

ru(L) ->
    S = score(L, 1),
    if S > 200 -> [n];
    true ->    case S of 
        200 -> L;
        199 -> ru(setnth(L,1,lists:nth(1,L)+1));
        198 -> ru(setnth(L,1,lists:nth(1,L)+1))++ru(setnth(L,2,lists:nth(2,L)+1));
        195 -> ru(setnth(L,1,lists:nth(1,L)+1))++ru(setnth(L,2,lists:nth(2,L)+1))++ru(setnth(L,3,lists:nth(3,L)+1));
        190 -> ru(setnth(L,1,lists:nth(1,L)+1))++ru(setnth(L,2,lists:nth(2,L)+1))++ru(setnth(L,3,lists:nth(3,L)+1))++ru(setnth(L,4,lists:nth(4,L)+1));
        180 -> ru(setnth(L,1,lists:nth(1,L)+1))++ru(setnth(L,2,lists:nth(2,L)+1))++ru(setnth(L,3,lists:nth(3,L)+1))++ru(setnth(L,4,lists:nth(4,L)+1))++ru(setnth(L,5,lists:nth(5,L)+1));
        150 -> ru(setnth(L,1,lists:nth(1,L)+1))++ru(setnth(L,2,lists:nth(2,L)+1))++ru(setnth(L,3,lists:nth(3,L)+1))++ru(setnth(L,4,lists:nth(4,L)+1))++ru(setnth(L,5,lists:nth(5,L)+1))++ru(setnth(L,6,lists:nth(6,L)+1));
        _ -> ru(setnth(L,1,lists:nth(1,L)+1))++ru(setnth(L,2,lists:nth(2,L)+1))++ru(setnth(L,3,lists:nth(3,L)+1))++ru(setnth(L,4,lists:nth(4,L)+1))++ru(setnth(L,5,lists:nth(5,L)+1))++ru(setnth(L,6,lists:nth(6,L)+1))++ru(setnth(L,7,lists:nth(7,L)+1))
                   end
    end.



