-module(eulermath).
-export([isprime/1, digitize/1, seive/1, is_perm_of/2]).

%determines if a number is prime
isprime(I) ->
    case I < 2  of 
        true -> false;
        false -> case I < 3 of 
                     true -> true;
                     false ->  case I rem 2 of 
                                   0 -> false; %optimization; before entering recursive loop, check if even
                                   _ -> doisprime(I, erlang:trunc(math:sqrt(I)))
                     end
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

%creates a list of digits from an int
digitize(N) when N < 10 -> [N]; %stolen from http://stackoverflow.com/questions/32670978/problems-in-printing-each-digit-of-a-number-in-erlang
digitize(N) -> digitize(N div 10)++[N rem 10].

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
