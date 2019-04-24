%The four adjacent digits in the 1000-digit number that have the greatest product are 9 × 9 × 8 × 9
%= 5832.
%
%Find the thirteen adjacent digits in the 1000-digit number that have the greatest product. What is
%the value of this product?

%My solution is to keep a moving window of size 13, each time dividing by the item that fell off the
%front and multiplying the one added onto the end. 
-module(soln8).
-export([findconsecprod/1]).
-import(shared_euler, [digitize/1, listslice/3]).

findconsecprod(N) ->
    L = 7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450,
    dofindconsecprod(1, N, digitize(L)).

dofindconsecprod(StartIndex, EndIndex, L) ->
    M = lists:foldl(fun(X, Prod) -> X * Prod end, 1, listslice(StartIndex, EndIndex, L)),
    dofindconsecprod(StartIndex+1, EndIndex+1, M, M, L).

dofindconsecprod(StartIndex, EndIndex, LastProd, MaxSoFar, L) -> 
    case length(L) == EndIndex of
        true -> MaxSoFar;
        false ->
             erlang:display(LastProd),
             case LastProd > 0 of
                false ->  P = lists:foldl(fun(X, Prod) -> X * Prod end, 1, listslice(StartIndex, EndIndex, L));
                _ -> P = (LastProd / lists:nth(StartIndex - 1, L))*lists:nth(EndIndex, L)
            end,
            erlang:display(P),
            erlang:display(listslice(StartIndex, EndIndex, L)),
            case P > MaxSoFar of
                true -> dofindconsecprod(StartIndex+1, EndIndex+1, P, P, L);
                false -> dofindconsecprod(StartIndex+1, EndIndex+1, P, MaxSoFar, L)
            end
    end.
    

