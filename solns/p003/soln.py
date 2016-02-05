"""
The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?
"""

import math

def _isprime(i):
    assert(i >= 0)
    if i < 3:
        return True
    for j in range(2, int(math.sqrt(i))+1):
        if i % j == 0 and j!= i:
            return False
    return True

largest_prime_divisor = -1
c = 2
limit = 600851475143
while c <= limit:
    if limit % c == 0 and _isprime(c): 
        largest_prime_divisor = c
        limit = limit / c #number is multiplier by all its prime divisors
    else:
        c += 1 #not prime, or prime but no divisor

print(largest_prime_divisor)
