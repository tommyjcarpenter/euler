-module(eulerutil).

-export([
         concat/1
        ]).

%http://stackoverflow.com/questions/39757020/erlang-drying-up-stringbinary-concatenation
%NOTE! Does not work or bomb when an element in the list is an atom. Must be a string or binary. Maybe add a check for this
to_string(Value) when is_binary(Value) -> binary_to_list(Value);
to_string(Value) -> Value.
concat(List) ->
  lists:flatten(lists:map(fun to_string/1, List)).
