use <sides.scad>

TH1 = 2;
TH2 = 5;
TTH = .8;

D  = get_holes_d_sp()[0];
SP = get_holes_d_sp()[1];

fn = $preview ? 25 : 100;

module stud(xd=0.2, xd2=-2.8, dz=-.15) {
    //%hole();
    translate([0, 0, dz])
    difference() {
        intersection() {
            hole();
            translate([0, 0, -1]) hole();

            union() {
                d = D*1.015 + xd;
                translate([0, 0, 1+TH1-TTH-.5])
                resize([d, d, TH2*.99])
                sphere(1, $fn=fn);
                cylinder(d=D*.85, h=TH2/2, $fn=fn);
            }
        }
        
        for (a=[45, -45])
            rotate([0, 0, a])
            cube([D*2, 1, D*2], center=true);
        
        // axial hollowing
        d2 = D-3 + xd2;
        cylinder(d=d2, h=TH1*4, $fn=fn, center=true);
    }
}

module test_1() {
    // studs
    for (i=[0:2]) for (j=[-2:0]) {
        xd = i*.3;
        xd2 = j*.3;
        
        k = i*3 + j -2;
        translate([0, k*(D+SP), 0]) {
            stud(xd, xd2);
        }
    }

    // plate
    difference() {
        translate([14, 0, -.3])
        cube([40, 9*(D+SP), .6], center=true);

        for (i=[0:2]) for (j=[-2:0]) {
            xd = i*.3;
            xd2 = j*.3;
            
            k = i*3 + j -2;
            translate([0, k*(D+SP), 0]) {
                translate([0, -2, -.4])
                linear_extrude(height=1)
                text(str("    ", xd, " / ", xd2),
                     font="Liberation Sans:style=Bold", size=4.5);
            }
        }
    }
}

module test_2() {
    // plate
    th = 5;
    translate([-8, -10, -th])
    cube([16, 50, th]);

    // studs
    for (i=[0:2]) {
        z = -(i+1)*.1;
        echo(str("z=", z));
        translate([0, i*(D+SP), z]) {
            stud(0);
        }
    }
}

module test_3() {
    // plate
    th = 5;
    translate([-8, -10, -th])
    cube([16, 50, th]);

    // studs
    for (i=[0:2]) {
        xd = (i+1)*.15;
        echo(str("xd=", xd));
        translate([0, i*(D+SP), 0]) {
            stud(xd=xd);
        }
    }
}

module test_4() {
    th = 5;

    // studs
    for (i=[0:2]) {
        xd = (i)*.1;
        echo(str("xd=", xd));
        translate([0, i*(D+SP), 0]) {
            // stud(xd=0.3, xd2=-2.8, dz=-.15)
            stud(xd=xd);
            
            difference() {
                translate([-8, -7, -th])
                cube([30, 14, th]);

                for (i=[-1, 1])
                    for (j=[-1, 1])
                        translate([5+i*.15, -2+j*.15, -.5])
                        linear_extrude(1)
                        text(str(xd), size=5);
            }
        }
    }
}


test_4();