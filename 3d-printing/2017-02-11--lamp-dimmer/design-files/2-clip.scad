
K1 = 54.1 / 54;
K2 = 54.2 / 54;
//K3 = 54.3 / 54;
K3 = 54.8 / 54;

ATOM = 0.001;

SHIFT_X = 2.2;
N = 50;
HEIGHT = 10.2;

TOLERANCE = 0.15*2;

////////////////////////////////////////////////////////////////////////////////
// Helpers

module my_scale(k) {
    scale([k, k, 1])   
    translate([-30, -30, 0])
    children();
}

module layer(fname, thickness, altitude) {
    translate([0, 0, altitude])
    linear_extrude(height=thickness+ATOM)
    scale([10, 10, 1])
    import(fname);
}

////////////////////////////////////////////////////////////////////////////////
// Clip

module clip_milling(width) {
    // column
    translate([SHIFT_X,0,HEIGHT/2 +1])
    cube([width, 60, HEIGHT], true);

    // ratchet
    for (i = [0:N]) {
        translate([SHIFT_X, 0, HEIGHT/2 +1 + i/10/2]) cube([width-i/10, 60, HEIGHT], true);
    }
    translate([SHIFT_X, 0, HEIGHT/2 +1 + HEIGHT]) cube([width-N/10, 60, HEIGHT], true);
}

module clip2(width) {
    difference() {
        union() {
            // BASE
            my_scale(1) layer("2a1-base.dxf", 1, 0);
            my_scale(1) layer("2a2-columns.dxf", 14.2, 0);
        }
        clip_milling(width);
        my_scale(1) layer("2a3-holes.dxf", 4, HEIGHT+1);
    }
}

module clip2_final(width, marked) {
    intersection(){
        clip2(width);
        scale([1,1,100]) cylinder(r=35, true);
    }
}

module clip2_final_smaller() {
    difference() {
        clip2_final(49.4 -1);
        translate([7.8, -24.2, 0.5]) cylinder(r=1, $fn=16);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Lock

module lock_milling(width) {
    difference() {
        for (i = [0:N*10]) {
            translate([SHIFT_X, 0, i/10/2 - 1/10/2]) {
                translate([ width/2+10 - i/10/2/2 - TOLERANCE, 0, 0]) cube([20, 60, i/10/2], true);
                translate([-width/2-10 + i/10/2/2 + TOLERANCE, 0, 0]) cube([20, 60, i/10/2], true);
            }
        }
        // preserve border edge
        translate([-20, 0, 0]) cube([20, 19, 10], true);
    }
}

module lock(width, marked) {
    cylinder_thickness = 3;
    difference() 
    {
        union() {
            my_scale(1) layer("2a1-base.dxf", 1.4, 0);
            my_scale(1) layer("2a6-cylinders.dxf", cylinder_thickness, 0);
        }
        lock_milling(width);
        if (marked)
            translate([7.8, -24.2, cylinder_thickness-.9]) 
                cylinder(r=1, $fn=16);
    }
    
    my_scale(1) layer("2a4-shafts.dxf", marked ? 0.8 : 0.8, 0);
    my_scale(1) layer("2a5-shafts.dxf", marked ? 0.8 : 1.2, 0);
}

module lock_final(width, marked) {
    intersection(){
        lock(width, marked);
        scale([1,1,100]) cylinder(r=35, true);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Scene

translate([60, 0, 0])  clip2_final(49.4, false);
translate([60, 60, 0]) clip2_final_smaller();

translate([0, 0, 0])   lock_final(49.4, false);
translate([0, 60, 0])  lock_final(49.4 -1, true);
