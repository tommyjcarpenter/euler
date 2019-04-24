-module(p491).
-export([timesolve/0, solve/0]).

-import(eulerutil, [dfetch/3]).

timesolve() -> 
    erlang:display(timer:tc(p491, solve, [])).

%%%%
%%%Notes!!!
%%%
%%%%Biggest =  9988776655,  % 9+9+8+8+7+7+6+6+5+5 = 70
    %Smallest = 1010223344, % 1+1+2+2+3+3+4+4     = 20
    %50 = lists:sum(eulermath:digitize(Biggest)) - lists:sum(eulermath:digitize(Smallest)),
    % Since 50 is the largest possible gap, that leaves 44, 22, 11, 0, -11, -22, -44
    %184756 = length(Cs), %20!/(10!(20−10)!) = 184756
    %
    %Notes on how I derived the numbers:
    %get_44s(Cs) -> 
    %    Max is 70
    %    %Min is 20
    %    %Total is always 1+1+2+2+3+3+4+4+5+5+6+6+7+7+8+8+9+9=90
    %    %CANT GO HIGHER {70, 26}, {69, 25}, {68,24}, {67,23}, {66,22}, {65,21}, {64,20} CANT GO LOWER
    %    
    %    %90-70=20, invalid (gap must be 44)
    %    %90-69=21, invalid 
    %    %90-68=22, invalid
    %    %90-67=23, 67-23 = 44 VALID!! also 23-67 = -44
    %    %90-66=24, invalid
    %    %90-65=25, invalid
    %    %90-64=26, invalid
    %    get_helper(Cs, 67, 23) + get_helper(Cs, 23, 67).
    %
    %get_22s(Cs) ->
    %    %Range: {70,48}, ......, {44,20}
    %    % 90-70 = 20, 70-20=50
    %    % 90-69 = 21, 69-21=48
    %    % ...
    %    % 90-60 = 30, 60-30=30
    %    % ...
    %    % 90-59 = 31, 59-31=28
    %    % ...
    %    % 90-56 = 34, 56-34 = 22 VALID!!!
    %    % ...
    %    % 90-44 = 46, 44-46 = -2
    %    %Need 56s and 34s
    %    get_helper(Cs, 56, 34) + get_helper(Cs, 34, 56).
    %
    %get_11s(_) ->
    %    %Range: {70,59},.....,{31,20}
    %    %90 - 70 = 20, 70-20 = 50
    %    %90 - 51 = 39, 51-39=12
    %    %90 - 50 = 40, 50-40=10 SKIPPED! Not valid appearantly.
    %    0.
    %
    %get_0s(Cs) ->
    %    %...
    %    %90-45 = 45, 45-45 = 0
    %    %...
    %    get_helper(Cs, 45, 45).
    %
    %
    
solve() ->
    Cs = eulerlist:get_combinations(10, [0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9]),
    Ans = get_0s(Cs) + get_11s(Cs) + get_22s(Cs) + get_44s(Cs),
    erlang:display(io_lib:format("~.1f", [Ans])),
    Ans.

number_distinct_perms_not_starting_X(L1, X) ->
    %https://math.stackexchange.com/questions/2283641/number-of-distinct-permutations-not-starting-with-object-x
    FM = eulerlist:list_to_freq_map(L1),
    NDP = eulermath:number_distinct_perms(L1),
    NDP - (NDP*dfetch(X, FM,0))/length(L1).

form_complement(L) ->
    %Given L that contains 10 digits, all between 0 and 9, and no more than 2 of any one digit, forms a compliment L2 such that L1++L2 is double pandigital
    FM = eulerlist:list_to_freq_map(L),
    do_form_complement(FM, 0, []).
do_form_complement(_,10,R) -> R;
do_form_complement(FM,I,R) ->
    case dfetch(I, FM, 0) of
        0 -> do_form_complement(FM, I+1, [I|[I|R]]);
        1 -> do_form_complement(FM, I+1, [I|R]);
        2 -> do_form_complement(FM, I+1, R)
    end.

get_helper(Cs, Sum1, Sum2) ->
    %it has been determined that Sum1 - Sum2, or alternatively Sum1[1] -Sum2[1] + Sum1[2] - ...  produces a gap that is divisble by 11
    %1) Get all lists in Cs that sum to Sum1 and Sum2, called S1 and S2
    %2) Find the number of distinct permutations of all elemenets in S1 that do not start with 0,
    %3) Find the number of distinct permutations of all elemenets in S2
    %4) multiple 2 and 3 together as every element of (2) can be interleaved with any element of (3)
    %erlang:display({helper, Sum1, Sum2}),
    %
    %must filter perms here because we are going to reblow it out into all perms
    ValidL1 = eulerlist:filter_permutations([X || X <- Cs, lists:sum(X) ==Sum1]),
    lists:sum([get_helper_pair(X,Sum2) || X <- ValidL1]).
    
get_helper_pair(L,Sum2) ->
    %Given a "half" solution (L1 summing to Sum1),
    %   form it's compliment
    %   see if it sums to L2, 
    %   if so, complete steps 2-4 above
    Complement = form_complement(L),
    case lists:sum(Complement) of
        Sum2 ->
            %the "interleave" cant start with a 0.. the way we set this up, Sum1 cooresponds to L1 coming first in the interleave
            Total1 = number_distinct_perms_not_starting_X(L, 0),
            %this can have a 0, e.g., 10.... is valid
            Total2 = eulermath:number_distinct_perms(Complement),
            Total1*Total2;
        _  -> 0
    end.

get_44s(Cs) -> get_helper(Cs, 67, 23) + get_helper(Cs, 23, 67).
get_22s(Cs) -> get_helper(Cs, 56, 34) + get_helper(Cs, 34, 56).
get_11s(_) -> 0.
get_0s(Cs) -> get_helper(Cs, 45, 45).
