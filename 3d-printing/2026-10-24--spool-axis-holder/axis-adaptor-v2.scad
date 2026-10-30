
DIN  = 53;
DOUT = 73;
H    = 63.5;
TH   =  0.4;
LAYER = 2.125;

N = floor((DOUT-DIN-LAYER)/LAYER/4)*2;

$fn = 200;

module adaptor() {
    th = .7;
    xtra = .5;
    do = DOUT + xtra;
    di = DIN - xtra;
    w = sqrt(do*do -di*di);
    n = 6;
    for (i = [0:n-1])
        rotate([0, 0, i/n*360])
        translate([di/2-th/2, -w/2, 0])
        cube([th, w, H]);
}

CROSS_CUT = true ;//&& $preview;
    
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

    //if (CROSS_CUT) cube([.1*5, DOUT*3, DOUT*3], center=true);
}

//%cylinder(d=DIN, h=H);
