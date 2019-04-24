from __future__ import division #only needed when working in Python 2.x
import sympy as sp

#THis is SLOW. Only after completing the problem (in like 30min!) did I google and find a much faster algorothm: https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Continued_fraction_expansion
#TODO: Try that alg!

PRECISION=5000
with open("digits.txt", "w") as f:
    for i in range(2,10001):
        print(i)
        p=sp.N(sp.sqrt(i), PRECISION)

        n=500
        x=range(n+1)
        a=range(n)
        x[0]=p
        L = []

        for i in xrange(n):
            a[i] = int(x[i])
            denom = (x[i]-a[i])
            if denom == 0:
                break
            else:
                x[i+1]=1/denom
                L.append(str(a[i]))
        f.write(",".join(L[1:]) + "\n")

