%By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is
%13.
%
%What is the 10 001st prime number?
%
-module(soln7).
-export([findnthprime/1]).

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
    case I < 3 of 
        true -> true;
        false -> 
            case I rem 2 of 
                0 -> false; %optimization; before entering recursive loop, check if even
                _ -> 
                    doisprime(I, erlang:trunc(math:sqrt(I)))
            end
    end.


%             cur_num, N, found_so_far
dofindnprimes(I, J, K) ->
    case J == K of
        true -> I-1;
        false ->
            case isprime(I) of
                true -> dofindnprimes(I+1, J, K+1);
                false -> dofindnprimes(I+1, J, K)
            end
    end.


findnthprime(N) ->
    dofindnprimes(2, N, 0).




