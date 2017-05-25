$fn = 12; // This will give 45° chamfers

module Layer(filename, altitude) {
    // bring to desired altitude
    translate([0, 0, altitude * 0.865 -0.068])
    
    minkowski() {
        // thin layer
        linear_extrude(height=.0001) scale(10, 10, 1)
            import(filename);
        
         // thickness and chamfers
        translate([0, 0, 0.5]) sphere(r=0.5);
    }
}

module WithoutCrops() {
    // remove crop marks
    XSIZE = 110;
    YSIZE = 82;
    ZSIZE = 5;
    margin = 2;
    intersection() {
        translate([margin/2, margin/2, -margin/2])
            cube([XSIZE-margin, YSIZE-margin, ZSIZE]);
        children();
    }
}

WithoutCrops(){
    union() {
        color("blue")  Layer("top-bottom.dxf", 0);
        color("red")   Layer("mid-1.dxf", 1);
        color("green") Layer("mid-2.dxf", 2);
        color("blue")  Layer("top-bottom.dxf", 3);
        
        linear_extrude(height=2) scale(10, 10, 1) import("columns.dxf");
    }
}