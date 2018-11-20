from collections import Counter
import copy

"""
This solution is a greedy algorithm.
It tries to find the most number of passcodes that would be satisfied at each round.
All others get "shifted by 1 to the right"

I cannot gaurantee this is an optimal solution. Maybe choosing an inferior local path leads to a global maxima, not sure
"""

with open("p079_keylog.txt", "r") as f:
    l = f.readlines()


def most_common_inc_ties(lst):
    # this is a play on: https://stackoverflow.com/questions/10797819/finding-the-mode-of-a-list
    # except modified because in the case of ties, I need to try all forks
    data = Counter(lst)
    mc = data.most_common()
    top_count = mc[0][1]
    items_to_send = []
    for c in mc:
        if c[1] == top_count:
            items_to_send.append(c[0])
        else:
            break
    return items_to_send


def extend_lists(target, iteration, lists):
    new_lists = []
    extended = False
    for i in lists:
        if len(i) > iteration and i[iteration] != target:
            i.insert(iteration, target)
            extended = True
        new_lists.append(i)
    return new_lists, extended


def find_solution(iteration, ints):
    while True:

        this_round = []
        for i in ints:
            if len(i) > iteration and i[iteration] != "_":
                this_round.append(i[iteration])

        mc = most_common_inc_ties(this_round)
        if len(mc) == 1:
            ints, extended = extend_lists(mc[0], iteration, ints)
        else:
            if len(mc) == 2:
                lists1, garbage = extend_lists(mc[0], iteration, copy.deepcopy(ints))
                lists2, garbage = extend_lists(mc[1], iteration, copy.deepcopy(ints))
                soln1 = find_solution(iteration + 1, lists1)
                soln2 = find_solution(iteration + 1, lists2)
                return [soln1, soln2]
            else:
                print("THREE WAY TIE NOT IMPLEMENTED")

        if not extended:
            break
        iteration += 1
    return ints


def longest_solution(solutions):
    length = 0
    solution = []
    for i in solutions:
        if len(i) > length:
            length = len(i)
            solution = i
    return length, "".join([str(x) for x in solution])


ints = []
for i in l:
    ints.append([int(x) for x in list(i.strip())])
sols = find_solution(0, ints)

# there are only two

print(longest_solution(sols[0]))
print(longest_solution(sols[1]))

