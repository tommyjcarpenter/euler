-module(p205).
-export([timesolve/0, solve/0]).

%Peter has nine four-sided (pyramidal) dice, each with faces numbered 1, 2, 3, 4.
%Colin has six six-sided (cubic) dice, each with faces numbered 1, 2, 3, 4, 5, 6.
%
%Peter and Colin roll their dice and compare totals: the highest total wins. The result is a draw if the totals are equal.
%
%What is the probability that Pyramidal Pete beats Cubic Colin? Give your answer rounded to seven decimal places in the form 0.abcdefg

timesolve() ->
    erlang:display(timer:tc(p205, solve, [])).


solve() ->
    %forum post I wrote later ->
    %Mine (Erlang) runs in about half a second. Here is my solution outline.
    %1) Compute all combinations for P (262,144)
    %2) Compute all combinations for C (46,656)
    %3) Build an "inverse CDF" for P. I formed a dict f(X) where X in range(6, 37) where f(X) is the number of sums in Peters combos strictly greater than X, because w.r.t. the question, Colin wins on a draw. This is an O(N) operation.
    %4) Simply sum over Cs combos and add up f(c)
    %5) divide by 12230590464 (6^6*4^9)
    %6) Profit! Answer is exactly 5.731441e-01


    P = iteratep(), % this is only 4^9=262,144
    C = iteratec(), % this is only 6^6=46,656

    %So now there are 12,230,590,464 combinations (262144*46656) however we can be spart and
    %make a CDF frequency dictionary across the 262k (O(N)) that just keeps track of how many sums are greater than X. Then just iterate over the 46k and compyute it out.

    D = build_d(P),
    CDF = build_cdf(D),
    compute_probs(C, CDF).


iteratep() -> iteratep(1,1,1,1,1,1,1,1,1, []).
iteratep(A,B,C,D,E,F,G,H,5,SoFar) -> iteratep(A,B,C,D,E,F,G,H+1,1,SoFar);
iteratep(A,B,C,D,E,F,G,5,_,SoFar) -> iteratep(A,B,C,D,E,F,G+1,1,1,SoFar);
iteratep(A,B,C,D,E,F,5,_,_,SoFar) -> iteratep(A,B,C,D,E,F+1,1,1,1,SoFar);
iteratep(A,B,C,D,E,5,_,_,_,SoFar) -> iteratep(A,B,C,D,E+1,1,1,1,1,SoFar);
iteratep(A,B,C,D,5,_,_,_,_,SoFar) -> iteratep(A,B,C,D+1,1,1,1,1,1,SoFar);
iteratep(A,B,C,5,_,_,_,_,_,SoFar) -> iteratep(A,B,C+1,1,1,1,1,1,1,SoFar);
iteratep(A,B,5,_,_,_,_,_,_,SoFar) -> iteratep(A,B+1,1,1,1,1,1,1,1,SoFar);
iteratep(A,5,_,_,_,_,_,_,_,SoFar) -> iteratep(A+1,1,1,1,1,1,1,1,1,SoFar);
iteratep(5,_,_,_,_,_,_,_,_,SoFar) -> SoFar;
iteratep(A,B,C,D,E,F,G,H,I,SoFar) ->
    iteratep(A,B,C,D,E,F,G,H,I+1, [[A,B,C,D,E,F,G,H,I] | SoFar]).

iteratec() -> iteratec(1,1,1,1,1,1,[]).
iteratec(A,B,C,D,E,7,SoFar) -> iteratec(A,B,C,D,E+1,1,SoFar);
iteratec(A,B,C,D,7,_,SoFar) -> iteratec(A,B,C,D+1,1,1,SoFar);
iteratec(A,B,C,7,_,_,SoFar) -> iteratec(A,B,C+1,1,1,1,SoFar);
iteratec(A,B,7,_,_,_,SoFar) -> iteratec(A,B+1,1,1,1,1,SoFar);
iteratec(A,7,_,_,_,_,SoFar) -> iteratec(A+1,1,1,1,1,1,SoFar);
iteratec(7,_,_,_,_,_,SoFar) -> SoFar;
iteratec(A,B,C,D,E,F,SoFar) ->
    iteratec(A,B,C,D,E,F+1, [[A,B,C,D,E,F] | SoFar]).

%build dict of sum counts
build_d(L) -> build_d(L, dict:new()).
build_d([], D) -> D;
build_d([H|T], D) ->
    S = lists:sum(H),
    V = case dict:is_key(S, D) of
            true -> dict:fetch(S, D) +1;
            false -> 1
    end,
    D2 = dict:store(S, V, D),
    build_d(T, D2).

%now convert that into an "inverse CDF"
%where f(X) is number of pete rolls STRICTLY GREATER than X, since w.r.t. the question, colin wins on a draw
build_cdf(D) ->
    %min should be 9, max should be 36
    Start = dict:new(),
    %Peter cannot roll a 6 or 7 or an 8 but Colin can. All of peters are greater than this
    Start2 = dict:store(36, 0, Start),
    Start3 = dict:store(6, 262144, Start2),
    Start4 = dict:store(7, 262144, Start3),
    build_cdf(8, D, Start4).
build_cdf(36, _, CDFD) -> CDFD;
build_cdf(I, D, CDFD) ->
    S = lists:sum([dict:fetch(X, D) || X<- lists:seq(I+1, 36)]),
    NewCDFD = dict:store(I, S, CDFD),
    build_cdf(I+1, D, NewCDFD).

compute_probs(Colin, PeterCDF) -> compute_probs(Colin, PeterCDF, 0).
compute_probs([], _, NumeratorSoFar) ->
    %(4^9)*(6^6) = 12,230,590,464
    NumeratorSoFar / 12230590464;
compute_probs([ColinH|T], PeterCDF, NumeratorSoFar) ->
    %pete only wins if his total is stricly greater than, colin takes it w.r.t. this question in a draw.
    ColinRoll = lists:sum(ColinH),
    compute_probs(T, PeterCDF, NumeratorSoFar + dict:fetch(ColinRoll, PeterCDF)).
