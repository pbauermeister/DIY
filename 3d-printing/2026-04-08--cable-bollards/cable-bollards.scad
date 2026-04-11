use <../chamferer.scad>

L_SPACING = 100;
W_SPACING =  25;
MARGIN    =  10;
N         =   4*0+1;
H         =  18;
D         =  15;
TH        =   4;
SLIT      =   6;
CH        =   3;

$fn = $preview ? 20 : 100;

module pillars(grow=0) {
    for (i=[0:N-1]) for (x=[0, L_SPACING]) translate([x, i*W_SPACING, 0]) {
        union() {
            hull() for (j=[0, x?-D:D])
                translate([j, 0, 0])
                cylinder(d=D+grow, h=H+D*.25);//H+D/8);
        }
    }
}

module base(grow=0) {
    // plate
    hull()
        for (i=[0, N-1])
        for (x=[0, L_SPACING]) translate([x, i*W_SPACING, -TH-grow]) {
            cylinder(d=D+MARGIN*2, h=TH+grow);
    }

    // pillars
    if (grow)
        pillars(grow);
}

module chamfered_base() {
    difference() {
        union() {
            translate([0, 0, CH*.92])
            chamferer($preview ? CH: CH, fn=12, grow=false)
            base(CH*2*.87);
            
            base();
        }
        
        for (i=[0:N-1]) {
            /*
            // cracks
            translate([0, 0, -TH/2])
            for (d=[2:2:4]) difference() {
                pillars(-d);
                pillars(-d - 0.07);
            }
            */
        
            // slit
            translate([-D-L_SPACING/2, -SLIT/2 + i*W_SPACING, H*.85])
            cube([L_SPACING*2, SLIT, H*2]);
        }    
    }    
}

//!chamfered_base();

difference() {
    difference() {
        union() {
            // heads
            for (i=[0:N-1]) for (x=[0, L_SPACING]) translate([x, i*W_SPACING, 0]) {
                hull()
                for (j=[0, x?-D:D])
                translate([j, 0, H+D/2])
                intersection() {
                    resize([D*1.5, D*1.125, D])
                    sphere();
                    cube([D*3, D*2, D*.75], center=true);
                }
            }

            // base
            chamfered_base();
        }

        step = 1;
        amax = 60;
        dh = D/amax * step;
        
        for (i=[0:N-1]) 
        translate([0, i*W_SPACING, 0]) {
            for (x=[0, L_SPACING])
            translate([x,0, 0])
            translate([x?-D/2:D/2, 0, 0]) {
                // cork slit        
                for (a=[0:step:amax]) {
                    rotate([0, 0, a])
                    translate([-D, -SLIT/2, H + D/amax*a/2])
                    cube([D*2, SLIT, dh*0+SLIT/2]);
                }

                // top slit
                rotate([0, 0, amax])
                translate([-D, -SLIT/2, H + D*.55])
                cube([D*2, SLIT, H]);
            }

            for (k=[0, 1]) {
                translate([k?L_SPACING:0, 0, 0])
                scale([k?-1:1, 1, 1])
                hull() {
                    translate([-D*1.5, -SLIT/2, 2])
                    cube([D*1.5, SLIT, H-2]);

                    translate([D*.75, -SLIT/2, H])
                    cube([1, SLIT, 1]);
                }
            }
        }
        
        // screw holes
        for (y=[W_SPACING/2, W_SPACING*(N-1.5)])
        for (x=[D*1.5, L_SPACING - D*1.5])
            translate([x, y, 0])
            cylinder(d=4.5, h=H*6, center=true);
    }
}
