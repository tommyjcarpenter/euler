-module(eulerlist).
-export([flatten_one_layer/1,listslice/3,
         perms/1,
         perms_heap/1,
         alphabetnum/1, setnth/3, bjoin/1,  list_to_freq_map/1, binary_search/2,
         num_distinct_elements/1,
         remove_duplicates/1, perms_inc_less_than/1, all_subsets_no_empty/1, all_proper_subsets/1, special_subset/1,
         every_element_bigger/2,
         is_perm_of_list/2,
         is_perm_of_fd_list/2,
         get_combinations/2,
         interleave/2,
         filter_permutations/1,
         is_repeating/1,
         max_index/1,
         list_to_dict_key_by_index/1,
         multiply/1
         ]).

%2> eulerlist:flatten_one_layer([[[1],[2],[3]]]).
%[[1],[2],[3]]
%3> eulerlist:flatten_one_layer([[1,2],[3,4]]).
%[3,4,1,2]
flatten_one_layer(L) ->
    lists:foldl(fun(X, Acc) -> X ++ Acc end, [], L).

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
       true -> lists:sum(X) /= lists:sum(Y); %cond1
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

%stolen from the erlang book
%1> eulerlist:perms([4,2]).
%[[4,2],[2,4]]
%% WARNING: this naive algorithm doesn't work when the input has duplicates like [4,2,2].
perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].

%1> eulerlist:perms_inc_less_than([4,2]).
%[[4],[4,2],[2,4],[2]]
perms_inc_less_than([]) -> [];
perms_inc_less_than([H|[]]) -> [[H]];
perms_inc_less_than([H|T]) -> [[H]] ++ eulerlist:perms([H|T]) ++ perms_inc_less_than(T).

% NOTE:
% This was my very hacky implementation of "heaps algorithm for permutations" which I thought I needed for problem 62 but didn't.
% I call it hacky because it uses the profess dictionary to mutate lists, whioch is a no no.
% However, all the pseduo code I read for this algiorithm used a single mutatable array, so it was difficult to translate this into erlang which does not allow mutation, and I didn't have time to figure out how to adapt it.
% It remains to be seen whethger this is even faster at all than the very simple one above.
%procedure generate(n : integer, A : array of any):
%    if n = 1 then
%          output(A)
%    else
%        for i := 0; i < n; i += 1 do
%            generate(n - 1, A)
%            if n is even then
%                swap(A[i], A[n-1])
%            else
%                swap(A[0], A[n-1])
%            end if
%        end for
%    end if
%procedure generate(k : integer, A : array of any):
%    if k = 1 then
%        output(A)
%    else
%        // Generate permutations with kth unaltered
%        // Initially k == length(A)
%        generate(k - 1, A)
%
%        // Generate permutations for kth swapped with each k-1 initial
%        for i := 0; i < k-1; i += 1 do
%            // Swap choice dependent on parity of k (even or odd)
%            if k is even then
%                swap(A[i], A[k-1]) // zero-indexed, the kth is at k-1
%            else
%                swap(A[0], A[k-1])
%            end if
%            generate(k - 1, A)
%
%        end for
%    end if
init_fixed_array_list(L) ->
    A = array:new(length(L), {fixed, true}),
    do_init_fixed_array_list(L, 0, A).
do_init_fixed_array_list([], _, A) -> A;
do_init_fixed_array_list([H|T], I, A) ->
    do_init_fixed_array_list(T, I+1, array:set(I, H, A)).
perms_heap(L) ->
    A= init_fixed_array_list(L),
    erlang:put(arr, A),
    erlang:put(arrsolns, []),
    do_perms_heap(length(L)),
    erlang:get(arrsolns).
do_perms_heap(1) ->
    L = [X || X <- array:to_list(erlang:get(arr)), X /= undefined],
    erlang:put(arrsolns, lists:append([L], erlang:get(arrsolns)));
do_perms_heap(N) ->
    lists:map(fun(X) -> do_inner_generate(N, X) end, lists:seq(0, N-1)).

do_inner_generate(N, I) ->
    do_perms_heap(N-1),
    A = erlang:get(arr),
    case N rem 2 == 0 of
        true ->
            Temp = array:get(I, A),
            A2 = array:set(I, array:get(N-1, A), A),
            A3 = array:set(N-1, Temp, A2);
        false ->
            Temp = array:get(N-1, A),
            A2 = array:set(N-1, array:get(0, A), A),
            A3 = array:set(0, Temp, A2)
        end,
    erlang:put(arr, A3)
    .

%combinations shamefully stolen from http://stackoverflow.com/questions/30585697/how-to-rewrite-erlang-combinations-algorithm-in-elixir
get_combinations(0,_)  ->    [[]];
get_combinations(_,[]) ->    [];
get_combinations(N,[H|T]) -> [[H|L] || L <- get_combinations(N-1,T)]++get_combinations(N,T).


all_subsets_no_empty(L) -> [X || X <- all_proper_subsets(L) ++ [L], X /= []].

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

num_distinct_elements(L) ->
    FM = list_to_freq_map(L),
    dict:size(FM).

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

is_perm_of_list(L1, L2) ->     %determines if L1 is a permutation of L2
    eulerlist:list_to_freq_map(L1) == eulerlist:list_to_freq_map(L2).
is_perm_of_fd_list(FM1, L2) -> %same as above but used when you want to check L1 against many L2 so L1 was already compiled to a FM
    FM1 == eulerlist:list_to_freq_map(L2).

interleave(L1,L2) ->
    %Returns L1[0], L2[0],....,L1[N],L2[N]
    dointerleave(L1, L2, []).
dointerleave([], [], NewL) -> NewL;
dointerleave([L1H|L1T], [L2H|L2T], NewL) ->
    dointerleave(L1T, L2T, NewL ++ [L1H, L2H]).

filter_permutations(L) ->
    %takes a list of lists  L and returns a new list where all permutations of other elements in L have been removed
    %e.g., [ [1,2], [3,4], [2,1] ] returns [1,2], [3,4]
    LSorts = [lists:sort(X) || X <- L],
    FM = eulerlist:list_to_freq_map(LSorts),
    K = dict:fetch_keys(FM),
    K.

is_repeating(L) ->
    %determines whether L is a list of repeating numbers/binaries/strings. Finds the smallest repeater, e.g., 12 in 12121212 not 1212
    %Returns {sublist, lengthofsublist} where sublist is the repeater (maybe [])
    %Assumptions:
    %  1) Must repeat at least twice.
    %  2) COUNTS PARTIAL REPEATS AT THE END! Meaning if the pattern is 4 but the array is of length 15, will find the 4 4 4 then check the first 3 of the remaining 15
    %  With 1,2, this means [1,2,3,1,2] will not work but  [1,2,3,1,2,3,1,2] will return [1,2,3]
    do_is_repeating(L, trunc(length(L) / 2), "", 0).

do_is_repeating(_, 0, Entity, Max) -> {Entity, Max};
do_is_repeating(L, Length, Entity, EntityLength) ->
    Repeats = trunc(length(L) / Length),
    SL = lists:sublist(L, Length),
    case lists:flatten(lists:map(fun(_) -> SL end, lists:seq(1, Repeats))) ==
         lists:sublist(L, Repeats*Length) of
        true ->
            Leftover = length(L) - Repeats*Length,
            case Leftover == 0 orelse lists:sublist(L, Repeats*Length+1, Leftover) == lists:sublist(L, Leftover) of
                true ->
                    %we keep going because this would trigger e.g., 1212 in 12121212 but actally we want the smallest repeater 12
                    do_is_repeating(L, Length - 1, SL, Length);
                false ->
                    %the leftover does not match
                    do_is_repeating(L, Length - 1, Entity, EntityLength)
            end;
        false -> do_is_repeating(L, Length - 1, Entity, EntityLength)
    end.

max_index(L) ->
    %find the index of L at which L is maximized
    do_max_index(L, 1, -1, -1).

do_max_index([], _, _, MI) -> MI;
do_max_index([H|T], I, M, MI) ->
    case H > M of
        true -> do_max_index(T, I+1, H, I);
        false -> do_max_index(T, I+1, M, MI)
    end.

list_to_dict_key_by_index(L) ->
    %convert ["A", "B"] into {1 : "A", 2: "B"}
    do_list_to_dict_key_by_index(L, 1, dict:new()).
do_list_to_dict_key_by_index([], _, D) -> D;
do_list_to_dict_key_by_index([H|T], I, D) ->
    do_list_to_dict_key_by_index(T, I+1, dict:store(I, H, D)).

multiply(L) ->
    %from http://erlang.org/doc/man/lists.html#foldl-3
    lists:foldl(fun(X, Prod) -> X * Prod end, 1, L).
