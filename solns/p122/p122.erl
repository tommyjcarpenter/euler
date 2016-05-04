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
    S = sets:from_list([1,2]),
    S2 = sets:from_list([1,2,3]),
    erlang:min(minimal_sum(S, 15, 0), minimal_sum(S2, 15, 1)).

%solve_k(K) -> solve_for_k([1], K, 0).
%solve_for_k(SetsoFar, K, AddSoFar) ->
%    Solns = [X || X <- SetsoFar, X+

%Figures out minimal number of additions from Set to get to Target
% Does this by taking min(solution using largest), min(solution without using largest) at each step
minimal_sum(Set, Target, NumberAdds) ->
    SL = sets:to_list(Set),
    if length(SL) == 0 -> 1000000000000000000000000000000000; %something big because this solution is infeasible
    true -> 
        Solns = [X || X <- SL,  X == Target],
        if length(Solns) == 1 -> NumberAdds; %get to target
        true ->
            M = lists:max(SL),
            erlang:min(minimal_sum(Set, Target-M, NumberAdds+1), minimal_sum(sets:del_element(M, Set), Target, NumberAdds))
        end
    end.

    






