$fn=45;

difference() {
    translate([0, -7, 0])
    linear_extrude(height=3) scale([10, 10, 10])
    import("/home/pascal/Dropbox/3d-printing/cel-box/custom/spring.dxf");
    translate([10, 1, 0.5]) cube([20, 8, 10]);
    translate([3, 1, 1.5]) cube([34, 8, 10]);
}

translate([20, 13, 1]) 
difference() {
sphere(r=2);
translate([-3, -3, -7]) cube(6);
}