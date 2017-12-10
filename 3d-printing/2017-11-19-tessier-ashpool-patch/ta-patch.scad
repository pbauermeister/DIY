THICKNESS = 0.4;
EMBOSS = 0.3;
BORDER = 1;
CARVE = 0.2;
LENGTH = 48;
R = 1.2;

DXF = "design.dxf";

IS_CONVEX = !true;
FILLET = 6;

module gfx() {
    resize([LENGTH, 0, 0], auto=true)
    import(DXF);
}

module fillet(r) {
    offset(r=-r) offset(delta=r) children();
}

module body(thickness, inset) {
    if(IS_CONVEX)
        linear_extrude(height=thickness)
        offset(r=-inset)
        fillet(FILLET)
        gfx();
    else
        linear_extrude(height=thickness)
        offset(r=-inset)
        hull()
        gfx();
}

module all() {
    difference() {
        union() {
            // logo
            linear_extrude(height=1)
            gfx();

            // body
            translate([0, 0, -THICKNESS])
            body(THICKNESS, 0);
        }

        // carved back
        translate([0, 0, -THICKNESS])
        body(CARVE, BORDER);
    }
}

rotate([180, 0, 0])
all();

