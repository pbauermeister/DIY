use <lego-lib.scad>

UU = lego_u();
HH = lego_h();

PLAY = .1;

_ = [1, 0, 0, 0, 0, 0, 0, 0, 0];
_A = [2, 0, 0, 0, 0, 0, 2, 0, 0];
_B = [2, 0, 0, 0, 0, 0, 1, 0, 0];
_C = [2, 0, 0, 0, 1, 0, 2, 0, 0];
_D = [2, 0, 0, 0, 1, 0, 0, 0, 0];
_E = [3, 0, 0, 0, 0, 0, 2, 0, 0];
_F = [3, 0, 0, 0, 0, 0, 1, 0, 0];
_G = [2, 0, 0, 0, 1, 0, 3, 0, 0];
_H = [2, 0, 0, 0, 1, 0, 1, 0, 0];
_I = [3, 0, 0, 0, 0, 0, 3, 0, 0];
_J = [3, 0, 0, 0, 0, 0, 0, 0, 0];
_K = [2, 0, 0, 0, 0, 0, 3, 0, 0];
_L = [2, 0, 0, 0, 0, 0, 0, 0, 0];

_O = [1, 0, 0, .5, 0, 0, 0, 7, 0];
_Q = [1, 0, 0, 0, 0, 0, 0, 1, 0];
_R = [1, 0, 0, 0, 0, 0, 0, 5, 0];
_S = [2, 0, .1, 0, 1, 0, 3, 2, 0];
_T = [2, 0, .1, 0, 1, 0, 1, 2, 0];
_U = [1, 0, 0, 0, 0, 0, 0, 2, 0];
_V = [1, 0, 0, .1, 0, 0, 0, 0, 0];
_X = [-6, .9, 0, .5*0, 0, 0, 0, 0, 0];
_Y = [1, 0, 0, 0, 0, 0, 0, 5, 2];
_Z = [1, 0, 0, .5, 0, 0, 0, 0, 0];

_P = [1, .5, 0, 0, 0, 0, 0, 0, 0];

_N = [2, 0, .6, 0, 1, 0, 3, 0, 0];
_W = [2, 0, .6, 0, 1, 0, 1, 0, 0];

_M  = [1, .5, 0, -.5, 0, 0, 0, 7, 0];
_ZZ = [1, 0, 0, -.5, 0, 0, 0, 7, 0];
_Z0 = [-1, .5, 0, -.8, 0, 0, 0, 0, 0];
_ZY = [1, 0, 0, -.5, 0, 0, 0, 8, 0];

_CC = [0, 0, 0, 0, 0, 0, 0, 2, 0];
_CD = [1, 0, 0, .5, 0, 0, 0, 2, 0];
_CE = [1, 0, 0, 0, 0, 0, 0, 8, 0];

_CF = [1, .6, 0, .5, 0, 0, 1, 0, 0];
_CG = [1, -.6, 0, .5, 0, 0, 1, 0, 0];


_B0 = [5, 0, 0, -PLAY, 0, 0, 1, 2, 0];
_B1 = [1, 0, 0, -PLAY, 0, 0, 0, 0, 0];
_B2 = [1, 0, 0, -PLAY, 0, 0, 0, 2, 0];
_B3 = [5, 0, 0, -PLAY, 0, 0, 3, 2, 0];

_A0 = [5, 0, 0, -PLAY, 0, 0, 3, 4, 0];
_A1 = [5, 0, 0, -PLAY, 0, 0, 1, 6, 3];
_A2 = [1, 0, 0, -PLAY, 0, 0, 0, 6, 1];
_A3 = [5, 0, 0, -PLAY, 0, 0, 0, 0, 0];
_A4 = [5, 0, 0, -PLAY, 0, 0, 2, 0, 0];

_D0 = [0, 0, 0, 0, 0, 0, 0, 8, 0];

///////////////

A = [1, 0, 0, 0, 0, 0, 0, 1, 0];
B = [1, 0, 0, 0, 0, 0, 0, 2, 0];
C = [1, .5, 0, 0, 0, 0, 0, 0, 0];
D = [1, -.5, 0, -.5, 0, 0, 0, 0, 0];
E = [1, -.5, 0, 0, 0, 0, 0, 0, 0];

F = [1, 0, 0, 0, 0, 0, 0, 10, 0];
G = [1, 0, 0, 0, 0, 0, 0, 10, 1];
H = [1, 0, 0, 0, 0, 0, 0, 10, 2];
I = [1, 0, 0, 0, 0, 0, 0, 10, 3];
J = [0, 0, 0, 0, 0, 0, 0, 11, 0];

K = [1, 0, 0, 0, 0, 0, 0, 5, 2];

L = [2, 0, 0, 0, 0, 0, 2, 0, 0];
M = [2, 0, 0, 0, 0, 0, 1, 0, 0];

O = [1, 0, 0, -.5, 0, 0, 0, 8, 0];
P = [1, 0, 0, 0, 0, 0, 0, 8, 0];

R = [-6, .9, 0, .5*0, 0, 0, 0, 0, 0];
S = [1, 0, 0, 0, 0, 0, 0, 5, 0];

Z = [1, 0, 0, -.5, 0, 0, 0, 0, 0];
Y = [-1, .5, 0, -.5, 0, 0, 0, 9, 0];
X = [1, 0, 0, 0, 0, 0, 0, 9, 0];

$fn = 90;
ATOM = .01;

MAP = [
    [
        [0,L,0,0,0,0,0,0,0,0,0,0,0,0,0,C,D],
        [R,1,0,0,0,0,0,0,0,1,1,1,1,1,1,K,D],
        [0,S,0,0,0,0,0,1,1,Z,0,0,Z,Z,0,K,D],
        [0,S,J,0,0,0,0,0,0,Z,0,0,Z,Z,0,K,D],
        [0,S,0,0,0,0,0,1,1,Z,0,0,Z,Z,0,K,D],
        [R,1,0,0,0,0,0,0,0,1,1,1,1,1,1,K,D],
        [0,M,0,0,0,0,0,0,0,0,0,0,0,0,0,C,D],
    ],
    [
        [0,L,0,0,0,0,0,0,0,0,0,0,0,0,0,C],
        [0,1,0,0,0,0,0,0,0,1,1,1,A,1,1,K],
        [0,1,0,0,0,0,0,1,1,0,Z,X,0,0,Z,K],
        [0,1,1,J,0,0,0,P,1,0,O,X,0,0,O,K],
        [0,1,0,0,0,0,0,1,1,0,Z,X,0,0,Z,K],
        [0,1,0,0,0,0,0,0,0,1,1,1,A,1,1,K],
        [0,M,0,0,0,0,0,0,0,0,0,0,0,0,0,C],
    ],
    [
        [0,L,0,0,0,0,0,0,0,0,0,0,0,0,0,C],
        [0,1,0,0,0,F,B,G,F,1,1,1,1,1,1,1],
        [0,1,G,0,F,1,1,1,1,0,0,C,E,0,0,1],
        [0,1,1,1,1,1,B,P,1,0,0,C,E,0,0,1],
        [0,1,H,0,I,1,1,1,1,0,0,C,E,0,0,1],
        [0,1,0,0,0,I,B,H,I,1,1,1,1,1,1,1],
        [0,M,0,0,0,0,0,0,0,0,0,0,0,0,0,C],
    ],
    [
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,F,B,G,0,0,0,0,0,0,0,0],
        [0,0,G,0,F,1,1,1,1,0,0,C,E,0,0,1],
        [0,0,1,1,1,1,0,1,1,0,0,C,E,0,0,1],
        [0,0,H,0,I,1,1,1,1,0,0,C,E,0,0,1],
        [0,0,0,0,0,I,B,H,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    ],
    [
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,C,E,0,0,1],
        [0,0,0,0,0,0,0,0,0,0,0,C,E,0,0,1],
        [0,0,0,0,0,0,0,0,0,0,0,C,E,0,0,1],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    ],
];

MAP2 = [
    [
        [0],
    ],
    [
        [0],
        [0,0,0,0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,0,0,0,1,1],
    ],
    [
        [0,0,0,0,_CC],
        [0,0,0,0,0,0,0,0,0,_Z0,0],
        [0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,_Z0,0],
        [0,0,0,0,_CC],        
    ],
];


MAP3 = [
    [
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,_B0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,_B1, 0, _A1],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,_B2, 0, _A2],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,_B1, 0, _A0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,_B3],
    ],
];

if (1) {
    arr = [
        X,Y,0,
        _CC, _Q, _U, _A, _B, _C, _D, _E, _F, _G, _H, _I, _J, _K, _L, _Q, _R, 
        _S, _T,
        _U, 
        _V, _W,
        _X, _Y, _Z];
    for (i=[0:len(arr)-1]) {
        %lego_block(arr[i], i, 30, 0);
    }
}


module front_shaving() {
    dh = HH*.3;
    translate([UU, 0, HH*2 +dh])
    rotate([0, -14.5, 0])
    translate([-UU, -UU, 0])
    cube([10*UU, 9*UU, 5*HH]);

    translate([UU, 0, HH*1 +dh])
    rotate([0, -45, 0])
    translate([-UU, -UU, 0])
    cube([10*UU, 9*UU, 5*HH]);

    translate([UU, 0, HH*1.3 +dh])
    rotate([0, -26, 0])
    translate([-UU, -UU, 0])
    cube([10*UU, 9*UU, 5*HH]);
}

module envelope() {
    translate([UU*8.5, UU*8, -HH*8.25])
    rotate([90, 0, 0])
    cylinder(r=UU*12, h=UU*9, $fn=360);

    translate([UU*10, -UU, -HH*2])
    cube([UU*30, UU*9, HH*6]);

    hull() {
        translate([UU*10, UU*3, HH*3.98])
        rotate([0, 90, 0])
        cylinder(d=UU*2, h=UU*30, $fn=300);

        translate([UU*10, UU*4, HH*3.98])
        rotate([0, 90, 0])
        cylinder(d=UU*2, h=UU*30, $fn=300);
    }
}

module car_body() {
    intersection() {
        lego_build(MAP);
        //%
        envelope();
    }
}

///////////

car_body();

//lego_build(MAP3);