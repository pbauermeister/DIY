USB_CABLE_D =   2.65    + .2    + .2;
H           =  30;
WALL        =   0.75            - .1;
WALL2        =  0.3;


$fn = 200;
ATOM = 0.01;

%cylinder(d=USB_CABLE_D, h=H);

module segment(h) {
    difference() {
        dx = USB_CABLE_D/2;
        hull() {
            cylinder(d=USB_CABLE_D+WALL*2, h=h);

            translate([WALL/2, 0, 0])
            cylinder(d=USB_CABLE_D+WALL*2, h=h);

            translate([dx+WALL*1, 0, 0])
            cylinder(d=USB_CABLE_D + WALL*1, h=h);
            
            translate([-USB_CABLE_D/2 - WALL, USB_CABLE_D/2 -WALL/2-.1, 0])
            cube([WALL, WALL, h]);
        }

        hull() {
            cylinder(d=USB_CABLE_D, h=h*3, center=true);

            translate([WALL*.5, 0, 0])
            cylinder(d=USB_CABLE_D, h=h*3, center=true);

            translate([-USB_CABLE_D/2 + WALL*0, USB_CABLE_D/2-WALL-WALL/2, 0])
            cube([WALL, WALL, h*3], center=true);
        }

        translate([dx/2 + WALL*2.5, 0, 0])
        cylinder(d=USB_CABLE_D - WALL, h=h*3, center=true);

        translate([USB_CABLE_D*1.5 + WALL*.5*2, 0, 0])
        cube([USB_CABLE_D*2, USB_CABLE_D*2, h*3], center=true);

        translate([-USB_CABLE_D/2 - WALL+WALL2, USB_CABLE_D/2 + WALL, 0])
        cube([.1, .2, h*3], center=true);
    }

    translate([-USB_CABLE_D/2-WALL/2, USB_CABLE_D/2, 0])
    cube([WALL2, WALL*1 + 5, h]);
}

segment(170);

translate([0, 15, 0])
scale([1, -1, 1])
segment(65);