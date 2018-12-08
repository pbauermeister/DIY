PI = 180;
ANGULAR_STEP = 1;
K = 10;

function r(t) = (1 + (((abs(cos(t*3)))+(0.25-(abs(cos(t*3+PI/2))))*2)
                     / (2+abs(cos(t*6+PI/2))*8))
                 ) * 0.7;

function fx(t) = cos(t) * r(t) * K;
function fy(t) = sin(t) * r(t) * K;
function points() = [for(t=[0:ANGULAR_STEP:360]) [fx(t), fy(t)]];

module lotus() {
    polygon(points());
}

lotus();
