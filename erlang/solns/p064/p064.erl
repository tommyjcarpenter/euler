-module(p064).
-export([timesolve/0, solve/0]).

% SNIPPED
% The first ten continued fraction representations of (irrational) square roots are:

%√2=[1;(2)], period=1
%√3=[1;(1,2)], period=2
%√5=[2;(4)], period=1
%√6=[2;(2,4)], period=2
%√7=[2;(1,1,1,4)], period=4
%√8=[2;(1,4)], period=2
%√10=[3;(6)], period=1
%√11=[3;(3,6)], period=2
%√12= [3;(2,6)], period=2
%√13=[3;(1,1,1,1,6)], period=5
%
%Exactly four continued fractions, for N ≤ 13, have an odd period.
%
%How many continued fractions for N ≤ 10000 have an odd period?
%
-define(P, [{precision, 309}]).
timesolve() ->
    erlang:display(timer:tc(p064, solve, [])).


%   HAD TO BAIL ON PURE ERLANG SOLUTION
%   the arbitrary precision library in erlang isn't arbitrary...
%   it bombs around precision 309
%   Filed a bug report: https://github.com/tim/erlang-decimal/issues/8

solve() ->
    L = eulerfile:file_to_matrix_csv("digits.txt"),
    Repeating = lists:map(fun(X) ->
                              {_,Y} = eulerlist:is_repeating(X),
                              Y end,
                          L),
    erlang:display(Repeating),
    CountMe = [X || X <- Repeating, X rem 2 /= 0 ],
    length(CountMe).

    %integer_pow(10, 2000).
    %form_first_N(182*2, 7981),
    %eulerlist:is_repeating([5,3,3,1,7,1,2,6,6,1,2,1,2,3,1,4,2,4,1,1,88,1,2,25,1,6,3,13,2,1,3,5,32,1,8,9,1,15,59,3,2,1,3,1,5,1,3,2,60,3,4,2,59,8,1,11,44,1,1,2,2,8,1,1,14,2,1,3,3,2,1,2,19,2,13,3,1,8,1,1,1,5,1,2,1,1,1,7,1,6,1,7,1,1,1,2,1,5,1,1,1,8,1,3,13,2,19,2,1,2,3,3,1,2,14,1,1,8,2,2,1,1,44,11,1,8,59,2,4,11,1,2,4,1,1,1,1,1,2,1,4,2,1,1,1,1,1,24,1,9,1,1,4,1,1,2,1,1,2,2,4,6,6,2,5,3,3,8,4,1,5,2,1,4,6,1,14,35,1,2,178,2,1,35,14,1,6,4,1,2,5,1,4,8,3,3,5,2,6,6,4,2,2,1,1,2,1,1,4,1,1,9,1,24,1,1,1,1,1,2,4,1,2,1,1,1,1,1,4,2,1,11,4,2,59,8,1,11,44,1,1,2,2,8,1,1,14,2,1,3,3,2,1,2,19,2,13,3,1,8,1,1,1,5,1,2,1,1,1,7,1,6,1,7,1,1,1,2,1,5,1,1,1,8,1,3,13,2,19,2,1,2,3,3,1,2,14,1,1,8,2,2,1,1,44,11,1,8,59,2,4,11,1,2,4,1,1,1,1,1,2,1,4,2,1,1,1,1,1,24,1,9,1,1,4,1,1,2,1,1,2,2,4,6,6,2,5,3,3,8,4,1,5,2,1,4,6,1,14,35,1,2]),
    %decimal:sqrt(7, ?P).

%%see http://web.math.princeton.edu/mathlab/jr02fall/Periodicity/mariusjp.pdf
%%integer_part(R) ->
%    %get the coefficient. similar code to p026 but using list nth 1 here to get the coef
%    {Coefficient, _} = string:to_integer(lists:nth(1, string:tokens(decimal:format(R), "."))),
%    Coefficient.
%form_next(0, _, Coef) -> Coef;
%form_next(N, R, Coef) ->
%    %Get the remainder
%    %erlang:display({R, Coefficient, decimal:subtract(R, Coefficient, [{precision, 200}])}),
%    An = integer_part(R),
%    Denom = decimal:subtract(R, An, ?P),
%    Rem = decimal:divide("1.0", Denom, ?P),
%    %erlang:display({decimal:format(R), decimal:format(An), decimal:format(Denom),  decimal:format(Rem)}),
%    form_next(N-1, Rem, [An | Coef]).
%form_first_N(N, X) ->
%    R = trunc(math:sqrt(X)),
%    case R*R == X of
%        true -> erlang:display("PERFECT SQUARE"), [];
%        false ->
%            [_| T] = form_next(N, decimal:sqrt(X, ?P), []),
%            T
%    end.
%
%get_repeating_first_N(N, X) ->
%    L = form_first_N(N,X),
%    eulerlist:is_repeating(L).
%
