#! /usr/bin/env python3
from fractions import Fraction
import math
import sys

# Note: doing this one in Python to use Fraction library.
# If I did this in Erlang most of my time would be spent on figuring out how to keep fractions instead of floats, not worth it..

def digits(n):
    return int(math.log10(n))+1

def _recurse(times, sofar):
    if times==1:
        return 1+Fraction(1,sofar)
    else:
        return _recurse(times-1, 2+Fraction(1,sofar))

def recurse(times):
    if times == 1:
        R =  1+Fraction(1,2)
    else:
        R =  _recurse(times, 2)
    return 1 if digits(R.numerator) > digits(R.denominator) else 0

#my function is tail recursive but python doesnt recogniuze tail recursion which is a fail
#https://stackoverflow.com/questions/13591970/does-python-optimize-tail-recursion
sys.setrecursionlimit(1100)
print(sum([recurse(i) for i in range(1,1001)]))
