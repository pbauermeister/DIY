PI = 180;
ANGULAR_STEP = 1;
K = 10;

function r1(t) = (1 + (((abs(cos(t*3)))+(0.25-(abs(cos(t*3+PI/2))))*2)
                      / (2+abs(cos(t*6+PI/2))*8))
                 ) * 0.7;

function r2(t) = (2 + (((abs(cos(t*3)))+(0.25-(abs(cos(t*3+PI/2))))*2)
                     / (2+abs(cos(t*6+PI/2))*8))
                 ) *0.6;

function r3(t) = (3 + (((abs(cos(t*6)))+(0.25-(abs(cos(t*6+PI/2))))*2)
                     / (2+abs(cos(t*12+PI/2))*8))
                 ) * 0.6;

function r4(t) = (3 + (((abs(cos(t*6)))+(0.25-(abs(cos(t*6+PI/2))))*2)
                     / (2+abs(cos(t*12+PI/2))*8))
                 ) * 0.8;

function r0(t, n) = n==1 ? r1(t) : n==2 ? r2(t) : n==3 ? r3(t) : r4(t);
function fx(t, n) = cos(t) * r0(t, n) * K;
function fy(t, n) = sin(t) * r0(t, n) * K;
function points(n) = [for(t=[0:ANGULAR_STEP:360]) [fx(t, n), fy(t, n)]];

module lotus(n) {
    linear_extrude(1)
    polygon(points(n));
}

lotus(1);
color("blue")  translate([0, 0, -1]) lotus(2);
color("red")   translate([0, 0, -2]) lotus(3);
color("green") translate([0, 0, -3]) lotus(4);
