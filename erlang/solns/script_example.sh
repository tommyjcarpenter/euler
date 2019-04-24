#! /bin/bash
erlc p017.erl ; erl -eval 'p017:timesolve(), init:stop()' -noshell
