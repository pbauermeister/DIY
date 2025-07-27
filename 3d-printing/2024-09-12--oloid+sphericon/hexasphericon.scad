D    = 40.0;
WALL =  0.15;
ATOM =  0.01;
$fn = 200;
N = 6;

module half_cyl() {
    difference() {
        // rotated hexagon
        rotate_extrude(angle=360, $fn=360)
        difference() {
            rotate([0, 0, N/4==floor(N/4) ? 0 : 180/N])
            circle(r=.5, $fn=N);
            translate([-1, -.5]) square([1, 1]);
        }
        
        // remove half
        translate([0, -.5, -.5])
        cube(1);
    }
}

module hexasphericon(size) {
    scale([size, size, size]) {
        half_cyl();

        rotate([360/N, 0, 0])
        scale([-1, 1, 1])
        half_cyl();
    }
}

module support() {
    extra = 2;
    h = D/2;
    l = D/2;
    d = D * .5;
    dd = D/7;
    layer = .3*2;
 
    r = D*sqrt(3)/4;
    
    translate([0, 0, -D/2 - layer]) 
    difference() {
        cylinder(r=r, h=D/2);
        cylinder(r=r-WALL, h=D*3, center=true);
        translate([-D, -D*2, -ATOM])
        cube(D*2);
    }

    translate([0, -D, -D/2 - layer]) {
        intersection() {
            difference() {
                union() {
                    rotate([0, 30, 0])
                    translate([-WALL*sqrt(2)*2, 0, -WALL*2])
                    cube([WALL, D, D/2 + WALL*2]);

                    cylinder(d=d, h=h);
                }
                cylinder(d=d-WALL*2, h=h*3, center=true);
            }
            cylinder(d=D*10, h=D*sqrt(3)/4);
        }
    }
}


module support() {
    extra = 2;
    h = D/2;
    l = D/2;
    d = D * .5;
    dd = D/7;
    layer = .3*3;
 
    r = D*sqrt(3)/4;

    if(0)
    translate([D/2, 0, -D/2 - layer])
    cylinder(d=1, h=.3);



    translate([0, -D, -D/2 - layer]) {
        intersection() {
            difference() {
                union() {
                    rotate([0, 30, 0])
                    translate([-WALL*sqrt(2)*2, D/2, -WALL*2])
                    cube([WALL, D/2, D/2 + WALL*2]);
                }
            }
        }
    }

}


module hexasphericon_oriented() {
    rotate([00, 30, 0])
    rotate([90, 0, 0])
    rotate([0, 90, 0])
    hexasphericon(D);
}

module hexasphericon_final() {
    for (d=[D:-2:1]) {
        k0 = d / D;
        k1 = (d-1.5) / D;
        difference() {
            scale(k0)
            hexasphericon_oriented();

            scale(k1)
            hexasphericon_oriented();
        }
/*
        scale([1, 1, k*k])
        hexasphericon_oriented();

        scale([.75, .75, k0])
        hexasphericon_oriented();
        */
    }

    scale([.2, .2, 1])
    hexasphericon_oriented();

}

if(0)
difference() {
    hexasphericon_final();

    if ($preview) translate([0, 0, -D])
    cube(D*3);
}
//support();

//%cube(D, center=true);


//hexasphericon(D);
{
hexasphericon_oriented();
support();
}