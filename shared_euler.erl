-module(shared_euler).
-export([digitize/1, listslice/3, isprime/1, perms/1, alphabetnum/1, seive/1]).

digitize(N) when N < 10 -> [N]; %stolen from http://stackoverflow.com/questions/32670978/problems-in-printing-each-digit-of-a-number-in-erlang
digitize(N) -> digitize(N div 10)++[N rem 10].

%stolen from the erlang book
perms([]) -> [[]];
perms(L)  -> [[H|T] || H <- L, T <- perms(L--[H])].

listslice(StartIndex, EndIndex, L) ->
    {ToE, _} = lists:split(EndIndex, L),
    {_, M} = lists:split(StartIndex-1, ToE),
    M.

alphabetnum(Char) ->
    case Char of
        <<"A">> -> 1;<<"B">> -> 2;<<"C">> -> 3;<<"D">> -> 4;<<"E">> -> 5;<<"F">> -> 6;<<"G">> -> 7;<<"H">> -> 8;<<"I">> -> 9;<<"J">> -> 10;<<"K">> -> 11;<<"L">> -> 12;<<"M">> -> 13;<<"N">> -> 14;<<"O">> -> 15;<<"P">> -> 16;<<"Q">> -> 17;<<"R">> -> 18;<<"S">> -> 19;<<"T">> -> 20;<<"U">> -> 21;<<"V">> -> 22; <<"W">> -> 23; <<"X">> -> 24; <<"Y">> -> 25;<<"Z">> -> 26
   end.

%determines if a number is prime
isprime(I) ->
    case I < 2  of 
        true -> false;
        false ->
            case I < 3 of 
                true -> true;
                false -> 
                    case I rem 2 of 
                        0 -> false; %optimization; before entering recursive loop, check if even
                        _ -> 
                            doisprime(I, erlang:trunc(math:sqrt(I)))
                    end
            end
    end.
doisprime(I, 1) -> 
    case I of 
        1 -> false;
        _ -> true
    end;
doisprime(I, J) when J > 1->
    case I rem J of 
        0 -> false;
        _ -> doisprime(I, J-1)
    end.


%Let us first describe the original “by hand” sieve algorithm as practiced by Eratosthenes.
%We start with a table of numbers (e.g., 2, 3, 4, 5, . . . ) and progressively
%cross off numbers in the table until the only numbers left are primes. Specifically,
%we begin with the first number, p, in the table, and
%1. Declare p to be prime, and cross off all the multiples of that number in the
%table, starting from p^2;
%2. Find the next number in the table after p that is not yet crossed off and set
%p to that number; and then repeat from step 1.
%
seive(N) ->
    L = lists:seq(1,N),
    {Megass, Ss, Micros} = erlang:timestamp(),
    S = doseive(L, 2),
    {Megase, Se, Microe} = erlang:timestamp(),
    {Megase-Megass, Se-Ss, Microe-Micros, S}.

doseive(L, Index) ->
    Isq = Index*Index-1,
    if Isq > length(L) -> [X || X <- L, X /= -1];
    true -> 
        case  lists:nth(Index, L) == -1 of
        true -> doseive(L, Index + 1);
        false -> 
            {L1, L2} = lists:split(Isq, L),
             L3 = lists:map(fun(X) -> if X == -1 orelse (X rem Index == 0 andalso X /= Index) -> -1; true  -> X  end end , L2),
             doseive(lists:append(L1, L3), Index + 1)
    end end.
