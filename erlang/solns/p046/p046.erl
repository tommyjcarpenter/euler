-module(p046).
-export([timesolve/0, solve/0]).

%It was proposed by Christian Goldbach that every odd composite number can be written as the sum of a prime and twice a square.
%
%9 = 7 + 2×12
%15 = 7 + 2×22
%21 = 3 + 2×32
%25 = 7 + 2×32
%27 = 19 + 2×22
%33 = 31 + 2×12
%
%It turns out that the conjecture was false.
%
%What is the smallest odd composite that cannot be written as the sum of a prime and twice a square?

timesolve() -> 
    erlang:display(timer:tc(p046, solve, [])).

solve() ->
    %guessing these bounds to start
    SD = eulermath:seive(10000),    
    Squares = form_twice_squares(1000),
    recurse(33, SD, Squares).

recurse(N, Seive, Squares) ->
    %would be more efficient to have a dict of the first N primes...
    case lists:member(N, Seive) of 
        true -> recurse(N+2, Seive, Squares); %not composite
        false -> 
            case test(N, 1, Seive, 1, Squares) of 
                true -> recurse(N+2, Seive, Squares);
                false -> N
            end
    end.

test(N, SeiveIndex, Seive, TwiceSquaresIndex, Squares) ->
    case SeiveIndex > length(Seive) of 
        true -> false;
        false -> 
            ThePrime = lists:nth(SeiveIndex, Seive),
            case ThePrime > N of 
                true -> false; %the prime is already bigger than N, stop
                false ->
                    TheSquare = dict:fetch(TwiceSquaresIndex, Squares),
                    case ThePrime + TheSquare > N of 
                        true -> test(N, SeiveIndex+1, Seive, 1, Squares); %reset squares to 1, move onto next prime
                        false ->
                            case ThePrime + TheSquare == N of 
                                true -> true;
                                false -> test(N, SeiveIndex, Seive, TwiceSquaresIndex+1, Squares)
                            end
                    end
            end
    end.

form_twice_squares(N) ->
    form_twice_squares(1, N+1, dict:new()).
form_twice_squares(NStop, NStop, D) -> D;
form_twice_squares(N, NStop, D) ->
    form_twice_squares(N+1, NStop,  dict:store(N, 2*N*N, D)).

