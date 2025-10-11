W  =  8;
L  = 16;
D  =  1 * 1.12; //1.25; //1.5;
H  =  5;
DX = D * .67; //.75;

$fn = 100;
dx = (W/2-H/2);


module half_cylinder(k=1) {
    difference() {
        rotate([90, 0, 0]) cylinder(d=D*2*k, h=D, center=true);
        rotate([90, 0, 90]) cylinder(d=D*10, h=D*10, center=!true);
    }
}

module lock() {
    kh = .28;
    difference() {
        hull() for (k=[-1, 1])
            translate([dx * k, 0, 0])
            cylinder(d=H, h=L);

        // channel 1
        translate([dx, 0, 0])
        cylinder(d=D, h=L*3, center=true);

        dl = L/3;
        translate([dx, 0, L-dl+0.01])
        cylinder(d1=D*2, d2=H-2, h=dl);

        // channel 2
            translate([-dx, 0, 0]) cylinder(d=D, h=L*3, center=true);

        translate([-dx, 0, L/2])
        scale([1, 1, 1.6])
        half_cylinder(1.0125);

    }


    // channel 2
        translate([-dx + DX, 0, L/2])
        scale([1, 1, 1.6])
        half_cylinder(0.75);
}

difference() {
    lock();
    
    if($preview) rotate([90, 0, 0]) cylinder(d=1000, h=100);
}
