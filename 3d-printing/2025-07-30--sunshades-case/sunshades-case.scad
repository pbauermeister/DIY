// Hard protective case for clip-on sunshades of Decathlon,
// model: Eyeglass clip - MH OTG 120 Large - polarized category 3

use <../chamferer.scad>

WIDTH            = 140;
HEIGHT           =  55.75 - 7;
RADIUS           = 160;
RADIUS_KZ        =   0.75;

CHAMFER          =   1.5;
THICKNESS        =   7;

CORNER_RADIUS    = 12;

// Clip hollowing
CLIP_HOLLOWING_W = 30-8;
CLIP_HOLLOWING_H = 15;

$fn = $preview? 40 : 300;

module main() {
    intersection() {
        // Base cylinder
        hull() {
            for (x=[CORNER_RADIUS+5, WIDTH - CORNER_RADIUS-5]) {
                for (z=[CORNER_RADIUS, HEIGHT-CORNER_RADIUS]) {
                    translate([x, 0, z])
                    rotate([90, 0, 0])
                    cylinder(r=CORNER_RADIUS, h=RADIUS, center=true);
                }
            }
        }

        // Spherical front+back limits
        difference() {
            // outer wall
            r1 = RADIUS*.9;
            translate([WIDTH/2, r1, HEIGHT/2])
            scale([1, 1, RADIUS_KZ])
            sphere(r=r1);

            // inner wall
            r2 = RADIUS*1.1;
            translate([WIDTH/2, r2+THICKNESS, HEIGHT/2])
            scale([1, 1, RADIUS_KZ])
            sphere(r=r2);
        }
    }
}

module case() {
    difference() {
        // Outer shell
        chamferer($preview ? CHAMFER : CHAMFER, "sphere", fn=12, shrink=false)
        main();

        // Make hollow
        r = RADIUS * RADIUS_KZ *.9;
        translate([0, r, HEIGHT/2])
        for (a=[0, 4]) {
            rotate([-a, 0, 0])
            translate([0, -r, -HEIGHT/2])
            main();
        }

        // Opening for clip
        y = CLIP_HOLLOWING_W/2+THICKNESS + 2.5;

        // - opening
        translate([WIDTH/2, y, HEIGHT+7-12.5])
        chamferer(2, "octahedron")
        cube([CLIP_HOLLOWING_W, 30, CLIP_HOLLOWING_H], center=true);

        // - chamfer
        translate([WIDTH/2, y, HEIGHT+7-12 + sqrt(2)*CLIP_HOLLOWING_W*.5 - 6])
        intersection() {
            rotate([0, 45, 0])
            cube([CLIP_HOLLOWING_W, 30, CLIP_HOLLOWING_W], center=true);
            cube([CLIP_HOLLOWING_W*2, 100, CLIP_HOLLOWING_W/2], center=true);
        }
    }
}

case();
