#!/bin/bash
erlc p076.erl ; erl -eval 'p076:timesolve(), init:stop()' -noshell
