-module(p106).
-export([timesolve/0, solve/0]).

%%%%%%%%%%%
%NOTE: THIS PROBLEM IS DUMB!!!!
%
%The wording in this problem is atrocious. 
%
%It is clear that for a given set A, if it has T subset pairs, we only have to check equality for 
%those that have the same number of elements. For those that have different elements we check condition 2. 
%
%For N=7, T=966, and 196 of those have the same number of elements. So, why do we need to check only
%70??? 
%
%After racking my brain, I eventually Googled for an explanation of what is actually being asked  here,
%and the explanation I saw was "if all elements of one set are bigger than all elements of another
%set, clearly their sums are not equal, so they are saying there are 70 where you can't use this
%"trick" and actually have to compute the sum of the two sets". But this is just ANOTHER WAY of computing that their sums
%are not equal. THis is no more efficient than just taking the f----ing sums. 
%
%So unless I am missing something, this problem is rediculous, or at the very least, it's wording. 
%%%%%%%%%%%%%
%
%Let S(A) represent the sum of elements in set A of size n. We shall call it a special sum set if
%for any two non-empty disjoint subsets, B and C, the following properties are true:
%
%S(B) ≠ S(C); that is, sums of subsets cannot be equal.
%If B contains more elements than C then S(B) > S(C).
%For this problem we shall assume that a given set contains n strictly increasing elements and it
%already satisfies the second rule.
%
%Surprisingly, out of the 25 possible subset pairs that can be obtained from a set for which n = 4,
%only 1 of these pairs need to be tested for equality (first rule). Similarly, when n = 7, only 70
%out of the 966 subset pairs need to be tested.
%
%For n = 12, how many of the 261625 subset pairs that can be obtained need to be tested for
%equality?
%
%
timesolve() -> timer:tc(p106, solve, []).

solve() ->
    _ = special_subset_dumb([100,101,102,103,104,105,106,107,108,109,110,111]),
    erlang:display( erlang:get({'horrible_to_do_this'})).

special_subset_dumb(F) ->
    S = eulerlist:all_proper_subsets(F),
    L =  [{X, Y} || X <- S, Y <- S, X > Y, X /= [], Y /= [], length(sets:to_list(sets:intersection(sets:from_list(X), sets:from_list(Y)))) == 0],
    erlang:put({'horrible_to_do_this'}, 0),
    lists:foldl(
      fun({X, Y}, Last) -> special_subset_check_ss_dumb({X, Y}) andalso Last end, true, L).%, {processes, schedulers}).
special_subset_check_ss_dumb({X, Y}) ->
    case length(X) == length(Y) of
       true -> 
            case eulerlist:every_element_bigger(X, Y) of 
                true -> true; %"no need to check this one...."
                false ->
                    V = erlang:get({'horrible_to_do_this'}),
                    erlang:put({'horrible_to_do_this'}, V+1),
                    lists:sum(X) /= lists:sum(Y) %cond1
                end;
       false -> %cond2
          case length(X) > length(Y) of
              true -> lists:sum(X) > lists:sum(Y);
              false -> lists:sum(Y) > lists:sum(X)
          end
    end.
