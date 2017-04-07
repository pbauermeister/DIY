
// http://www.thingiverse.com/thing:13829

has_shaft = !true;

difference() {
    rotate([0,0,has_shaft? 45 : -45])
    scale([0.5,1,1])
    cylinder(r=10, h=0.3);
    for(x=[-10:2:10])
    for(y=[-10:2:10])
        translate([x,y,-.1]) cylinder($fn=15.0, r=0.75, h=1);
}
