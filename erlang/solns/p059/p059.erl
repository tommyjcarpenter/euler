-module(p059).
-export([timesolve/0, solve/0]).

% Each character on a computer is assigned a unique code and the preferred standard is ASCII (American Standard Code for Information Interchange). For example, uppercase A = 65, asterisk (*) = 42, and lowercase k = 107.

% A modern encryption method is to take a text file, convert the bytes to ASCII, then XOR each byte with a given value, taken from a secret key. The advantage with the XOR function is that using the same encryption key on the cipher text, restores the plain text; for example, 65 XOR 42 = 107, then 107 XOR 42 = 65.

% For unbreakable encryption, the key is the same length as the plain text message, and the key is made up of random bytes. The user would keep the encrypted message and the encryption key in different locations, and without both "halves", it is impossible to decrypt the message.

% Unfortunately, this method is impractical for most users, so the modified method is to use a password as a key. If the password is shorter than the message, which is likely, the key is repeated cyclically throughout the message. The balance for this method is using a sufficiently long password key for security, but short enough to be memorable.

% Your task has been made easy, as the encryption key consists of three lower case characters. Using cipher.txt (right click and 'Save Link/Target As...'), a file containing the encrypted ASCII codes, and the knowledge that the plain text must contain common English words, decrypt the message and find the sum of the ASCII values in the original text.

timesolve() ->
    erlang:display(timer:tc(p059, solve, [])).

solve() ->
    [L] = eulerfile:file_to_matrix_csv("p059_cipher.txt"),
    %ascii lowercase letters are range 097 to 122
    %26*26*26 = 17,576 so brute force possible.
    cycledecrypts(L).


notgarbage(Plaintext) -> Plaintext >= 32 andalso Plaintext =< 122.

cycledecrypts(L) -> docycledecrypts(L, 97, 97, 97).
docycledecrypts(L, A, B, C) ->
    case A > 122 of
        true -> ok;
        false ->
            case B > 122 of
                true -> docycledecrypts(L, A+1, 97, 97);
                false ->
                    case C > 122 of
                        true -> docycledecrypts(L, A, B+1, 97);
                        false ->
                            D = decrypt(L,A,B,C),
                            _ = case length(D) == length(lists:filter(fun(X) -> notgarbage(X) end, D)) of
                                true ->
                                    erlang:display({A,B,C, lists:sum(D)}),
                                    erlang:display(io:format("~s~n", [D])),
                                    ok;
                                false ->
                                    ok
                            end,
                            docycledecrypts(L, A, B, C+1)
                    end
            end
    end.

decrypt(L,A,B,C) -> decrypt(L, 1, A,B,C, []).
decrypt([], _, _, _, _, SoFar) -> lists:reverse(SoFar);
decrypt([H|T], Index, A, B, C, SoFar) ->
    Plaintext = case Index of
        1 -> H bxor A;
        2 -> H bxor B;
        3 -> H bxor C
    end,
    Next = case Index of
        1 -> 2;
        2 -> 3;
        3 -> 1
    end,
    decrypt(T, Next, A, B, C, [Plaintext | SoFar]).
