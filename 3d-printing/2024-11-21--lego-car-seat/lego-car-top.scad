use <lego-lib.scad>

UU = lego_u();
HH = lego_h();

PLAY = .1;


///////////////

A = [-6, .9, 0, .5*0, 0, 0, 0, 0, 0];

B = [2, 0, 0, 0, 0, 0, 2, 0, 0];
C = [2, 0, 0, 0, 0, 0, 1, 0, 0];

D = [1, 0, 0, .5, 0, 0, 0, 5, 0];

E = [1, 0, 0, 0, 0, 0, 0, 10, 0];
F = [1, 0, 0, 0, 0, 0, 0, 10, 3];

G = [1, 0, 0, -.75, 0, 0, 0, 0, 0];
H = [1, 0, 0, 0, 0, 0, 0, 11, 0];

I = [1, 0, 0, -.5, 0, 0, 0, 0, 0];
K = [1, 0, 0, .25, 0, 0, 0, 0, 0];
L = [1, 0, 0, 0, 0, 0, 0, 9, 0];
M = [-1, -.5, 0, 0, 0, 0, 0, 0, 0];
N = [0, 0, 0, 0, 0, 0, 0, 11, 0];

O = [1, 0, 0, 0, 0, 0, 0, 2, 0];
P = [2, 0, 0, 0, 1, 0, 3, 0, 0];
Q = [2, 0, 0, 0, 1, 0, 1, 0, 0];
R = [2, 0, 0, 0, 1, 0, 0, 0, 0];

S = [5, 0, 0, 0, 0, 0, 1, 0, 0];
T = [5, 0, 0, 0, 0, 0, 3, 0, 0];
U = [1, 0, 0, 0, 0, 0, 0, 1, 0];

X = [1, 0, 0, 0, 0, 0, 0, 5, 0];
Y = [1, 0, 0, 0, 0, 0, 0, 5, 2];
Z = [1, 0, 0, -.5, 0, 0, 0, 11, 0];

$fn = 90;
ATOM = .01;

MAP = [
    [
        [0,0,0,S,0,E,1,U,U,0,U,1,1,1,Y,0,0],
        [A,B,1,1,O,O,0,0,0,0,0,1,O,1,O,0,0],
        [0,X,1,O,1,0,0,0,1,0,0,0,0,0,1,0,0],
        [0,D,1,O,1,0,0,0,1,0,0,0,0,0,1,0,0],
        [0,X,1,O,1,0,0,0,1,0,0,0,0,0,1,0,0],
        [A,C,1,1,O,O,0,0,0,0,0,1,O,1,O,0,0],
        [0,0,0,T,0,F,1,U,U,0,U,1,1,1,Y,0,0],
    ],
    [
        [0,0,0,0,0,E,P,P,P,P,P,P,P,P,P,0,0],
        [0,X,1,1,1,1,0,G,I,I,1,G,G,G,1,0,0],
        [0,X,1,1,1,1,0,G,I,I,K,0,0,G,1,0,0],
        [0,X,1,1,1,1,0,G,G,G,1,G,G,G,1,0,0],
        [0,X,1,1,1,1,0,G,I,I,1,G,G,G,1,0,0],
        [0,X,1,1,1,1,0,G,I,I,1,G,G,G,1,0,0],
        [0,0,0,0,0,F,Q,Q,Q,Q,Q,Q,Q,Q,Q,0,0],
    ],
    [
        [0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,H,1,0,0,0,0,1,0,0,0,0,0],
        [0,0,0,0,H,1,0,0,0,0,1,0,0,0,0,0],
        [0,0,0,0,H,1,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,H,1,0,0,0,0,1,0,0,0,0,0],
        [0,0,0,0,H,1,0,0,0,0,1,0,0,0,0,0],
        [0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0],
    ],
    [
        [0,0,0,0,0,Z,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,Z,0,0,0,0,P,0,0,0,0,0],
        [0,0,0,0,0,Z,0,0,0,0,Q,0,0,0,0,0],
        [0,0,0,0,0,Z,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,Z,0,0,0,0,P,0,0,0,0,0],
        [0,0,0,0,0,Z,0,0,0,0,Q,0,0,0,0,0],
        [0,0,0,0,0,Z,0,0,0,0,0,0,0,0,0,0],
    ],
];


module car_body() {
    lego_build(MAP);
}

///////////

car_body();
