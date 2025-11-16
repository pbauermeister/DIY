LENGTH    = 175;
WIDTH     = 18;

SINK      =  1.6              +1;
THICKNESS =  SINK + 2;

WHEEL_D   = 16;
SLANT_L   = 16;
SHIFT     = 4;
N         = 4;

ATOM = 0.01;
$fn  = 200;

module profile(th) {
    difference() {
        hull() {
            // front
            translate([SLANT_L*.75+SHIFT, 0, 0])
            cube([LENGTH-SLANT_L*1.5, ATOM, th]);

            // back
            translate([0, -THICKNESS, 0])
            cube([LENGTH, ATOM, th]);

            // mid
            translate([0, -THICKNESS+.5, 0])
            cube([LENGTH, ATOM, th]);
        }
        ratchets();
    }
}

module ratchets() {
    spacing = (LENGTH - SLANT_L*2) / (N-1);
    for (i=[0:N-1])
        translate([SLANT_L + SHIFT + i*spacing, WHEEL_D/2 - SINK, 0])
        cylinder(d=WHEEL_D, h=WIDTH*6, center=true);

    r = spacing*3;
    for (i=[0:N-2])
        translate([SLANT_L + SHIFT + spacing/2 + i*spacing, r-1, 0])
        cylinder(r=r, h=WIDTH*6, center=true);
}

module rail() {
    difference() {
        profile(WIDTH);

        // screws
        d = WHEEL_D*.7;
        for(x=[SLANT_L+SHIFT + d, LENGTH-SLANT_L+SHIFT - d]) {
            translate([x, 0, WIDTH/2])
            rotate([-90, 0, 0]) {
                screw_d = 3.2;
                cylinder(d=screw_d, h=20, center=true, $fn=20);

                translate([0, 0, -THICKNESS + 1.5])
                cylinder(d=screw_d*2, h=20, $fn=20);
            }
        }
    }
}

rail();