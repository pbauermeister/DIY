use <can-crusher-arm.scad>

// arms_printing();

K = 1;
ARM_THICKNESS = 12*K;
ARM_LENGTH = 120*K;

sp = 3*K;
sy = ARM_THICKNESS/2 + sp;

/*
translate([30, 80, 0]) spacer();

translate([ARM_LENGTH + sp*3, sy*5.4, 0])
scale([-1, -1, 1])
arm(true, bumper="f");
*/

translate([0, sy, 0])
arm();

translate([0, -sy, 0])
scale([1, -1, 1])
arm(mirror_wheel=true);

translate([ARM_LENGTH + sp*3, -sy*5.4, 0])
scale([-1, 1, 1])
arm(true, mirror_wheel=true, bumper="m");