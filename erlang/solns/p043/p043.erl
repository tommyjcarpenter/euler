-module(p043).
-export([timesolve/0, solve/0]).

%The number, 1406357289, is a 0 to 9 pandigital number because it is made up of each of the digits 0 to 9 in some order, but it also has a rather interesting sub-string divisibility property.
%
%Let d1 be the 1st digit, d2 be the 2nd digit, and so on. In this way, we note the following:
%
%d2d3d4=406 is divisible by 2
%d3d4d5=063 is divisible by 3
%d4d5d6=635 is divisible by 5
%d5d6d7=357 is divisible by 7
%d6d7d8=572 is divisible by 11
%d7d8d9=728 is divisible by 13
%d8d9d10=289 is divisible by 17
%Find the sum of all 0 to 9 pandigital numbers with this property.

timesolve() -> 
    erlang:display(timer:tc(p043, solve, [])).

%think you can do this from right to left
%form all poss 3 digit div by 17, 
%form all poss 3 digit div by 13
%try to "stitch" these together by forming ABCD where ABC div 13 and BCD div 17
%keep going left

solve() ->
    %form a lookup table of all 3 digit pandigs
    LookupTable = form_lt(),
    L2s = find_set(2, LookupTable),
    L3s = find_set(3, LookupTable),
    L5s = find_set(5, LookupTable),
    L7s = find_set(7, LookupTable),
    L11s = find_set(11, LookupTable),
    L13s = find_set(13, LookupTable),
    L17s = find_set(17, LookupTable),
    
    L1317s = [Z || Z <- [stitch(X,Y) || X <- L13s, Y <- L17s], Z /= no],

    L111317s = [Z || Z <- [stitch(X,Y) || X <- L11s, Y <- L1317s], Z /= no],


    L7111317s = [Z || Z <- [stitch(X,Y) || X <- L7s, Y <- L111317s], Z /= no],
    
    L57111317s = [Z || Z <- [stitch(X,Y) || X <- L5s, Y <- L7111317s], Z /= no],
    
    L357111317s = [Z || Z <- [stitch(X,Y) || X <- L3s, Y <- L57111317s], Z /= no],
    
    L2357111317s = [Z || Z <- [stitch(X,Y) || X <- L2s, Y <- L357111317s], Z /= no],

    LofL = [find_missing_pand(X) || X <- L2357111317s],

    lists:sum([eulermath:digit_list_to_int(X) || X <- LofL]).


find_set(N, LookupTable) ->
    K = dict:fetch_keys(LookupTable),
    [[A,B,C] || [A,B,C] <- K, (A*100 + B*10 + C) rem N == 0].

stitch(L1,L2) ->
    %if L1 is ABC and L2 is BCD...X tries to form ABC...X if A NOT IN [BC...X]
    H = lists:nth(1, L1),
    case lists:nth(2, L1) == lists:nth(1, L2) andalso
         lists:nth(3, L1) == lists:nth(2, L2) andalso 
         not lists:member(H, L2) of 
         true -> [H | L2];
         false -> no
    end.

find_missing_pand(L) ->
    %0+1+2+3+4+5+6+7+8+9=45
    [45-lists:sum(L) | L].

%form lookup of all 3 digit pandigs
form_lt() ->
    do_form_lt([0,0,0], dict:new()).
do_form_lt([10,_,_], D) -> D;
do_form_lt([A,B,10], D) -> do_form_lt([A,B+1,0], D);
do_form_lt([A,10,_], D) -> do_form_lt([A+1,0,0], D);
do_form_lt([A,B,C],D) ->
    case eulerlist:num_distinct_elements([A,B,C]) of
        3 -> do_form_lt([A,B,C+1], dict:append([A,B,C], 1, D));
        _ -> do_form_lt([A,B,C+1], D)
    end.
    

