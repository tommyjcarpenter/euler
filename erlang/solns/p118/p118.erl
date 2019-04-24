-module(p118).
-export([timesolve/0, solve/0]).

%Using all of the digits 1 through 9 and concatenating them freely to form decimal integers, different sets can be formed. Interestingly with the set {2,5,47,89,631}, all of the elements belonging to it are prime.
%
%How many distinct sets containing each of the digits one through nine exactly once contain only prime elements?
%
%
%
%
%2> p118:timesolve().
%{88599342,44680}
%(88 seconds)
timesolve() -> timer:tc(p118, solve, []).

solve() ->
    %generate a hashmap seive for fast lookups of primes. we will leave large primes to tes manually
    SD1M = eulermath:seive_dict(1000000),%passing this around makes the code ugly, but all in the name of speed my son
    RawGroupings =  plists:map(fun(X) -> 
                    all_consecutive_groupings(X,SD1M) end, 
                    %the question says "distinct sets" like {2,5,47,89,631}, which means we should exclude {631,2,5,47,89}, which means we should eliminate all rotations
                    eulerlist:perms([1,2,3,4,5,6,7,8,9]),
                    {processes, schedulers}),
    Solns = [X || X <- eulerlist:flatten_one_layer(RawGroupings), X /= []],
    lists:sum([post_process(X) || X <-Solns]).
    
post_process(L) ->
    M = lists:sort(dict:fetch_keys(eulerlist:list_to_freq_map(L))),
    Cache = erlang:get({solns, M}),
    if is_integer(Cache) -> 0;
    true -> erlang:put({solns, M}, 1), 1
    end.
 
check_int(X,SD1M) ->
    if X < 1000000 -> dict:is_key(X, SD1M);
    true -> eulermath:isprime(X)
    end.
    
all_consecutive_groupings(L,SD1M) ->
    Dividers = eulerlist:all_subsets_no_empty(lists:seq(1, 9)),
    [split_list(X, L,SD1M) || X <- Dividers].

split_list([H|T], L,SD1M) ->
    if H /= 1 -> 
        A = dosplit_list([1|[H|T]], L,SD1M);
    true -> 
        A =dosplit_list([H|T], L,SD1M)
    end,
    case lists:member(false, A) of 
        true -> [];
        false -> A
    end.
dosplit_list([H|[]],  L,SD1M) ->
  AH = eulermath:digit_list_to_int(lists:sublist(L, H, 9)),
  case check_int(AH,SD1M) of 
     true -> [AH];
     false -> [false|[]]
  end;
dosplit_list([H|T],  L,SD1M) ->
  AH = eulermath:digit_list_to_int(lists:sublist(L, H, lists:nth(1, T)-H)),
  case check_int(AH,SD1M) of 
     true ->
         [AH] ++ dosplit_list(T, L,SD1M);
     false -> [false] %try to fail as soon as we get to a false
  end.
