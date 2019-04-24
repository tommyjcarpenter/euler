-module(p019).
-export([timesolve/0, solve/0]).

%You are given the following information, but you may prefer to do some research for yourself.
%
%1 Jan 1900 was a Monday.
%Thirty days has September,
%April, June and November.
%All the rest have thirty-one,
%Saving February alone,
%Which has twenty-eight, rain or shine.
%And on leap years, twenty-nine.
%A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.
%How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?

timesolve() -> 
    erlang:display(timer:tc(p019, solve, [])).

solve() ->
    iterate(2, 1, 1, 1900, 0).

leap_year(Y) ->
    case Y rem 4 == 0 of 
        false -> false;
        true ->
            case Y rem 100 == 0 of 
                false -> true;
                true -> Y rem 400 == 0
            end
    end.

thirty_day(M) ->
    M == 4 orelse M == 6 orelse M == 9 orelse M == 11.
thirty_one_day(M) ->
    M == 1 orelse M == 3 orelse M == 5 orelse M == 7 orelse M == 8 orelse M == 10 orelse M == 12.

%Sunday = 1 ... Saturday = 7 as on a calendar
iterate(_, 1, 1, 2001, Count) -> Count;
iterate(DOW, D, M, Y, Count) ->
    erlang:display({DOW, D, M, Y, Count}),
    NewCount = case DOW == 1 andalso D == 1 andalso Y >= 1901 of
                   true -> Count +1;
                   false -> Count
                end,

    NewYear = case M == 12 andalso D == 31 of
                 true -> Y + 1;
                 false -> Y
              end,

    {NewMonth, NewDay} = case 
                   M == 2 andalso D == 28 andalso not leap_year(Y) orelse
                   M == 2 andalso D == 29 orelse 
                   thirty_day(M) andalso D == 30 orelse
                   thirty_one_day(M) andalso D == 31 
               of 
                   true -> %cases where M increasses, day goes to 1
                       case M == 12 of 
                           true -> {1, 1}; 
                           false -> {M + 1, 1}
                       end;
                   false -> {M, D+1}
               end,
    
    NewDOW = case DOW == 7 of 
                 true -> 1;
                 false -> DOW+1
             end,

    iterate(NewDOW, NewDay, NewMonth, NewYear, NewCount).




