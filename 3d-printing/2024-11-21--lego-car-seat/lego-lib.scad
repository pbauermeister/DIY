
UU = 39.8 / 5;
HH = 23.4 / 3;

ATOM = .01;

function lego_h() = HH;
function lego_u() = UU;

module lego_op(args) {
    base0 = args[0];
    dx = args[1];
    dy = args[2];
    dz = args[3];
    rx = args[4];
    ry = args[5];
    rz = args[6];
    hole = args[7];
    rhz = args[8];

    base = abs(base0);

    difference() {
        
        // basic form
        if (base!=0)
        scale([UU, UU, HH])

        translate([.5, .5, .5])
        intersection() {
            if (base0>=0)
                cube([1, 1, 1], center=true);

            // Intersects
            
            rotate([rx*90, ry*90, rz*90]) {
                if (base==0) {
                }
                else if (base==1) {
                    // cube
                    translate([dx, dy, dz])
                    cube([1, 1, 1], center=true);
                }
                else if (base==2) {
                    // quarter cylinder
                    intersection() {
                        translate([dx, dy, dz])
                        cube([1, 1, 1], center=true);
                        translate([-.5, -.5, 0])
                        cylinder(r=1, h=1, center=true);
                    }
                }
                else if (base==3) {
                    // eighth sphere
                    intersection() {
                        translate([dx, dy, dz])
                        cube([1, 1, 1], center=true);
                        translate([-.5, -.5, -.5])
                        sphere(r=1);
                    }
                }
                else if (base==4) {
                    // 1 corner rounded
                    intersection() {
                        translate([dx, dy, dz])
                        cube([1, 1, 1], center=true);
                        
                        union() {
                            cylinder(d=1, h=1, center=true);
                            translate([.5, 0, 0])
                            cube([1, 1, 1], center=true);
                            translate([0, .5, 0])
                            cube([1, 1, 1], center=true);
                        }
                    }
                }
                else if (base==5) {
                    // 2 corner rounded
                    intersection() {
                        translate([dx, dy, dz])
                        cube([1, 1, 1], center=true);
                        
                        union() {
                            cylinder(d=1, h=1, center=true);
                            translate([.5, 0, 0])
                            cube([1, 1, 1], center=true);
                        }
                    }
                }
                else if (base==6) {
                    // cylinder
                    d = 1*.8;
                    translate([dx, dy, dz])
                    rotate([0, 90, 0])
                    cylinder(d=d, h=1, center=true);
                }
            }
        }

        // Removals

        translate([UU/2, UU/2, 0])
        rotate([0, 0, rhz*90])
        translate([-UU/2, -UU/2, 0]) {
            // x/y hole
            if (hole==1) {
                h = 1.2;
                d1 = 5.3;
                d2 = 6.5;

                translate([UU/2, UU/2, HH/2])
                rotate([90, 0, 0])
                cylinder(d=d1, h=HH, center=true);

                translate([UU/2, UU+ATOM, HH/2])
                rotate([90, 0, 0])
                cylinder(d1=d2, d2=d1, h=h);

                translate([UU/2, h-ATOM, HH/2])
                rotate([90, 0, 0])
                cylinder(d2=d2, d1=d1, h=h);
            }
            // z hole
            if (hole==2) {
                h = 1.2;
                d1 = 5.1;
                d2 = 6.3;
                translate([UU/2, UU/2, HH/2])
                cylinder(d=d1, h=HH, center=true);

                translate([UU/2, UU/2, -ATOM])
                cylinder(d1=d2, d2=d1, h=h);

                translate([UU/2, UU/2, HH-h+ATOM])
                cylinder(d2=d2, d1=d1, h=h);
            }
            // crosses
            xl = 4.2 +.15 +.12;
            xw = 1.7 +.15 +.12;
            xo = .15;
            // x/y cross
            if (hole==3) {
                translate([UU/2-ATOM, UU/2, HH/2]) {
                    cube([UU+ATOM*3, xl+xo, xw+xo], center=true);
                    cube([UU+ATOM*3, xw+xo, xl+xo], center=true);
                }            
            }
            // z cross
            if (hole==4) {
                translate([UU/2, UU/2, HH/2-ATOM]) {
                    cube([xl, xw, HH+ATOM*3], center=true);
                    cube([xw, xl, HH+ATOM*3], center=true);
                }            
            }
            // grill
            if (hole==5) {
                intersection() {
                    for (h=[.25, .75]) {
                        translate([UU*.1, -UU/2, HH*h])
                        rotate([0, 180+45, 0])
                        cube([UU, UU*2, UU]);
                    }
                    translate([-ATOM, -ATOM, 0])
                    cube([UU, UU+ATOM*2, HH]);
                }
                
            }
            // z long hole
            if (hole==6) {
                intersection() {
                    union() {
                        h = 1.2;
                        d1 = 5.1;
                        d2 = 6.3;
                        
                        hull() for(x=[0, -UU]) translate([x, 0, 0])
                        translate([UU/2, UU/2, HH/2])
                        cylinder(d=d1, h=HH*2, center=true);

                        hull() for(x=[0, -UU]) translate([x, 0, 0])
                        translate([UU/2, UU/2, -ATOM])
                        cylinder(d1=d2, d2=d1, h=h);

                        hull() for(x=[0, -UU]) translate([x, 0, 0])
                        translate([UU/2, UU/2, HH-h+ATOM])
                        cylinder(d2=d2, d1=d1, h=h);
                    }
                    translate([-ATOM, 0, -ATOM])
                    cube([UU+ATOM, UU, HH+ATOM*2]);
                }
            }
            // top grind
            if (hole==7) {
                intersection() {
                    translate([0, 0, HH*.8])
                    cylinder(r=UU*2, h=HH);
                    
                    translate([-ATOM, -ATOM, 0])
                    cube([UU+ATOM*2, UU+ATOM*2, HH+ATOM]);
                }                    
            }
            // z tiny hole
            if (hole==8) {
                intersection() {
                    d = 3;
                    translate([UU/2, UU/2, HH/2-ATOM])
                    cylinder(d=d, h=HH+ATOM*3, center=true);

                    translate([-ATOM, -ATOM, -ATOM])
                    cube([UU+ATOM*2, UU+ATOM*2, HH+ATOM*2]);
                }
            }
        }
    }
}

module lego_block(t, x, y, z) {
    if (t && t!=[]) {
        translate([x*UU, y*UU, z*HH])
        lego_op(t);
    }
}

module lego_build(map) {
    _ = [1, 0, 0, 0, 0, 0, 0, 0, 0];
    for (z = [0:len(map)-1]) {
        plane = map[z];
        for (y = [0:len(plane)-1]) {
            row = plane[y];
            for (x = [0:len(row)-1]) {
                cell = row[x];
                if (cell==0) {
                }
                else if (cell==1) {
                    lego_block(_, x, y, z);
                }
                else {
                    lego_block(cell, x, y, z);
                }
            }
        }
    }
}


if(1) {
    $fn = 90;
    arr = [
        [0, 0, 0, 0, 0, 0, 0, 1, 0],
        [0, 0, 0, 0, 0, 0, 0, 2, 0],
        [0, 0, 0, 0, 0, 0, 0, 3, 0],
        [0, 0, 0, 0, 0, 0, 0, 4, 0],
        [0, 0, 0, 0, 0, 0, 0, 5, 0],
        [0, 0, 0, 0, 0, 0, 0, 6, 0],
        [0, 0, 0, 0, 0, 0, 0, 7, 0],
        [0, 0, 0, 0, 0, 0, 0, 8, 0],
    ];
    
    for (i=[0:len(arr)-1]) {
        block = arr[i];
        lego_block(block, i*2, 0, 0);
        block2 = [for(i=[0:len(block)-1]) if(i==0) 1 else block[i]];
        lego_block(block2, i*2, 2, 0);
    }
}


