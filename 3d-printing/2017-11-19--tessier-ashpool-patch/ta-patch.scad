// Print quality: fine

// DIMENSIONS
// ----------
LOGO_THICKNESS = 0.6; // up to you, but shall be thin enough to stay bendable
BACK_THICKNESS = 0.2; // adjust to obtain the thinnest possible layer for your printer in fine quality
// The total thickness will be LOGO_THICKNESS+BACK_THICKNESS+BACK_BORDER_THICKNESS

// Desired length:
LENGTH = 48; // set to 0 to keep length defined in vector graphics
// Note: aspect ratio is preserved

// BACK BORDER
// -----------
BACK_BORDER_THICKNESS = 0.2; // the back layer will have a border this deep
BACK_BORDER_WIDTH = 1;  // the back layer will have a border this wide

// PRINTING UPSIDE-DOWN
// --------------------
// If your printer's adhesion is bad and you need rafting, set BACK_BORDER_THICKNESS to 0 and UPSIDE_DOWN to false.
UPSIDE_DOWN = true // if you have no back border, and good bed adhesion (no rafting needed) better print upside-down
            || BACK_BORDER_THICKNESS > 0;

// GRAPHIC FILE(S)
// ---------------
// Logo graphics
LOGO_DXF = "design.dxf";
IS_CONVEX = false; // e.g. the shape of the back layer is a heart or a donut...

// BACK
// ----
// For concave patches:
// - The back will be auto-computed, using a hull of the logo.
// For convex patches:
// - You may either specify a back file, or have the back auto-computed:
BACK_DXF = ""; // "design-back.dxf"; // - non-empty -> use it as back
FILLET = 6; // - if BACK_DXF is empty, we will fill areas using a fillet of this amount

// HELPERS
// -------

module load_gfx(file_name) {
    resize([LENGTH, 0, 0], auto=true)
    import(file_name);
}

module fillet(r) {
    offset(r=-r) offset(delta=r) children();
}

module make_back_convex_auto(thickness, inset) {
    linear_extrude(height=thickness)
    offset(r=-inset)
    fillet(FILLET)
    load_gfx(LOGO_DXF);
}

module make_back_convex_dxf(thickness, inset) {
    linear_extrude(height=thickness)
    load_gfx(BACK_DXF);
}

module make_back_concave(thickness, inset) {
    linear_extrude(height=thickness)
    offset(r=-inset)
    hull()
    load_gfx(LOGO_DXF);
}

module make_back(thickness, inset) {
    if (IS_CONVEX) {
        if (len(BACK_DXF)==0)
            make_back_convex_auto(thickness, inset);
        else
            make_back_convex_dxf(thickness, inset);
    }
    else {
        make_back_concave(thickness, inset);
    }
}

// MAIN STUFF
// ----------

module make_patch() {
    back_total_thickness = BACK_THICKNESS+BACK_BORDER_THICKNESS;
    difference() {
        union() {
            // add logo layer:
            linear_extrude(height=LOGO_THICKNESS) load_gfx(LOGO_DXF);
            // add back layer:
            translate([0, 0, -back_total_thickness]) make_back(back_total_thickness, 0);
        }
        // carve the back to obtain a border:
        translate([0, 0, -back_total_thickness]) make_back(BACK_BORDER_THICKNESS, BACK_BORDER_WIDTH);
    }
}

rotate([UPSIDE_DOWN ? 180 : 0, 0, 0])
make_patch();

