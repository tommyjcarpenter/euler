-module(p051).
-export([timesolve/0, solve/0]).

%By replacing the 1st digit of the 2-digit number *3, it turns out that six of the nine possible values: 13, 23, 43, 53, 73, and 83, are all prime.

%By replacing the 3rd and 4th digits of 56**3 with the same digit, this 5-digit number is the first example having seven primes among the ten generated numbers, yielding the family: 56003, 56113, 56333, 56443, 56663, 56773, and 56993. Consequently 56003, being the first member of this family, is the smallest prime with this property.

%Find the smallest prime which, by replacing part of the number (not necessarily adjacent digits) with the same digit, is part of an eight prime value family.

timesolve() ->
    erlang:display(timer:tc(p051, solve, [])).


% TODO: change lists to represent digit lists to dicts or some other O(1) replace data structure.
% I am aware this is horribly innefficient. Linked lists are the WRONG data structure for this. Specifically the eulerlist:replace_nth is a super inneficient way to do this. Some kind of dict of digits would be much faster. Maybe a string is better in some languages but in Erlang they are just lists too so a string replace is probably not good too. Need to be able to change ABCDE to AXCDE in O(1) time.
% However I don't have unlimited free time so I have to decide whether to keep moving on other problems or purify each one, so in the interest of time here I'm moving on =).
substitute(X, [], _) -> X;
substitute(X, [H|Positions], E) ->
    substitute(eulerlist:setnth(X, H, E), Positions, E).

form_substitutions(X) ->
    XDig = eulermath:digitize(X),
    NumXDig = eulermath:num_digits(X),
    Tries = eulerlist:all_subsets_no_empty(lists:seq(1,NumXDig)),
    [ [substitute(XDig, T, Z) || Z <- lists:seq(0,9)] || T <- Tries] .

primes_in_l(SD, [], SoFar) -> SoFar;
primes_in_l(SD, [H|L], SoFar) ->
    case dict:is_key(H, SD) of
        true -> primes_in_l(SD, L, [H | SoFar]);
        false -> primes_in_l(SD, L, SoFar)
    end.
primes_and_lowest_in_l(SD, L) ->
    %takes in a sieve dict and a list L and determines how many numbers in L are prime
    Primes = primes_in_l(SD, L, []),
    LP = length(Primes),
    case LP of
        0 -> {null, 0};
        _ -> {LP, lists:min(Primes)}
    end.

primes_in_family(F, SD, Floor) ->
  Ints = [eulermath:digit_list_to_int(X) || X <- F],
  ValidInts = eulerlist:remove_duplicates([X || X <- Ints, X >= Floor]), %need this due to the way digit_list_to_int works, concatenating leading 0s
  primes_and_lowest_in_l(SD, ValidInts).

solve() ->
    SD = eulermath:seive_dict(1000000),
    dosolve(56003, SD).

dosolve(N, SD) ->
    Floor = eulermath:integerpow(10, eulermath:num_digits(N)-1),
    Subs = form_substitutions(N),
    PIF = [primes_in_family(X, SD, Floor) || X <- Subs],
    ValidPIF = [{X,Y} || {X,Y} <- PIF, X /= null],
    {NumInFamily, LowestPrime} = lists:max(ValidPIF),
    case NumInFamily >= 8 orelse N > 1000000 of
        true -> {NumInFamily, LowestPrime};
        false -> dosolve(N+1, SD)
    end.

