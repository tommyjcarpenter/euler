# You are given a unique investment opportunity.

# Starting with £1 of capital, you can choose a fixed proportion, f, of your capital to bet on a fair coin toss repeatedly for 1000 tosses.
#
# Your return is double your bet for heads and you lose your bet for tails.
#
# For example, if f = 1/4, for the first toss you bet £0.25, and if heads comes up you win £0.5 and so then have £1.5. You then bet £0.375 and if the second toss is tails, you have £1.125.
#
# Choosing f to maximize your chances of having at least £1,000,000,000 after 1,000 flips, what is the chance that you become a billionaire?
#
# All computations are assumed to be exact (no rounding), but give your answer rounded to 12 digits behind the decimal point in the form 0.abcdefghijkl.

import random
import numpy

import matplotlib
matplotlib.use('TkAgg')

import matplotlib.pyplot as plt

def simulate(f):
    balance = 1.0
    for i in range(0, 1000):
        bet_amt = balance*f
        flip = random.randint(0,1)
        balance = balance + 2*bet_amt if flip == 0 else balance - bet_amt  # lets call 0 heads

    return 1 if balance >= 1000000000 else 0


fs = []
means = []
for f in numpy.linspace(0.05,0.25, 5):  # the bounds on here were changed by repeadedly playing around...
    print(f)
    fs.append(f)
    means.append(numpy.mean([simulate(f) for x in range(0, 200000)]))

print(fs, means)
plt.plot(fs, means)
plt.xlabel("f")
plt.ylabel("mean")
plt.savefig('myfilename.png')
print(means)
