-module(p071).
-export([timesolve/0, solve/0]).

timesolve() ->
    code:add_path("/Users/tommy/Development/github/euler"),
    erlang:display(timer:tc(p071, solve, [])).

solve() ->
    % After running this for smaller numbers than 1,000,000, call these maxes M, I noticed the following:
    % the answer is of  the form N / D where D is very close to M and N is as high as possible.
    % High as possible means the closest fraction to 3/7 given d, which means 3/7*d minus 1 (can't have it = 3/7, it wont be reduced!).
    % When d is 999,999, this is 428,571)
    % That tells me, the answer must be close to 999,999*(3/7) / 999,9999
    % So we start from D=999,999 and iterate down
    % Turns out 9999997 is the denominator
    iterate(1000000).

iterate(N) -> iterate(N-1,1,{666/666}).
iterate(1,_, ClosestFrac) -> ClosestFrac;
iterate(I,ClosestDelta, ClosestFrac) ->
    erlang:display({I, ClosestFrac}),
    MaxNum = trunc(math:ceil(3/7*I)) - 1,
    NewDelta =  3/7 - MaxNum/I,
    case NewDelta < ClosestDelta andalso eulermath:gcd(MaxNum, I) == 1 of
        true -> iterate(I-1, NewDelta, {MaxNum, I});
        false -> iterate(I-1, ClosestDelta, ClosestFrac)
    end.
