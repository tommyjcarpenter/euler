%2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any %remainder.
%What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?

%soln: solve with soln5:recursedown(20,20,20).

-module(soln5).
-export([recursedown/3]).

%note; must start at 20 or the +20 fails! Otherwise, just do Num+1
recursedown(1, Num, StartNum) -> Num;
recursedown(I, Num, StartNum) ->
    case Num rem I == 0 of
        true -> recursedown(I-1, Num, StartNum);
        false -> recursedown(StartNum, Num+20, StartNum) %probably could do much more work to figure out something smarter than +20
    end.
    

