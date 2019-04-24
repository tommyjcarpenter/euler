#!/bin/bash
erlc pxxx.erl ; erl -pa /Users/tommy/Development/github/euler/erlang/lib/ -eval 'pxxx:timesolve(), init:stop()' -noshell

