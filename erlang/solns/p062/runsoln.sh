#!/bin/bash
erlc p062.erl ; erl -pa /Users/tommy/Development/github/euler/erlang/lib/ -eval 'p062:timesolve(), init:stop()' -noshell

