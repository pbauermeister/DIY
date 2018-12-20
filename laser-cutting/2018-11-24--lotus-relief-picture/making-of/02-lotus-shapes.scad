PI = 180; // one half turn in degree
ANGULAR_STEP = 1;
K = 10;

function r1(a) = (1 + (((abs(cos(a*3)))+(0.25-(abs(cos(a*3+PI/2))))*2)
                      / (2+abs(cos(a*6+PI/2))*8))
                 ) * 0.7;

function r2(a) = (2 + (((abs(cos(a*3)))+(0.25-(abs(cos(a*3+PI/2))))*2)
                     / (2+abs(cos(a*6+PI/2))*8))
                 ) *0.6;

function r3(a) = (3 + (((abs(cos(a*6)))+(0.25-(abs(cos(a*6+PI/2))))*2)
                     / (2+abs(cos(a*12+PI/2))*8))
                 ) * 0.6;

function r4(a) = (3 + (((abs(cos(a*6)))+(0.25-(abs(cos(a*6+PI/2))))*2)
                     / (2+abs(cos(a*12+PI/2))*8))
                 ) * 0.8;

function r0(a, n) = n==1 ? r1(a) : n==2 ? r2(a) : n==3 ? r3(a) : r4(a);
function fx(a, n) = cos(a) * r0(a, n) * K;
function fy(a, n) = sin(a) * r0(a, n) * K;
function points(n) = [for(a=[0:ANGULAR_STEP:360]) [fx(a, n), fy(a, n)]];

module lotus(n) {
    linear_extrude(1)
    polygon(points(n));
}

lotus(1);
color("blue")  translate([0, 0, -1]) lotus(2);
color("red")   translate([0, 0, -2]) lotus(3);
color("green") translate([0, 0, -3]) lotus(4);
