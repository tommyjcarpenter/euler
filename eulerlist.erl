-module(eulerlist).
-export([listslice/3, perms/1, alphabetnum/1, setnth/3, bjoin/1,  list_to_freq_map/1, binary_search/2,
        remove_duplicates/1, perms_inc_less_than/1, all_proper_subsets/1, special_subset/1,
        every_element_bigger/2, unique/1]).

unique(L) -> sets:to_list(sets:from_list(L)).

special_subset(F) ->
    %check condition from problem 103, 105:
    %Let S(A) represent the sum of elements in set A of size n. We shall call it a special sum set
    %if for any two non-empty disjoint subsets, B and C, the following properties are true:
    %
    % 1) S(B) ≠ S(C); that is, sums of subsets cannot be equal.
    % 2) If B contains more elements than C then S(B) > S(C).
    %
    % If they are of the same length, we must check 1 (2 does not apply).
    % If they are NOT of the same length, we check 2. % Note that in this case, if 2 holds, 1 holds (if S(B) > S(C), then they are obv. not equal)
    %
    %WARNING; expensive. do not run too many times, filter first!
    S = eulerlist:all_proper_subsets(F),
    L =  [{X, Y} || X <- S, Y <- S, X > Y, X /= [], Y /= [], length(sets:to_list(sets:intersection(sets:from_list(X), sets:from_list(Y)))) == 0],
    lists:foldl(
      fun({X, Y}, Last) -> special_subset_check_ss({X, Y}) andalso Last end, true, L).%, {processes, schedulers}).
special_subset_check_ss({X, Y}) ->
    case length(X) == length(Y) of
       true -> erlang:display("asdf"), lists:sum(X) /= lists:sum(Y); %cond1
       false -> %cond2
          case length(X) > length(Y) of
              true -> lists:sum(X) > lists:sum(Y);
              false -> lists:sum(Y) > lists:sum(X)
          end
    end.
   
every_element_bigger(X, Y) ->
    %determines whether, if X and Y are sorted lists of size N, whether X[i] > Y[i] forall i or Y[I] > X[I] for all i
    SX = lists:sort(X),
    SY = lists:sort(Y),
    doeveryelb(SX, SY) orelse doeveryelb(SY, SX).
doeveryelb([], []) -> true;
doeveryelb([SXH | SXT], [SYH | SYT]) ->
    case SXH > SYH of 
    true -> doeveryelb(SXT, SYT);
    false -> false
    end.

bjoin(L) ->   
    F = fun(A, B) -> <<A/binary, B/binary>> end,
    lists:foldr(F, <<>>, L).

%1> eulerlist:perms_inc_less_than([4,2]).
%[[4],[4,2],[2,4],[2]]
perms_inc_less_than([]) -> [];
perms_inc_less_than([H|[]]) -> [[H]];
perms_inc_less_than([H|T]) -> [[H]] ++ eulerlist:perms([H|T]) ++ perms_inc_less_than(T).

%stolen from the erlang book
%1> eulerlist:perms([4,2]).
%[[4,2],[2,4]]
perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].

all_proper_subsets([]) -> [];
all_proper_subsets([H|T]) ->  [T] ++  lists:map(fun(X) -> lists:flatten([H, X]) end, all_proper_subsets(T)) ++ all_proper_subsets(T).

listslice(StartIndex, EndIndex, L) ->
    {ToE, _} = lists:split(EndIndex, L),
    {_, M} = lists:split(StartIndex-1, ToE),
    M.

alphabetnum(Char) ->
    case Char of
        <<"A">> -> 1;<<"B">> -> 2;<<"C">> -> 3;<<"D">> -> 4;<<"E">> -> 5;<<"F">> -> 6;<<"G">> -> 7;<<"H">> -> 8;<<"I">> -> 9;<<"J">> -> 10;<<"K">> -> 11;<<"L">> -> 12;<<"M">> -> 13;<<"N">> -> 14;<<"O">> -> 15;<<"P">> -> 16;<<"Q">> -> 17;<<"R">> -> 18;<<"S">> -> 19;<<"T">> -> 20;<<"U">> -> 21;<<"V">> -> 22; <<"W">> -> 23; <<"X">> -> 24; <<"Y">> -> 25;<<"Z">> -> 26
   end.

list_to_freq_map(L) ->
    doltofm(L, dict:new()).
doltofm([], D) -> D;
doltofm([H|T], D) ->
    doltofm(T, dict:update(H, fun(X) -> X+1 end, 1, D)).

%% setnth(List, Index, NewElement) -> List.
setnth([_|Rest], 1, New) -> [New|Rest];
setnth([E|Rest], I, New) -> [E|setnth(Rest, I-1, New)].

remove_duplicates(L) -> sets:to_list(sets:from_list(L)).

%binary search stolen from https://gist.github.com/Janiczek/3133037
binary_search(List, N) ->
  Length = length(List),
  Middle = (Length + 1) div 2, %% saves us hassle with odd/even indexes
  case Middle of
    0 -> false; %% empty list -> item not found
    _ -> 
      Item = lists:nth(Middle, List),
      
      case Item of
        N -> true; %% yay, found it!
        _ -> case Item > N of
               true  -> binary_search(lists:sublist(List, Length - Middle), N); %% LT, search on left side
               false -> binary_search(lists:nthtail(Middle, List), N)           %% GT, search on right side
             end
      end
  end.
