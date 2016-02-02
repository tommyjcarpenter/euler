-module(shared_euler).
-export([digitize/1, listslice/3, isprime/1]).

digitize(N) when N < 10 -> [N]; %stolen from http://stackoverflow.com/questions/32670978/problems-in-printing-each-digit-of-a-number-in-erlang
digitize(N) -> digitize(N div 10)++[N rem 10].

listslice(StartIndex, EndIndex, L) ->
    {ToE, _} = lists:split(EndIndex, L),
    {_, M} = lists:split(StartIndex-1, ToE),
    M.

doisprime(I, 1) -> 
    case I of 
        1 -> false;
        _ -> true
    end;
doisprime(I, J) when J > 1->
    case I rem J of 
        0 -> false;
        _ -> doisprime(I, J-1)
    end.
isprime(I) ->
    case I < 2  of 
        true -> false;
        false ->
            case I < 3 of 
                true -> true;
                false -> 
                    case I rem 2 of 
                        0 -> false; %optimization; before entering recursive loop, check if even
                        _ -> 
                            doisprime(I, erlang:trunc(math:sqrt(I)))
                    end
            end
    end.
