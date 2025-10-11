module screw_hole(d=5.5, head_d=16,       // screw body and head diameters
                  l=8,                    // screw body length
                  total_l=10,             // total length incl head pit
                  concentric_cracks=true, // with reinforcement cracks
                  concentric_step=.625,   // cracks spacing
                  first_layer=.3,         // bottom layers before reinforcement cracks
                  last_layer=.3,          // top layer after reinforcement cracks
                  bore_through=.1,        // extra body depth
                  $fn=50) {
    
    // central hole
    translate([0, 0, -bore_through])
    cylinder(d=d, h=total_l + bore_through);

    // head
    translate([0, 0, l])
    cylinder(d=head_d, h=total_l-l, $fn=$fn);

    // concentric reinforcement cracks
    if (concentric_cracks) for (d=[d:concentric_step*2:head_d]) {
        difference() {
            translate([0, 0, first_layer])
            cylinder(d=d, h=l - first_layer - last_layer, $fn=$fn);
            cylinder(d=d-.1, h=total_l*3, center=true, $fn=$fn);
        }
    }
    
    // todo: star cracks
}

!screw_hole(4.2, 7, 6, 10);