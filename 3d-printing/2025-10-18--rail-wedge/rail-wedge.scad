
ANGLE    =  9;
DIAMETER =  6;
PY       = 20 + DIAMETER/2;
H        = 45;
L        = 45;

$fn = 100;

module wedge() {
    intersection() {
        difference() {
            rotate([0, -90+ANGLE, 0])
            intersection() {
                translate([-H+1, 0, 0])
                cube([H, L, H]);

                rotate([0, -ANGLE, 0])
                translate([0, -L/2, -H/2])
                cube([H, L*2, H*2]);
            }

            translate([-PY, L/2, -H/4])
            cylinder(d=DIAMETER, h=H);
        }

        hull(){
            r = H/2.5;
            translate([r - H, r, 0])
            rotate([0, ANGLE, 0])
            translate([0, 0, -H/4])
            cylinder(r=r, h=H);

            translate([r - H, L-r, 0])
            rotate([0, ANGLE, 0])
            translate([0, 0, -H/4])
            cylinder(r=r, h=H);

            cube([.01, L, 1]);
        }
    }
}


for (i=[0:2])
    for (j=[0:1])
        translate([i*(H+3), j*(L+3), 0])
            wedge();