-module(p076_right_answer_after_31_but_way_too_slow).
-export([timesolve/0, solve/0]).

timesolve() ->
    erlang:display(timer:tc(p076_right_answer_after_31_but_way_too_slow, solve, [])).

solve() ->
    N = 40,
    A = initd(array:new(), 1, N),
    do(A, N).


initd(A, I, N) when I == N -> A; %no slot for N as we don't allow N+0
initd(A, I, N) ->
    initd(array:set(I, 0, A), I+1, N).


%computes the score of a dict
score(A, N) -> score(A, 1, N).
score(_, I, N) when I == N -> 0;
score(A, I, N) ->
    I*array:get(I, A) + score(A, I+1, N).  % slot 1 is the 1 slot,....slot N is the N-1 slot

do(A, N) ->
    L = array_to_rep(A,N),
    F = erlang:get(L),
    case is_integer(F) of
        true -> 0; %already counted this exact combo
        false ->
            S = score(A, N),
            R = case S > N of % this dict (slot array) has exceeded N, it can never be a solution
                  true -> 0;
                  false ->
                      case S == N of
                          true -> 1; % on the money, this is a solution
                          false ->  % still under N, increase each slot of A
                              %if our score is S, there is no point in trying any array
                              %slot > (N-S). E.g., if N=6 and score = 2,
                              %trying slot 5 will never work. Last slot that will work is 4=N-2=6-2
                              %if the score is 0, try all N-1
                              Seq = case S == 0 of
                                  true -> lists:seq(1,N-1);
                                  false -> lists:seq(1,N-S)
                              end,
                              lists:sum([do(array:set(I, array:get(I, A)+1, A), N) || I <- Seq])
                      end
            end,
            erlang:put(L, R),
            R
    end.

array_to_rep(A, N) ->
    L = array_to_rep(A, 1, N),
    list_to_binary(L).
array_to_rep(_, I, N) when I == N -> [];
array_to_rep(A, I, N) ->
    [array:get(I, A) | array_to_rep(A,I+1,N)].
