#!/bin/python3

from itertools import permutations

TOP = [0, 1, 1, 0, 2, 2, 1, 3, 3, 0]
BOT = [0, 1, 2, 3, 2, 1, 0, 1, 0, 1]

def max_dist(top, bot):
    pairs = zip(top, bot)
    deltas = [abs(p[0]-p[1]) for p in pairs]
    print('top   ', top)
    print('bottom', bot)
    print('delta ', deltas, '  max delta', max(deltas))
    return max(deltas)

faces = [0, 1, 2, 3]
for permutation in permutations(faces):
    d = dict(zip(faces, permutation))
    bot2 = [d[b] for b in BOT]
    print()
    max_dist(TOP, bot2)
    #print(bot2, max_dist(TOP, bot2))
