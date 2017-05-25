#!/bin/bash
erlc eulerlist.erl
erlc eulerlist_tests.erl
erl -noshell -pa ebin -eval "eunit:test(eulerlist_tests)" -s init stop
