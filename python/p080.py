from decimal import *


def get_sum(x, p=False):
    # we go to 101, but then only sum 100, so we dont get rouding error
    getcontext().prec = 102
    # going to 101 messed up on the int 5; 497 got "cascading rounded" to 50; but we donbt want rounding
    # if some int ended with x9999999 etc mighta been in more trouble
    l = Decimal(x).sqrt()
    if p:
        print((x, l))
    dig = l.as_tuple()[1][:100]
    return sum(dig)


perfect_squares = [1 * 1, 2 * 2, 3 * 3, 4 * 4, 5 * 5, 6 * 6, 7 * 7, 8 * 8, 9 * 9, 10 * 10]

s = 0
for i in range(1, 101):
    if i not in perfect_squares:
        s += get_sum(i)

print(s)

# print(get_sum(5, p=True))
