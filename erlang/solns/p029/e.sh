#! /bin/bash
erlc p029.erl
erl -noshell -s p029 solve -s init stop
