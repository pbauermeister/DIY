/* Easel for the Mandala frame. */

ANGLE = asin(15.4 / 17.2);

FRAME_LENGTH = 220;
FRAME_THICKNESS = 25 + 1;
BORDER = 6;

WIDTH = 100;

ATOM = 0.01;

echo(ANGLE);
echo(cos(ANGLE)*17.2);

module easel(straight=false, frameshade=false) {
    translate([-WIDTH/2, 0, 0])
    rotate([straight ? 90-ANGLE : 0, 0, 0]) {
        rotate([ANGLE, 0, 0]) {
            difference() {
                cube([WIDTH, FRAME_THICKNESS, FRAME_THICKNESS+BORDER*2]);
                
                if (frameshade)
                    %
                    translate([-(FRAME_LENGTH-WIDTH)/2, BORDER, BORDER])
                    cube([FRAME_LENGTH, FRAME_LENGTH, FRAME_THICKNESS]);

                translate([-ATOM, BORDER, BORDER])
                cube([WIDTH+ATOM*2, FRAME_THICKNESS, FRAME_THICKNESS]);

                translate([-ATOM, BORDER+BORDER, BORDER+BORDER*2])
                cube([WIDTH+ATOM*2, FRAME_LENGTH, FRAME_THICKNESS]);

                translate([BORDER*2, -BORDER, BORDER + FRAME_THICKNESS - BORDER])
                cube([WIDTH-BORDER*4, FRAME_THICKNESS, FRAME_THICKNESS]);
            }
            
        }

        intersection() {
            cl = cos(ANGLE)*FRAME_LENGTH;
            rotate([ANGLE, 0, 0])
            translate([WIDTH/2-BORDER/2, 0, BORDER-cl*2 ])
            cube([BORDER, FRAME_LENGTH, cl*2]);

            cube([WIDTH, FRAME_LENGTH*2, FRAME_LENGTH]);

            rotate([90-ANGLE, 0, 0])
            translate([0, 0, -FRAME_LENGTH])
            cube([WIDTH, FRAME_LENGTH*cos(ANGLE) * .9, FRAME_LENGTH*2]);   
        }
    }
}

if (! $preview)
    easel(true);
else
    easel(frameshade=true);