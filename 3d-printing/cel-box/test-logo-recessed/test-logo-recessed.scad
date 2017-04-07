

intersection()
{
    translate([0,-70,0]) cube([60,70,0.4]);


    translate([0,100,22])
    rotate([180,0,0])
    difference() 
    {
        import("/home/pascal/Dropbox/3d-printing/cel-box/cover_v2.stl");
        {
            translate([55,105,16.7])
            rotate([0,0,90])
            translate([0,0,5])
            scale(10)
            linear_extrude(height = 0.1) import("/home/pascal/Dropbox/3d-printing/cel-box/custom/logo.dxf");
        }
    }
}