// Menger Sponge

// Size of edge of sponge
D = 30;
ATOM = 0.01;

module part(x, y, angle, angle2=0, color="blue") {
    color(color)
    translate([D*x/2*1.01, D*y/2*1.01, 0])
    rotate([-45, angle2, angle])
    rotate([0, -atan(1/sqrt(2)), 0])
    difference() {
        rotate([45, atan(1/sqrt(2)), 0]) {  //menger();
            difference() {
                cube(D, true);
                //cube(D*.9, true);
            }
        }
        translate([0,0,-D]) cube(2*D, center=true);
    }
}


part(1, 1,  -90);
part(1, -1, 180);
part(-1, 1,   0);
part(-1, -1, 90);


part(4, 0, 90);
part(4.01, 0, -90, -90);
