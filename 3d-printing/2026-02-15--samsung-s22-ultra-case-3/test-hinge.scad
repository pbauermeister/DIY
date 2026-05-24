use <hinge3.scad>

function decimalround(x, places) = let(
  s = str(x + 10^(-places-1)),
  l = len(s)
) chr([for(i=[0:l-2]) ord(s[i])]);

module slicer() {
    intersection() {
        children();
        cylinder(d=10000, h=.1, center=true);
    }    
}

l= 8.86;
z = -14.25  + .9;
th = 4.6;

//slicer() union()
{
    for (i=[0.01 : 0.01 : 0.06]) {
        translate([(i%5)*50*100, ceil((i+1)/5)*40, 0]) {  
            gap = i;
            rotate([90, 0, 0]) main_hinge(th=th, open=true, n=2, extra_gap=gap);

            difference() {
                translate([10, -l*4 -z, -th/2])
                cube([16, 4*l, 2]);

                for(kx=[-1, 1]) for(ky=[-1, 1])
                    translate([21 + kx*.4, -18+ky*.4, -1.5])
                    rotate([0, 0, 90])
                    linear_extrude(2)
                    text(str(decimalround(gap, 2)), size=9, spacing=1.2);
            }
 
        }
    }
}
