%
-module(p041).
-export([dosolve/0]).

dosolve() ->
    R = eulermath:perms_inc_less_than_int(987654321),
    RSorted = lists:reverse(lists:sort(R)),
    primesdown(lists:filter(fun(X) -> X rem 2 /= 0 end, RSorted)).

primesdown([H|T]) -> 
    case eulermath:isprime(H) of 
        true -> H;
         _ -> primesdown(T)
    end.
    
