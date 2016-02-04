%
-module(p041).
-export([dosolve/0]).

genalldecperms([]) -> [];
genalldecperms(L) ->
    [H|T] = L,
    if length(L) == 0 -> [];
    true -> shared_euler:perms(L) ++ genalldecperms(T)
    end.
    
dosolve() ->
    All = genalldecperms([9,8,7,6,5,4,3,2,1]),
    R = lists:map(fun(X) -> {I,_} = string:to_integer(lists:concat(X)), I end, All),
    RSorted = lists:reverse(lists:sort(R)),
    primesdown(lists:filter(fun(X) -> X rem 2 /= 0 end, RSorted)).

primesdown([H|T]) -> 
    case shared_euler:isprime(H) of 
        true -> H;
         _ -> primesdown(T)
    end.
    
