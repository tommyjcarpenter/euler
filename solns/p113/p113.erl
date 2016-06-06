-module(p113).
-export([timesolve/0, solve/0]).

timesolve() -> timer:tc(p113, solve, []).

solve() ->
    solve_0(100).
    %Num = 6,
    %Tots = 10000000,
    %{solve_0(7), length([X || X <- lists:seq(1,Tots-1), not eulermath:is_bouncy(X)])}. 

solve_0(Zeros) -> 
    prepend([[]], 0, Zeros,0) - Zeros.

unique(L) -> sets:to_list(sets:from_list(L)).



reduce(Sets) ->
    F = eulerlist:list_to_freq_map(Sets),
    A = dict:to_list(F),
    B = [{X*Y, D, Dir} || {{X, D, Dir},Y} <- A],
    B.



prepend(Sets, Depth, StoppingDepth, SolnsSoFar) ->
            %erlang:display({Depth, length(Sets), SolnsSoFar, Sets}),
            %erlang:display(Sets),
            M = lists:foldl(fun(Y, Acc) -> Y ++ Acc end, [], 
                 %MAKE PARALLEL AGAIN
                 lists:map(fun(X) -> prepend_spec_list(X) end, Sets)%, {processes, schedulers})
                ),
            %erlang:display(M),
            L = reduce(M),
            %erlang:display(L),
            %erlang:display(R),
            %Do a cleaning operation. If we are at Depth 2, and one is already decreasing and starts
            %with a 9, then there are StoppingDepth - Depth more numbers. 
%            if Depth > 1 ->
%                 NewL1 = lists:filter(fun({H, Dir}) ->  
%                           not (H == 9 andalso Dir == dec) andalso
%                           not (H == 1 andalso Dir == inc)
%                           end, L%, {processes, schedulers} 
%                                  ),
%                 Diff = length(L) - length(NewL1),
%
%                 NewL2 = lists:filter(fun({H, Dir}) -> 
%                                      not (H == 2 andalso Dir == inc) andalso 
%                                      not (H == 8 andalso Dir == dec)
%                                      end, NewL1),
%                 Diff2 = length(NewL1) - length(NewL2),
%         
%                 NewL = lists:filter(fun({H, Dir}) -> 
%                                      not (H == 3 andalso Dir == inc) andalso 
%                                      not (H == 7 andalso Dir == dec)                                      
%                                      end, NewL2),
%                 Diff3 = length(NewL2) - length(NewL),
%
%                 NewTotal = 0 
%                 + Diff3*(sum_levels_out_3inc7dev(StoppingDepth-Depth-1)) 
%                 +  Diff2*(sum_levels_out_2inc8dec(StoppingDepth-Depth-1,0)) 
%                 + length(L) 
%                 + SolnsSoFar 
%                 + Diff*(StoppingDepth-Depth-1);
%            true -> 
                 %NewL = L,
             NewTotal = lists:sum([X || {X,_,_} <- L]) + SolnsSoFar,
%            end
            %,
        if Depth+1 == StoppingDepth -> 
               NewTotal;
        true-> prepend(L, Depth+1, StoppingDepth, NewTotal)
        end.

sum_levels_out_2inc8dec(0,_) -> 0;
sum_levels_out_2inc8dec(LevelsLeft, CurLevel) ->  2 + CurLevel + sum_levels_out_2inc8dec(LevelsLeft-1, CurLevel+1).

sum_levels_out_3inc7dev(0) -> 0;
sum_levels_out_3inc7dev(1) -> 3;
sum_levels_out_3inc7dev(LevelsLeft) -> 3+lists:sum(lists:seq(3,3+LevelsLeft-2)) + sum_levels_out_3inc7dev(LevelsLeft-1).

sum_levels_out_4inc6dec(0) -> 0;
sum_levels_out_4inc6dec(1) -> 4;
sum_levels_out_4inc6dec(2) -> 10;
sum_levels_out_4inc6dec(LevelsLeft) -> 6+lists:sum(lists:seq(4,4+LevelsLeft-3)) + sum_levels_out_4inc6dec(LevelsLeft-1).


%takes a list like {[3,2,1], down} and returns {[3,3,2,1],down}{[9,4,2,1], down}
prepend_spec_list([]) ->
    lists:map(fun(X) -> {1, X, both} end, lists:seq(0,9));
prepend_spec_list({Multiplier, Set_Prepend_To_H, Dir}) ->
    %only prepend a 0 if its all 0s
    case Set_Prepend_To_H == 0 of
      true -> lists:map(fun(X) -> {Multiplier, X, dec} end, lists:seq(1, 9)) ++ [{Multiplier, 0, dec}];
      false ->
         if Dir == both  ->   %if we have just one digit, or a string with all the same like 22222, add all 9
           lists:map(fun(X) -> {Multiplier, X, inc} end, lists:seq(1, Set_Prepend_To_H-1)) 
           ++ [{Multiplier, Set_Prepend_To_H, both}] 
           ++ lists:map(fun(X) -> {Multiplier, X, dec} end, lists:seq(Set_Prepend_To_H+1, 9));
         true ->    
           if Dir == dec -> 
             lists:map(fun(X) -> {Multiplier, X, dec} end, lists:seq(Set_Prepend_To_H, 9));
           true ->
             lists:map(fun(X) -> {Multiplier, X, inc} end, lists:seq(1, Set_Prepend_To_H))
           end
       end
    end.

