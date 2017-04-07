module spacer() {
    scale([1,1,8/7])
    translate([0,0,-3])
    import("/home/pascal/Dropbox/3d-printing/iris/custom/v2_spacer.stl");
}


spacer();

translate([0, -30, 0])
spacer();

translate([30, -30, 0])
spacer();

translate([30, 0, 0])
spacer();