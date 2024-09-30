FONT =
//"New Stencil tfb:style=Regular"
//"Mothercode"

//"Gunplay"
//"Ruler Stencil Heavy"
//"TT Mussels Stencil Trl"
//"Sargento Gorila"
"billieKid"
;



module print(txt, font=FONT, xscale=1.3, yscale=1) {
    scale([xscale, yscale, 1])
    text(txt, font=font);

    translate([0, -15, 0])
    //text(txt, font=FONT);
    children();
}

module graphics() {
    translate([10, -18, 0]) {
        print("This side up ↑")
        print("if lying");

        print("                      ↑", "Ruler Stencil Heavy", .9, .9);
    }

    translate([122, -25, 0])
    rotate([0, 0, -90]) {
        print("This side up ↑")
        print("   (if standing)");

        print("                      ↑", "Ruler Stencil Heavy", .9, .9);
    }

    translate([43, -93, 0])
    rotate([0, 0, -65 +45+20])
    scale([-.9, .9, 1])
    translate([-40, -55, 0])
    scale([.5, .5, .5])
    import("Telescope Silhouette SVG.svg");
}


scale([.8, .8, 1])
difference() {
    d = 140;

    translate([0, -d, 0])
    cube([d, d, .5]);
    
    translate([0, 0, -.1])
    linear_extrude(1)
    graphics();
}