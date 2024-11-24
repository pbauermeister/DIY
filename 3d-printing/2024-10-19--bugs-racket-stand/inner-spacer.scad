use <bugs-racket-stand.scad>

v = get_vars();

N = v[0];
M = v[1];
R = v[2];
INNER_DIAMETER = v[3];
SKIN = v[4];

$fn = $preview ? 100 : 200;

module inner_spacer(n_spokes=8) {
    n = N;
    m = M;
    r = R;
    a = 360/n;
    v = r * (1-cos(a));
    c = sin(a) * r;
    margin = 1.2;

    rr = r-v*2 - margin;
    rin = INNER_DIAMETER/2 + SKIN*1 + margin/2; 
    h= 3;
    difference() {
        cylinder(r=rr, h=h, center=true);
        cylinder(r=rr-3, h=h*3, center=true);
    }

    difference() {
        union() {
            for (a=[0:n_spokes-1]) {
                rotate([0, 0, 360/n_spokes*a])
                cube([3, rr*2-2, h], center=true);
            }
            cylinder(r=rin+3, h=h, center=true);
            
        }
        cylinder(r=rin, h=h*3, center=true);
    }
}


inner_spacer();