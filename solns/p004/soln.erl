%A palindromic number reads the same both ways. The largest palindrome made from the product of two
%2-digit numbers is 9009 = 91 × 99.
%
%Find the largest palindrome made from the product of two 3-digit numbers.
%
%13> c(soln).
%{ok,soln}
%14> soln:recursedown(999,999).
%906609

-module(soln).
-export([recursedown/2]).
-import(shared_euler, [digitize/1]).

checkpal(P) ->
    case length(P) > 1 of
        false -> true; %no middle element or just one; either case, palindrome
        true ->
            case lists:nth(1, P) == lists:nth(length(P), P) of %check first == last
                false -> false;
                true ->
                    {Allb1, _} = lists:split(length(P) - 1, P),
                    {_, Middle} = lists:split(1,  Allb1),
                    checkpal(Middle)
            end
    end.

recursedown(I,J) ->
    F = erlang:get({'recursedown', I, J}),
    case is_integer(F) of
        true -> F;
        false  ->
            P = I*J,           
            case checkpal(digitize(P))  of                  
                true -> R = P;                   
                false -> R = erlang:max(recursedown(I-1, J), recursedown(I, J-1))                   
            end,                   
            erlang:put({'recursedown', I, J}, R),
            R
    end.














