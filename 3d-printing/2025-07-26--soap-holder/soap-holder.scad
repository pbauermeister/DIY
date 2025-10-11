use <../chamferer.scad>

L = 120;
W =  80;
H =  16;

TH  = 6;
CH  = 2;

R = 25;

ATOM = 0.01;
fn = $preview ? 20 : 150;
$fn = fn;

module slice(r, l, w, h=ATOM) {
    hull()
    for (kx=[-1, 1])
    for (ky=[-1, 1])
        translate([(l/2-r)*kx, (w/2-r)*ky])
        cylinder(r=r, h=h);
}


module outer() {
    hull() {
        translate([0, 0, H])
        slice(R, L, W);

        d = H/8;
        slice(R-d, L-d*2, W-d*2);
    }
}

module inner() {
    hull() {
        translate([0, 0, H+ATOM])
        slice(R-TH, L-TH*2, W-TH*2);

        d = H/8;
        translate([0, 0, -ATOM])
        slice(R-TH-d, L-d*2-TH*2, W-d*2-TH*2);
    }
}

module base() {
    d = H/8 +TH/2;
    slice(R-d, L-d*2, W-d*2, TH/2);
}

module sole() {
    difference() {
        d = H/8 + TH;
        step = W/30;
        slice(R-d, L-d*2, W-d*2, .5);

        for (y=[-W/2:step:W/2])
            translate([0, y, 0])
            cube([L*2, step/2, 4], center=true);
    }
}

module bowl() {
    r = L*2.67;
    translate([0, 0, r + TH*.75 +1])
    scale([1, .6, 1])
    sphere(r=r, $fn=200);
}

module bottom() {
    difference() {
        intersection() {
            translate([-L/2, -W/2, 0])
            cube([L, W, H]);
            inner();
        }
        bowl();
    }
}

module ribs(th=2.5) {
    n = 7;
    intersection() {
        // ribs
        difference() {
            // bars
            union()
            for (y=[-n : 1 : n])
                translate([-L/2, -th/2 + W/(n*2+1)*y, 0])
                cube([L, th, H]);
            // hollowing
            translate([0, 0, .5])
            bowl();
        }
        // limits
        inner();
    }
}

module drain(z=0, shift=0) {
    a = 5;
    hull()
    for (dz=[0, z])
    for (k=[-1, 1])
        translate([k*TH*.25, 0, TH+W/2*sin(a) + dz -2+1])
        rotate([90+5, 0, 0])
        translate([0, 0, -shift*W/2])
        cylinder(d=TH, h=W, $fn=100);
}

module gutter() {
    hull() {
        for (y=[0, -W*0])
        translate([0, y, 0])
        intersection() {
            // central (short axis) gutter
            scale([.25, 1, 1])
            bowl();
            // limited by the drain
            translate([0, 0, -TH])
            drain(z=TH*2, shift=1);
        }
        intersection() {
            drain(TH*3, .25);
            inner();
        }
    }
}

module holder() {
    difference() {
        union() {
            // border
            difference() {
                union() {
                    chamferer($preview ? 0 : CH, "cone", fn=20)
                    difference() {
                        outer();
                        inner();
                    }

                    // spout
                    translate([0, -W/2 + H/8, 0])
                    scale([1, .67, 1])
                    cylinder(d=TH*2.5, h=TH/2);
                    
                    // fill bottom chamfer
                    base();
                }
                drain();
            }

            // bottom
            difference() {
                union() {
                    bottom();
                    ribs();       
                }

//                if (!$preview)
                   gutter();

//                drain(TH*3, .25);
            }
        }
        translate([0, 0, -ATOM])
        sole();
    }
}

module grille() {
    difference() {
        intersection() {
            kx = (L-1.5)/L;
            ky = (W-1.5)/W;
            union() {
                th = 1;
                ribs(th);
                cube([1, W, 6], center=true);

                difference() {
                    inner();
                    scale([kx, ky, 2]) inner();
                }
            }
            inner();
        }
        translate([0, 0, 3]) bowl();
    }    
}

//holder();
//!gutter();

grille();