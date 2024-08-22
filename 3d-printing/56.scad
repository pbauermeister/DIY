
k = 60 / 15;

FN  = 48*2;
FN2 = 48;

R = 4;


module txt(th=.01) {
    linear_extrude(height=th)
    scale([k, k, 1])
    text("56", font="Bitstream Charter:style=Italic", $fn=FN);
}

minkowski() {
    txt();

    intersection() {
        sphere(r=R, $fn=FN2);
        cylinder(r=R+1, h=R*2);
    }
}
