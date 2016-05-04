%The most naive way of computing n15 requires fourteen multiplications:
%
%n × n × ... × n = n15
%
%But using a "binary" method you can compute it in six multiplications:
%
%n × n = n2
%n2 × n2 = n4
%n4 × n4 = n8
%n8 × n4 = n12
%n12 × n2 = n14
%n14 × n = n15
%
%However it is yet possible to compute it in only five multiplications:
%
%n × n = n2
%n2 × n = n3
%n3 × n3 = n6
%n6 × n6 = n12
%n12 × n3 = n15
%
%We shall define m(k) to be the minimum number of multiplications to compute nk; for example m(15) =
%5.
%
%For 1 ≤ k ≤ 200, find ∑ m(k).

-module(p122).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p122, solve, []).

solve() ->
    lists:sum(plists:map(fun(X) -> docost(X) end, lists:seq(2,100))).
    %docost(15).

docost(Target) -> 
    C = cost(Target, sets:from_list([1])),
    erlang:put({'docost', Target}, C),
    erlang:display({Target, C}), 
    C.

check_cache(Target, Set) ->
  case sets:is_element(Target, Set) of
  true -> 0;
  false ->
    %erlang:display({Target, sets:to_list(Set)}),
    case sets:size(Set) of 
    1 ->
    %erlang:display(entering),
    %if size(Set) == [1] ->
        Cache = erlang:get({'docost', Target}),
        if is_integer(Cache) -> Cache;
        true -> cost(Target, Set)
        end;
    _ ->
    %erlang:display({Target, sets:to_list(Set)}),
    SMSet = sets:from_list([X || X <- sets:to_list(Set), X < Target]),
           Cache = erlang:get({'cost', Target, SMSet}),
           if is_integer(Cache) ->  Cache;
           true -> cost(Target, Set)
           end
    end
  end.


cost(Target, Set) ->
             Pairs = [{X,Y} || X <- lists:seq(1,Target-1), Y <- lists:seq(1, Target-1), X+Y == Target, X >= Y],
                C = lists:min(lists:map(fun({X,Y}) ->
                                            A = check_cache(X, sets:add_element(Y, Set)),
                                            B = check_cache(Y, Set),
                                            if X == Y -> 1 + B; %only pay for Y once
                                            true -> 1+ B + A %Only pay for Y once
                                            end
                                            end, Pairs)),
             %end,
             erlang:put({'cost', Target, Set}, C),
             C.
%
%
%
%test(Target, OrigTarget, StepsSoFar) ->
%    erlang:display(Target),
%    C = erlang:get({'test', OrigTarget}),
%    case is_integer(C) of 
%        true -> C;
%        false ->
%            if Target == 1 -> 
%                StepsSoFar;
%            true -> 
%                PossSums = [erlang:max(A,B) || A <- lists:seq(1,Target), B <- lists:seq(1,Target), A + B == Target],
%                A = lists:min(lists:map(fun(X) -> test(X, OrigTarget, StepsSoFar+1) end, PossSums)),
%               %erlang:put({'test', OrigTarget}, A),
%               A
%        end      
%    end.
%        
%set_expand_until_target_found(Set, ExpansionNum, Target) ->
%    case sets:is_element(Target, Set) of 
%        true -> erlang:display({Set, Target, ExpansionNum}), ExpansionNum;
%        _ ->
%             SL = sets:to_list(Set),
%             AllSums = [X+Y || X <- SL, Y <- SL, not sets:is_element(X+Y, Set)],
%             lists:min(lists:map(fun(X) -> set_expand_until_target_found(sets:add_element(X, Set), ExpansionNum+1, Target) end, AllSums))
%             %set_expand_until_target_found(NewSet, ExpansionNum+1, Target)
%    end.
%         
%
%%solve_k(K) -> solve_for_k([1], K, 0).
%%solve_for_k(SetsoFar, K, AddSoFar) ->
%%    Solns = [X || X <- SetsoFar, X+
%
%%Figures out minimal number of additions from Set to get to Target
%% Does this by taking min(solution using largest), min(solution without using largest) at each step
%minimal_sum(Set, Target, NumberAdds) ->
%    SL = sets:to_list(Set),
%    if length(SL) == 0 -> 1000000000000000000000000000000000; %something big because this solution is infeasible
%    true -> 
%        Solns = [X || X <- SL,  X == Target],
%        if length(Solns) == 1 -> NumberAdds; %get to target
%        true ->
%            M = lists:max(SL),
%            erlang:min(minimal_sum(Set, Target-M, NumberAdds+1), minimal_sum(sets:del_element(M, Set), Target, NumberAdds))
%        end
%    end.
%
%    
%
%
%
%
%
%
