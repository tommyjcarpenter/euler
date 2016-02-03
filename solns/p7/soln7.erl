%By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is
%13.
%
%What is the 10 001st prime number?
%
-module(soln7).
-import(shared_euler, [isprime/1]).
-export([findnthprime/1]).

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




