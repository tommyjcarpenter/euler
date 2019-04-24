%The number, 197, is called a circular prime because all rotations of the digits: 197, 971, and 719,
%are themselves prime.
%
%There are thirteen such primes below 100: 2, 3, 5, 7, 11, 13, 17, 31, 37, 71, 73, 79, and 97.
%
%How many circular primes are there below one million?

-module(s035).
-export([solve/0]).

rotate_list_right([H|T]) -> T ++ [H].

do_rotations(L, Count) ->
    if Count == 0 -> [];
    true -> 
        R = rotate_list_right(L),
        [R | do_rotations(R, Count-1)]
    end.

form_all_rotations(Int) ->
    DigitsAsBinList = [X || <<X:1/binary>> <= erlang:integer_to_binary(Int)], %http://stackoverflow.com/questions/29472556/split-erlang-utf8-binary-by-characters, %http://stackoverflow.com/questions/6142120/erlang-howto-make-a-list-from-this-binary-a-b-c
    Rs = do_rotations(DigitsAsBinList, length(DigitsAsBinList)),
    lists:map(fun(Y) -> erlang:binary_to_integer(shared_euler:bjoin(Y)) end, Rs).

rotation_list_prime([]) -> true;
rotation_list_prime([H|T]) -> shared_euler:isprime(H) andalso rotation_list_prime(T).

solve() ->
    Ps = shared_euler:seive(999999),
    PsRotations = lists:map(fun(X) -> form_all_rotations(X) end, Ps),
    length([X || X <- PsRotations, rotation_list_prime(X) == true]).

