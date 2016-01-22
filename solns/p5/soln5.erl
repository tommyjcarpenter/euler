%2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any %remainder.
%
%What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

-module(soln5).
-export([recursedown/3]).

recursedown(1, Num, StartNum) -> Num;
recursedown(I, Num, StartNum) ->
    case Num rem I == 0 of
        true -> recursedown(I-1, Num, StartNum);
        false -> recursedown(StartNum, Num+1, StartNum) %probably could do much more work to figure out something smarter than +1
    end.
    

