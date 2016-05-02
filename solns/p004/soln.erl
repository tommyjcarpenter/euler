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
-import(eulermath, [digitize/1, is_palindrome/1]).

recursedown(I,J) ->
    F = erlang:get({'recursedown', I, J}),
    case is_integer(F) of
        true -> F;
        false  ->
            P = I*J,           
            case eulermath:is_palindrome(P) of                  
                true -> R = P;                   
                false -> R = erlang:max(recursedown(I-1, J), recursedown(I, J-1))                   
            end,                   
            erlang:put({'recursedown', I, J}, R),
            R
    end.














