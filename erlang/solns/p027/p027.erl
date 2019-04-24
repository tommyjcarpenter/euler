-module(p027).
-export([timesolve/0, solve/0]).

%Euler discovered the remarkable quadratic formula:
%
%n2+n+41n2+n+41
%It turns out that the formula will produce 40 primes for the consecutive integer values 0≤n≤390≤n≤39. However, when n=40,402+40+41=40(40+1)+41n=40,402+40+41=40(40+1)+41 is divisible by 41, and certainly when n=41,412+41+41n=41,412+41+41 is clearly divisible by 41.
%
%The incredible formula n2−79n+1601n2−79n+1601 was discovered, which produces 80 primes for the consecutive values 0≤n≤790≤n≤79. The product of the coefficients, −79 and 1601, is −126479.
%
%Considering quadratics of the form:
%
%n2+an+bn2+an+b, where |a|<1000|a|<1000 and |b|≤1000|b|≤1000
%
%where |n||n| is the modulus/absolute value of nn
%e.g. |11|=11|11|=11 and |−4|=4|−4|=4
%Find the product of the coefficients, aa and bb, for the quadratic expression that produces the maximum number of primes for consecutive values of nn, starting with n=0n=0.

timesolve() -> 
    erlang:display(timer:tc(p027, solve, [])).

solve() ->
    recurse_up(-999, -1000, {-1,-1,-1}).

recurse_up(1000, _, {MaxA, MaxB, _}) -> MaxA*MaxB;
recurse_up(A, 1001, {MaxA, MaxB, MaxStreak}) -> recurse_up(A+1, -1000, {MaxA, MaxB, MaxStreak});
recurse_up(A, B, {MaxA, MaxB, MaxStreak}) ->
    Streak = test_pair(A,B),
    case Streak > MaxStreak of 
        true -> recurse_up(A, B+1, {A,B,Streak});
        false -> recurse_up(A, B+1,{MaxA, MaxB, MaxStreak})
    end.

test_pair(A,B) -> do_test_pair(A,B,0).

do_test_pair(A,B,N) ->
    case eulermath:isprime(N*N + A*N + B) of 
        true -> do_test_pair(A,B,N+1);
        false -> N
    end.
