module screw(pitch, h, r, step, bottom_chamfer=false, rounded=false) {
    rstep = max(step/r, 1);
    turns = h/pitch;
    echo("Turns:", turns);

    h2 = h + pitch;
    turns2 = h2/pitch;

    intersection() {

        union() {
            for(a=[0:rstep:turns2*360]) {
                hull() {
                    screw_slice(a, h, r, pitch, turns);
                    screw_slice(a+rstep, h, r, pitch, turns);
                }
            }
            if (bottom_chamfer) {
                for(a=[0:rstep:360]) {
                    hull() {
                        screw_slice(a, 0, r, pitch, turns);
                        screw_slice(a+rstep, 0, r, pitch, turns);
                    }
                }
            }
        }

        cylinder(r=r*2, h=h);

        if (rounded) {
            minkowski() {
                translate([0, 0, pitch])
                cylinder(r=r-pitch/2, h=h-pitch*2);
                sphere(r=pitch);
            }
        }
    }
}

module screw_slice(a, h, r, pitch, turns) {
    d = pitch/sqrt(2);
    translate([0, 0, a/360/turns*h])
    rotate([0, 0, a]) translate([r, 0, 0])
    rotate([90, 0, 0]) rotate([0, 0, 45])
    cube([d, d, ATOM], center=true);
}
