-module(p072).
-export([timesolve/0, solve/0]).

%Consider the fraction, n/d, where n and d are positive integers. If n<d and HCF(n,d)=1, it is called a reduced proper fraction.

%If we list the set of reduced proper fractions for d ≤ 8 in ascending order of size, we get:

%1/8, 1/7, 1/6, 1/5, 1/4, 2/7, 1/3, 3/8, 2/5, 3/7, 1/2, 4/7, 3/5, 5/8, 2/3, 5/7, 3/4, 4/5, 5/6, 6/7, 7/8

%It can be seen that there are 21 elements in this set.

%How many elements would be contained in the set of reduced proper fractions for d ≤ 1,000,000?

timesolve() ->
    code:add_path("/Users/tommy/Development/github/euler"),
    erlang:display(timer:tc(p072, solve, [])).

solve() ->
    %so 1000000*1000000 is one billion.
    %my thinking is to brute force but trum several branches from the tree.
    % Prunings:
    %    if D is prime, there is only one fraction for d, 1/d.
    SL = eulermath:seive(1000000),
    iterate(2, 1000001, SL, 0, 0).

remove_dups([])    -> [];
remove_dups([H|T]) -> [H | [X || X <- remove_dups(T), X /= H]].

iterate(Stop, Stop, _, Count, Count2) -> {Count, Count2};
iterate(D, Stop, SL, Count, Count2) ->
    erlang:display(D),
    PF = remove_dups(eulermath:prime_factorization(SL, D)),
    T = eulermath:totient(PF, D),
    %L = length(eulermath:relative_primes(D)),
    %case T /= L of
    %    true ->
    %        erlang:display({mismatch, D, T, L});
    %    false ->ok
    %end,
    iterate(D+1, Stop, SL, Count + T, Count2 + T).
