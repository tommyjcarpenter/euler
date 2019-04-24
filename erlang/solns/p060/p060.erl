-module(p060).
-export([timesolve/0, solve/0]).

timesolve() ->
    erlang:display(timer:tc(p060, solve, [])).

%SDMax is the length of the seive dict. For primes larger than SDMax we can't
is_prime(X, SD, SDMax) ->
    %mind as well emoize this because this call is expensive. essentially adding onto the dict/..
    case X > SDMax of
        true ->
            F = erlang:get({'prime', X}),
            case is_boolean(F) of
                true -> F;
                false ->
                    R = eulermath:isprime(X), %not O(1), O(N)..
                    erlang:put({'prime', X}, R),
                    R
            end;
        false -> dict:is_key(X, SD)
    end.

check([X,Y], SD, SDMax) ->
    is_prime(eulermath:intconcat(X, Y), SD, SDMax) andalso is_prime(eulermath:intconcat(Y, X), SD, SDMax).

check_family(L, SD, SDMax) ->
    %checks all pairwise elements in L
    Cs = eulerlist:get_combinations(2,L),
    lists:all(fun(C) -> check(C, SD, SDMax) end, Cs).

%used when you know L is already a family all you need to do is check Addition before and after each
%short circuits as soon as possible
check_family_addition([], _,_,_) -> true;
check_family_addition([H|T], Addition, SD, SDMax) ->
    check([H, Addition], SD, SDMax) andalso check_family_addition(T, Addition, SD, SDMax).

%remove_dupes(L) -> %
    %Sorted = lists:map(fun(X) -> lists:sort(X) end, L),
    %eulerlist:remove_duplicates(Sorted).

solve() ->
    %ok first off, I'm just hoping all 5 of the primes are below 10,000
    %anything ending in 2, which is a prime, is diviz by 2, and anything ending in 5 is diviz by 5
    S = [X || X <- eulermath:seive(10000), X /= 2, X /=5],
    erlang:display(length(S)),
    %There are 1227 primes below 10000 that are not 2,5
    SDMax = 10000000,
    SD = eulermath:seive_dict(SDMax),
    erlang:display("seives formed"),
    TwoFam = [X || X <- eulerlist:get_combinations(2,S), check_family(X, SD, SDMax) == true],
    erlang:display(length(TwoFam)),
    %a key observation I had later was the X > max(Y)
    ThreeFam = [ [X | Y] || X <- S, Y <- TwoFam, X > lists:max(Y), check_family_addition(Y, X, SD, SDMax) == true],
    erlang:display(length(ThreeFam)),
    FourFam = [ [X | Y] || X <- S, Y <- ThreeFam, X > lists:max(Y), check_family_addition(Y, X, SD, SDMax) == true],
    erlang:display(length(FourFam)),
    erlang:display(FourFam),
    FiveFam = [ [X | Y] || X <- S, Y <- FourFam, X > lists:max(Y), check_family_addition(Y, X, SD, SDMax) == true],
    %erlang:display(length(FiveFam)).
    erlang:display(FiveFam).

