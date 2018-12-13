-module(eulermath).
-export([isprime/1, digitize/1, seive/1, seive_dict/1, is_square/1,
         is_int/1,
         pascal/1,
         is_perm_of/2, fib/1, factorial/1, num_proper_divisors/1, proper_divisors/1,
        integerpow/2, is_pandigital_num/1, is_pandigital_list/1, perms_int/1, perms_inc_less_than_int/1,
        is_pandigital_list/2, is_pandigital_num/2, digit_list_to_int/1,
        prime_factorization/2,
        mode/1, intconcat/2,
        istri/1, tri_n/1, ispent/1, ishex/1, is_palindrome/1, int_reverse/1, num_digits/1, nck/2, is_bouncy/1, is_increasing/1, is_decreasing/1,
        number_distinct_perms/1,
        gcd/2,
        gcd_memoized/2,
        b10_to_2/1,
        relative_primes/1,
        totient/2
        ]).

-spec intconcat(integer(), integer()) -> integer().
intconcat(X, Y) -> dointconcat(X, Y, 10).
dointconcat(X, Y, Pow) ->
    if Y >= Pow -> dointconcat(X,Y,Pow*10);
    true -> X*Pow + Y
    end.

is_square(N) ->
    math:sqrt(N) == erlang:trunc(math:sqrt(N)).

is_int(N) ->
    erlang:trunc(N) == N.

is_bouncy(X) when X < 0 -> {error};
is_bouncy(X) ->
    % Working from left-to-right if no digit is exceeded by the digit to its left it is called an
    % increasing number; for example, 134468.
    % Similarly if no digit is exceeded by the digit to its right it is called a decreasing number; for example, 66420.
    % We shall call a positive integer that is neither increasing nor decreasing a "bouncy" number; for example, 155349.
    L = eulermath:digitize(X),
    not (
      eulermath:is_increasing(L) orelse
      eulermath:is_decreasing(L)
     ).

is_increasing([]) -> true;
is_increasing([_|[]]) -> true;
is_increasing([H|T]) ->
    case  H >= lists:nth(1, T) of
    true -> is_increasing(T);
    false -> false
    end.

is_decreasing([]) -> true;
is_decreasing([_|[]]) -> true;
is_decreasing([H|T]) ->
    case  H =< lists:nth(1, T) of
    true -> is_decreasing(T);
    false -> false
    end.

num_digits(P) -> length(eulermath:digitize(P)).

int_reverse(P) -> eulermath:digit_list_to_int(lists:reverse(eulermath:digitize(P))).

is_palindrome(P) ->
    L = eulermath:digitize(P),
    A = array:from_list(L),
    checkpal(A, 0, array:size(A)-1).
checkpal(A, Start, End) ->
    case End > Start of
        false -> true; %no middle element or just one; either case, palindrome
        true ->
            case array:get(Start, A) == array:get(End, A) of %check first == last
                false -> false;
                true -> checkpal(A, Start+1, End-1)
            end
    end.

mode(L) ->
    FM = eulerlist:list_to_freq_map(L),
    Keys = dict:fetch_keys(FM),
    domode(Keys, FM, -1, -1).
domode([], _, MaxKey, _) -> MaxKey;
domode([H|T], FM, MaxKey, MaxVal) ->
    Val =  dict:fetch(H, FM),
    if Val > MaxVal -> domode(T, FM, H, Val);
    true -> domode(T, FM, MaxKey, MaxVal)
    end.

digit_list_to_int(L) ->
    %the opposite of digitize
    {I,_} = string:to_integer(lists:concat(L)), I.

%3> eulermath:perms_int(42).
%[42,24]
perms_int(N) ->
    Ps = eulerlist:perms(eulermath:digitize(N)),
    lists:map(fun(X) -> digit_list_to_int(X) end, Ps).

%3> eulermath:perms_inc_less_than_int(42).
%[4,42,24,2]
perms_inc_less_than_int(N) ->
    Ps = eulerlist:perms_inc_less_than(eulermath:digitize(N)),
    lists:map(fun(X) -> digit_list_to_int(X) end, Ps).

%We shall say that an n-digit number is pandigital if it makes use of all the digits 1 to n exactly once;
is_pandigital_num(Num) -> is_pandigital_list(eulermath:digitize(Num)).
is_pandigital_num(Num, NDigit) ->  is_pandigital_list(eulermath:digitize(Num), NDigit).

is_pandigital_list(Digits) -> is_pandigital_list(Digits,length(Digits)). %default n-digit is length of digits
is_pandigital_list(Digits, NDigit) ->
    %mthodology: build a freq map, then make sure each value exaclty 1
    FM = eulerlist:list_to_freq_map(Digits),
    Identity = eulerlist:list_to_freq_map(lists:seq(1, NDigit)),
    FM == Identity.

%raise N^M
integerpow(_, 0) -> 1;
integerpow(N, M) -> dointegerpow(N, M, 1).
dointegerpow(N, 1, Acc) -> N*Acc;
dointegerpow(N, M, Acc) -> dointegerpow(N, M-1, Acc*N).

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

nck(N, K) -> factorial(N) / (factorial(K)*factorial(N-K)).

%determines if a number is prime
isprime(I) when I < 0 -> false;
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
    dopropdivisors(N, 2, erlang:trunc(math:sqrt(N))).
dopropdivisors(N, Curr, UpTo) ->
    if Curr > UpTo -> [1]; %include 1 but not N itself
    true ->
        K = N / Curr,
        KT = trunc(K),
        if K == KT -> %if K is integer, K and curr are divisors
            [KT | [Curr | dopropdivisors(N, Curr+1, UpTo)]];
        true ->
            dopropdivisors(N, Curr+1, UpTo)
        end
    end.

%finds the number of proper divisors in a faster way than
%length(proper_divisors)
num_proper_divisors(N) ->
    donumpropdivisors(N, 1, erlang:trunc(math:sqrt(N)), 0).
donumpropdivisors(N, Cur, UpTo, Acc) ->
    if Cur > UpTo -> Acc;
    true ->
        if N rem Cur =:= 0 ->
            donumpropdivisors(N, Cur+1, UpTo, Acc+2); %see above
        true ->
            donumpropdivisors(N, Cur+1, UpTo, Acc)
        end
    end.

prime_factorization(Primes_To_N_Over_Two, N) ->
    %Must pass in a seive to N/2
    case isprime(N) of
        true -> dopf(Primes_To_N_Over_Two ++ [N], N);
        false -> dopf(Primes_To_N_Over_Two, N)
    end.
dopf(Primes, N) ->
    [H|T] = Primes,
    if H > N -> [];
    true ->
        case  N rem H == 0 of
            true -> [H | dopf(Primes, trunc(N/H))]; %factors could repeat dont remove head
            _ -> dopf(T, N)
        end
    end.

%creates a list of digits from an int
digitize(N) when N < 10 -> [N]; %stolen from http://stackoverflow.com/questions/32670978/problems-in-printing-each-digit-of-a-number-in-erlang
digitize(N) -> digitize(N div 10)++[N rem 10].

%determines if X is a permutation of Y
-spec is_perm_of(integer(), integer()) -> integer().
is_perm_of(X, Y) ->
    BLX = [A || <<A:1/binary>> <= erlang:integer_to_binary(X)], %http://stackoverflow.com/questions/29472556/split-erlang-utf8-binary-by-characters, %http://stackoverflow.com/questions/6142120/erlang-howto-make-a-list-from-this-binary-a-b-c
    BLY = [A || <<A:1/binary>> <= erlang:integer_to_binary(Y)], %http://stackoverflow.com/questions/29472556/split-erlang-utf8-binary-by-characters, %http://stackoverflow.com/questions/6142120/erlang-howto-make-a-list-from-this-binary-a-b-c
    eulerlist:list_to_freq_map(BLX) == eulerlist:list_to_freq_map(BLY).

pascal(N) -> dopascal(1, N, []).
    %generate the first N rows of Pascal's triangle
    %actially returns N+1 rows where N here starts at 0
    %Returns [row1, row2,...] where each of these rows is a list, hence returns list of lists
    dopascal(1, N, _) -> dopascal(2, N, [[1]]);
    dopascal(2, N, _) -> dopascal(3, N, [[1], [1,1]]);
    dopascal(Row, N, Triangle) ->
        case N+2 == Row of
            true -> Triangle;
            false ->
                Mid = sumtop(lists:nth(Row-1, Triangle)),
                NewL = [[1] ++ Mid ++ [1]],
                dopascal(Row+1, N, lists:append(Triangle, NewL))
        end.

    sumtop(L) ->
        dosumtop(L, 1, []).
    dosumtop(L, I, ReturnL) ->
        case I == length(L) of
            true -> lists:reverse(ReturnL);
            false ->
                dosumtop(L, I+1, [lists:nth(I, L) + lists:nth(I+1, L) | ReturnL])
        end.

%for when you want a seive in which to do repeated O(1) lookups on keys
seive_dict(N) -> dict:from_list(lists:map(fun(X) -> {X, 1} end, seive(N))).

%TOMMY'S ORIGINAL SIEVE BELOW. HOWEVER THE ONE ON SO IS FASTER SO STEALING IT. WILL REVISIT MINE LATER
%Let us first describe the original “by hand” sieve algorithm as practiced by Eratosthenes.
%We start with a table of numbers (e.g., 2, 3, 4, 5, . . . ) and progressively
%cross off numbers in the table until the only numbers left are primes. Specifically,
%we begin with the first number, p, in the table, and
%1. Declare p to be prime, and cross off all the multiples of that number in the
%table, starting from p^2;
%2. Find the next number in the table after p that is not yet crossed off and set
%p to that number; and then repeat from step 1.
%seive(N) ->
%    [_|T] = doseive(lists:seq(1,N), 2), T.
%doseive(L, Index) ->
%    Isq = Index*Index-1,
%    if Isq > length(L) -> [X || X <- L, X /= -1];
%    true ->
%        case  lists:nth(Index, L) == -1 of
%        true -> doseive(L, Index + 1);
%        false ->
%            {L1, L2} = lists:split(Isq, L),
%             L3 = lists:map(fun(X) -> if X == -1 orelse (X rem Index == 0 andalso X /= Index) -> -1; true  -> X  end end , L2),
%             doseive(L1 ++ L3, Index + 1)
%    end end.
%stolen from https://stackoverflow.com/questions/146622/sieve-of-eratosthenes-in-erlang
primes(Prime, Max, Primes,Integers) when Prime > Max ->
    lists:reverse([Prime|Primes]) ++ Integers;
primes(Prime, Max, Primes, Integers) ->
    [NewPrime|NewIntegers] = [ X || X <- Integers, X rem Prime =/= 0 ],
    primes(NewPrime, Max, [Prime|Primes], NewIntegers).
seive(N) ->
    primes(2, round(math:sqrt(N)), [], lists:seq(3,N,2)).



%triangular, pentagnol, hexagonal numbers
istri(N) -> X = (-1 + math:sqrt(1+8*N))/2, X == trunc(X).
tri_n(N) -> trunc(N*(N+1)/2).
ispent(N) -> X = (1 + math:sqrt(1+24*N))/6, X == trunc(X).
ishex(N) -> X = (1 + math:sqrt(1+8*N))/4, X == trunc(X).
%see trimath.jpg

number_distinct_perms(L1) ->
    %= Len(N)! / (NumberType1!*NumberType2!*.....)
    FM = eulerlist:list_to_freq_map(L1),
    Vals = [dict:fetch(X, FM) || X <- dict:fetch_keys(FM)],
    Denom = lists:foldl(fun(X,Y) -> Y*eulermath:factorial(X) end, 1, Vals),
    eulermath:factorial(length(L1)) / Denom.

%number_distinct_perms_inc_lt(L1) ->
%    %see https://math.stackexchange.com/questions/463864/number-of-permutations-with-repeated-objects
%    FM = eulerlist:list_to_freq_map(L1),
%    N = length(L1),
%    K = length(dict:fetch_keys(FM)),
%    eulermath:factorial(N)*number_distinct_perms_recurrence(N,K,FM).
%number_distinct_perms_recurrence(0,0, _) -> 1;
%number_distinct_perms_recurrence(N,0, _) when N > 0 -> 1;
%number_distinct_perms_recurrence(N,K,FM) ->
%    F = fun(I) -> (1/eulermath:factorial(I))*number_distinct_perms_recurrence(N-I,K-1,FM) end,
%    Nk = dfetch(N,FM,0),
%    lists:sum([F(X) || X <- lists:seq(0,min(N,Nk))]).

%STOLEN FROM https://github.com/yadudoc/erlang/blob/master/l-99/gcd.erl
gcd(A, B) when B > A  -> gcd(B, A);
gcd(A, B) when A rem B > 0 -> gcd(B, A rem B);
gcd(A, B) when A rem B =:= 0 -> B.

%use when you have overlapping subproblems computing the same GCD many times
gcd_memoized(A, B) ->
    C = erlang:get({A, B}),
    case is_integer(C) of
        true -> C;
        false ->
            R = case B > A of
                    true -> gcd_memoized(B, A);
                    false ->
                        case A rem B > 0 of
                            true -> gcd_memoized(B, A rem B);
                            false -> B
                        end
            end,
            erlang:put({A,B}, R),
            R
    end.


b10_to_2(I) -> do_b10_to_2(I, []). %converts base 10 to base 2, %algorithm from http://chortle.ccsu.edu/assemblytutorial/zAppendixH/appH_4.html, CCSU represent!!!
    do_b10_to_2(0,BitList) -> digit_list_to_int(BitList);
    do_b10_to_2(Num, BitList) -> do_b10_to_2(trunc(Num / 2), [Num rem 2 | BitList]).

relative_primes(1) -> [];
relative_primes(2) -> [1];
relative_primes(N) ->
    %implemented from https://math.stackexchange.com/questions/536991/how-can-i-list-all-numbers-relatively-prime-to-x-but-less-than-x
    dofindrelativeprimes(lists:seq(2, N-2), N, [1, N-1]).
dofindrelativeprimes([], _, SoFar) -> SoFar;
dofindrelativeprimes([H|T], N, SoFar) ->
    case N rem H == 0 of
       true ->
           %H divides H; %Do not include it or any multoples
           dofindrelativeprimes([Y || Y <- T, Y rem H /= 0], N, SoFar);
       false ->
           dofindrelativeprimes(T, N, [H | SoFar])
    end.

totient(PrimeFacs, N) ->
    %https://en.wikipedia.org/wiki/Euler%27s_totient_function
    round(N*eulerlist:multiply([1 - (1/P) || P <- PrimeFacs])).
