$fn=60;

scale(10)
union() {
    difference(){
        sphere(0.5);
        rotate([54.7 + 180, 0, 0])
        rotate([0, 0, 45])
        cube(1,1,1);
    }
//    sphere(0.25);
}