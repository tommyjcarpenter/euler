-module(p206).
-export([timesolve/0, solve/0]).

%Find the unique positive integer whose square has the form 1_2_3_4_5_6_7_8_9_0,
%where each “_” is a single digit.

timesolve() ->
    code:add_path("/Users/tommy/Development/github/euler"),
    {T,A} = timer:tc(p206, solve, []),
    erlang:display({trunc(T/1000000), A}). % timer reports in millionths of a second

solve() ->
    % so the largest integer of the form is 1929394959697989990
    % the smallest integer of the form is   1020304050607080900
    % the sqrt of 1929394959697989990 = 1,389,026,623.11
    % the sqrt of 1020304050607080900 = 1,010,101,010.1
    % so there are 1,389,026,623-1,010,101,010 = 378,925,613 possible candidates
    %
    % the trick was to find an "O(1)" meaning fast math comp, not string manipulation or anythong,
    % method of determining what digit is in the pth place of N.

    iterate().

%for the bounds here see the comment above
iterate() ->
    iterate(1010101010).
iterate(1389026623) -> problem;
iterate(N) ->
    %X = N+3.16227766017,
    %erlang:display({N, N*N, X, X*X, X*X-N*N}),
    Nsq = N*N,
    case eulermath:pth_place(Nsq, 1) == 0 andalso
         eulermath:pth_place(Nsq, 3) == 9 andalso
         eulermath:pth_place(Nsq, 5) == 8 andalso
         eulermath:pth_place(Nsq, 7) == 7 andalso
         eulermath:pth_place(Nsq, 9) == 6 andalso
         eulermath:pth_place(Nsq, 11) == 5 andalso
         eulermath:pth_place(Nsq, 13) == 4 andalso
         eulermath:pth_place(Nsq, 15) == 3 andalso
         eulermath:pth_place(Nsq, 17) == 2 andalso
         eulermath:pth_place(Nsq, 19) == 1
    of
        true ->
            {N, N*N};
        false ->
            iterate(N+1)
    end.


