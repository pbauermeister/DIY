
k = .15;
$fn = 60;

UU = 39.8 / 5;
HH = 23.4 / 3;


difference() {
    intersection() {
        translate([0, -1.5, .25])
        scale([1, 1, 1.2])
        union() {
            translate([0, 2, 1])
            scale([1, 1, .6])
            translate([-14.5, -8.9, -6.7])
            scale([k, k, k])
            import("mando-etsy/Mandalorian - Body.STL");

            // filling
            for (k=[1, -1]) {
                scale([k, 1, 1])
                hull() {
                    translate([4.8, 0, 0])
                    translate([0, -6, .85])
                    rotate([-90, 0, 0])
                    scale([1.5, .9, 1])
                    cylinder(d=3, h=1);

                    translate([0, 9, .7])
                    rotate([-90, 0, 0])
                    scale([1.6, .9, 1])
                    cylinder(d=4, h=1);
                }
            }
        }

        union() {
            resize([12.1, 7.5, 10])
            cylinder();

            translate([-10, -20, -10])
            cube([20, 20, 20]);
        }
    }
 
    h = 9;
    if(0)
    translate([0, 0, -h])
    cylinder(r=20, h=h);

    translate([0, 0, 2.25])
    resize([12.1, 7.75, 10])
    cylinder();

    translate([-UU*1.5, -UU/2 +1 -3 -.5, -HH])
    cube([UU*3, UU*2, HH*1]);
}

resize([12.1, 7.75, 2.25])
cylinder();
