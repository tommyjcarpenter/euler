-module(p069).
-export([timesolve/0, solve/0]).

timesolve() ->
    erlang:display(timer:tc(p069, solve, [])).

solve() ->
    MAXN = 1000000,
    S = eulermath:seive(MAXN),
    PFacs = lists:map(fun(X) -> pfac(X, S) end, lists:seq(1,MAXN)),
    erlang:display("Creating dict"),
    PFacsDict = eulerlist:list_to_dict_key_by_index(PFacs),
    erlang:display("Computing Ts"),
    Ts = lists:map(fun(X) -> totient_rat(X, PFacsDict) end, lists:seq(1,MAXN)),
    eulerlist:max_index(Ts).


pfac(N, S) ->
    P = erlang:get(N),
    case is_list(P) of
        true -> P;
        false ->
            % adding in a bunch of other factors here is dramatically faster than running this for all 1,000,000
            PF = eulermath:prime_factorization(S, N),
            erlang:put(N, PF),
            erlang:put(N*2, [2 | PF]),
            erlang:put(N*3, [3 | PF]),
            erlang:put(N*5, [5 | PF]),
            erlang:put(N*7, [7 | PF]),
            erlang:put(N*11, [11 | PF]),
            erlang:put(N*13, [13 | PF]),
            erlang:put(N*17, [17 | PF]),
            erlang:put(N*19, [19 | PF]),
            PF
    end.

totient_rat(N, PFacsDict) ->
    % from https://en.wikipedia.org/wiki/Euler%27s_totient_function
    Facs = [1 - 1/X || X <- sets:to_list(sets:from_list(dict:fetch(N, PFacsDict)))],
    1 / eulerlist:multiply(Facs).
