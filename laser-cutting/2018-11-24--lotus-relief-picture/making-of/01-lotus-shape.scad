PI = 180; // one half turn in degree
ANGULAR_STEP = 1;
K = 10;
function r(a) = (1 + (((abs(cos(a*3)))+(0.25-(abs(cos(a*3+PI/2))))*2)
                     / (2+abs(cos(a*6+PI/2))*8))
                 ) * 0.7;
function fx(a) = cos(a) * r(a) * K;
function fy(a) = sin(a) * r(a) * K;
function points() = [for(a=[0:ANGULAR_STEP:360]) [fx(a), fy(a)]];

module lotus() {
    polygon(points());
}

lotus();