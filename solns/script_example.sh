#! /bin/bash
erlc p037.erl
erl -noshell -s p037 main -s init stop
