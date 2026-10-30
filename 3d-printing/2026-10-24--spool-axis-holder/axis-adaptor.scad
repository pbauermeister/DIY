
DIN  = 53;
DOUT = 73;
H    = 63.5;
TH   =  0.4;
LAYER = 2.125;

N = floor((DOUT-DIN-LAYER)/LAYER/4)*2;

$fn = 20;

module cone() {
    difference() {
        cylinder(d1=DOUT, d2=0, h=DOUT/2);

        translate([0, 0, -TH*sqrt(2)])
        cylinder(d1=DOUT, d2=0, h=DOUT/2);
    }
}


module ring(inv=false, k=0) {
    off = ((DOUT-DIN)/2 - N * LAYER -LAYER/2) /2;
    
    difference() {
        // crown
        translate([0, 0, inv?LAYER:0])
        scale([1, 1, inv?-1:1])
        intersection() {
            translate([0, 0, -k*LAYER - off])
            cone();
            cylinder(d=DOUT, h=LAYER);
        }

/*        
        // radial cuts
        d = DOUT-k*LAYER*2-off;
        n = 20; //round(PI*d / (LAYER*5));
        di = k%2 ? 0 : .5;
        for (i=[0:n-1])
            rotate([0, 0, (i+di+.25) * 360/n])
            translate([0, -.5, -LAYER])
            cube([d/2, 1, LAYER*3]);
*/
    }
}

module half_layer(closed) {    
    for (k=[0:2:N-2]) {
        ring(true, k=k);
        if (closed)
            ring(false, k=k+1);
    }
}

module layer(closed=true) {
    half_layer(closed);

    translate([0, 0, LAYER*2])
    scale([1, 1, -1])
    half_layer(closed);
}

module layers() {
    n = ceil(H / (LAYER*4));

    for (i=[0:n-1]) {
        h = i*LAYER*4;
        translate([0, 0, h])
        layer(true);

        translate([0, 0, h + LAYER*2])
        layer(false);
    }

    translate([0, 0, n*LAYER*4])
    layer(true);
    
}

module adaptor() {
    difference() {
        layers();

        // radial cuts
        n = 20; //round(PI*d / (LAYER*5));
        h = H*2+LAYER*3;
        th = 2.5;
        difference() {
            for (i=[0:n-1])
                rotate([0, 0, (i+.5) * 360/n])
                translate([0, -th/2, 0])
                cube([DOUT/2, th, h]);
            d = (DIN+DOUT) / 2;
            
            // crown
            difference() {
                cylinder(d=d+LAYER, h=h);
                cylinder(d=d-LAYER, h=h*3, center=true);
            }
        }
    }
}

CROSS_CUT = true;
    
intersection() {
    union() {
        adaptor();
        
        if (CROSS_CUT)
        difference() {
            cylinder(d=DOUT+.2, h=H);
            cylinder(d=DOUT, h=H*3, center=1);
        }

        if (CROSS_CUT)
        difference() {
            cylinder(d=DIN, h=H);
            cylinder(d=DIN-.2, h=H*3, center=1);
        }
    }

    if (CROSS_CUT)
    cube([.1*5, DOUT*3, DOUT*3], center=true);
}

//%cylinder(d=DIN, h=H);
