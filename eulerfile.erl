-module(eulerfile).
-export([file_to_matrix_csv/1,
         file_to_matrix_space/1,
         csv_to_list/1,
         csv_of_strings_with_quotes_to_list/1
        ]).

file_to_matrix_space(FileName) -> file_to_matrix(FileName, [<<" ">>]).
file_to_matrix_csv(FileName) -> file_to_matrix(FileName, [<<",">>]).
file_to_matrix(FileName, DelimiPerLine) -> %Delim = [<<",">>] for a csv and [<<" ">>] for space seperated ints
    {ok, D1} = file:read_file(FileName),
    D2 = binary:split(D1, [<<"\n">>], [global]),
    D3 = lists:map(fun(X) -> binary:split(X, DelimiPerLine, [global]) end, D2),
    D4 = lists:filter(fun(X) -> X /= [<<>>] end, D3),
    [lists:map(fun(Y) -> erlang:binary_to_integer(Y) end, X) || X <- D4].


csv_to_list(FileName) ->
    {ok, D1} = file:read_file(FileName),
    %erlang:display(D1),
    binary:split(D1, <<",">>, [global]).

csv_of_strings_with_quotes_to_list(FileName) ->
    %wrapper around csv_to_list that handles "FOO","BAR",... as a file
    L = csv_to_list(FileName),
    %remove the \" \" surrounding
    L2 = lists:map(fun(X) -> binary:replace(X, <<"\"">>,<<"">>) end, L),
    lists:map(fun(X) -> binary:replace(X, <<"\"">>,<<"">>) end, L2).

