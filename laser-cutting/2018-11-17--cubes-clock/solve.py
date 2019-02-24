#!/usr/bin/python3

from itertools import permutations

# Possible solution, known non-optimal:
#      0  1  2  3  4  5  6  7  8  9
TOP = [0, 0, 1, 1, 0, 2, 2, 1, 3, 3]
BOT = [1, 0, 1, 2, 3, 2, 1, 0, 1, 2]

def dist(top, bot):
    pairs = zip(top, bot)
    deltas = [abs(p[0]-p[1]) for p in pairs]
    return deltas

def max_dist(top, bot):
    deltas = dist(top, bot)
    return max(deltas), top, bot, deltas

def print_combination(top, bot, deltas):
    print('  Digit            ', list(range(10)))
    print('  Top face index   ', top)
    print('  Bottom face index', bot)
    md = max(deltas)
    nb = len([d for d in deltas if d==md])
    print('  Face index delta ', deltas, nb, 'x max delta', md)
    print()
    
faces = [0, 1, 2, 3]

combinations = []
# permutate bottom face, and collect deltas to top face
for permutation in permutations(faces):
    d = dict(zip(faces, permutation))
    bot2 = [d[b] for b in BOT]
    m, t, b, d = max_dist(TOP, bot2)
    combinations.append((m, t, b, d))

combinations.sort()
min_max = min([m for m, t, b, d in combinations])
min_combinations = [(m, t, b, d) for m, t, b, d in combinations if m==min_max]

print('Original:')
print_combination(TOP, BOT, dist(TOP, BOT))

print('Bottom face permutations:')
for m, t, b, d in min_combinations:
    print_combination(t, b, d)
