-module(eulermath).
-export([isprime/1, digitize/1, seive/1, is_perm_of/2, fib/1, factorial/1, digit_list_to_integer/1, proper_divisors/1,
        integerpow/2]).

%raise N^M
integerpow(N, 1) -> N;
integerpow(N, M) -> N*integerpow(N, M-1).

fib(N) ->
    if N < 2 -> N;
    true ->
        F = erlang:get({'fib', N}),
        case is_integer(F) of 
            true -> F;
            false -> R = fib(N-1) + fib(N-2),
                     erlang:put({'fib', N}, R),
                     R
        end
    end.
    
factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).

%determines if a number is prime
isprime(I) ->
    case I of
        1 -> false;
        2 -> true;
        _ -> case I rem 2 of 
                   0 -> false; %optimization; before entering recursive loop, check if even
                   _ -> doisprime(I, erlang:trunc(math:sqrt(I)))
                   end
     end.
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

%finds the list of all proper divisors of a number
proper_divisors(N) ->
    dopropdivisors(N, 1, erlang:trunc(N/2)).
dopropdivisors(N, Curr, UpTo) ->
    if Curr > UpTo -> [];
    true -> 
        if N rem Curr =:= 0 ->
            [Curr | dopropdivisors(N, Curr+1, UpTo)];
        true -> 
            dopropdivisors(N, Curr+1, UpTo)
        end
    end.

%creates a list of digits from an int
digitize(N) when N < 10 -> [N]; %stolen from http://stackoverflow.com/questions/32670978/problems-in-printing-each-digit-of-a-number-in-erlang
digitize(N) -> digitize(N div 10)++[N rem 10].

digit_list_to_integer(L) -> trunc(dltoi(lists:reverse(L), 0)).
dltoi([], _) -> 0;
dltoi([H|T], I) -> H*math:pow(10, I) + dltoi(T, I+1).

%determines if X is a permutation of Y
is_perm_of(X, Y) ->
    BLX = [A || <<A:1/binary>> <= erlang:integer_to_binary(X)], %http://stackoverflow.com/questions/29472556/split-erlang-utf8-binary-by-characters, %http://stackoverflow.com/questions/6142120/erlang-howto-make-a-list-from-this-binary-a-b-c
    BLY = [A || <<A:1/binary>> <= erlang:integer_to_binary(Y)], %http://stackoverflow.com/questions/29472556/split-erlang-utf8-binary-by-characters, %http://stackoverflow.com/questions/6142120/erlang-howto-make-a-list-from-this-binary-a-b-c
    shared_euler:list_to_freq_map(BLX) == shared_euler:list_to_freq_map(BLY).

%Let us first describe the original “by hand” sieve algorithm as practiced by Eratosthenes.
%We start with a table of numbers (e.g., 2, 3, 4, 5, . . . ) and progressively
%cross off numbers in the table until the only numbers left are primes. Specifically,
%we begin with the first number, p, in the table, and
%1. Declare p to be prime, and cross off all the multiples of that number in the
%table, starting from p^2;
%2. Find the next number in the table after p that is not yet crossed off and set
%p to that number; and then repeat from step 1.
%
seive(N) -> 
    [_|T] = doseive(lists:seq(1,N), 2), T.

doseive(L, Index) ->
    Isq = Index*Index-1,
    if Isq > length(L) -> [X || X <- L, X /= -1];
    true -> 
        case  lists:nth(Index, L) == -1 of
        true -> doseive(L, Index + 1);
        false -> 
            {L1, L2} = lists:split(Isq, L),
             L3 = lists:map(fun(X) -> if X == -1 orelse (X rem Index == 0 andalso X /= Index) -> -1; true  -> X  end end , L2),
             doseive(lists:append(L1, L3), Index + 1)
    end end.
