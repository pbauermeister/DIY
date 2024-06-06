
TOTAL_LENGTH = 345;
WIDTH        = 143;
THICKNESS    =   8.2;
D            =  66;

LENGTH = TOTAL_LENGTH / 3;
SPACE  = (TOTAL_LENGTH - D*3) / 4;

PLATE_D      = 180;

module stencile(i) {   
    difference() {
        cube([LENGTH, WIDTH, THICKNESS]);
        
        dd = (LENGTH-D)/2;
        translate([i==0 ? LENGTH/2 : i==1 ? D/2-dd+SPACE : LENGTH-D/2+dd-SPACE, WIDTH/2, 0])
        cylinder(d=D, h=THICKNESS*3, center=true, $fn=360/2);
    }
}

module rounded_stencile(i) {
    intersection() {
        stencile(i);
        translate([LENGTH/2, WIDTH/2, 0])
        cylinder(d=PLATE_D-5, h=THICKNESS*3, center=true);
    }
}


module all() {
    for(i=[-1:1]) {
        translate([i*LENGTH + i, 0, 0])
        rounded_stencile(i);
    }
}


//rounded_stencile(-1);
rounded_stencile(0);
//rounded_stencile(1);