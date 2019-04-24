%Take the number 192 and multiply it by each of 1, 2, and 3:
%
%192 × 1 = 192
%192 × 2 = 384
%192 × 3 = 576
%By concatenating each product we get the 1 to 9 pandigital, 192384576. We will call 192384576 the
%concatenated product of 192 and (1,2,3)
%
%The same can be achieved by starting with 9 and multiplying by 1, 2, 3, 4, and 5, giving the
%pandigital, 918273645, which is the concatenated product of 9 and (1,2,3,4,5).
%
%What is the largest 1 to 9 pandigital 9-digit number that can be formed as the concatenated product
%of an integer with (1,2, ... , n) where n > 1?

-module(p038).
-export([solve/0]).

solve() -> recurseup(1,-1,-1).
                  
recurseup(Cur, MaxN, MaxPand) ->
    if Cur > 10000 -> MaxPand; %10000 + 10000*2 = 10000 + 20000 = 1,000,020,000 > 9 digits
    true ->
        N = doconcat(Cur),
        if N > MaxPand ->
            recurseup(Cur+1, Cur, N);
        true ->
            recurseup(Cur+1, MaxN, MaxPand)
        end
    end.

doconcat(N) -> concat(N, 1, []).
concat(N, Cur, Accum) ->
    NAccum = Accum ++ eulermath:digitize(N*Cur),
    L = length(NAccum),
    if L < 9 -> concat(N, Cur+1, NAccum);
    true -> 
        if L == 9 ->
            case eulermath:is_pandigital_list(NAccum) of true -> 
                eulermath:digit_list_to_int(NAccum);
            _ -> 0
            end;
        true -> 0
        end
    end.





