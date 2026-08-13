use <bin-spring.scad>


intersection() {

    rotate([-90, 0, 0])
    piston();
    
if(0)    translate([-7, 8, -7])
    scale([1, .5, 1])
    cube(15);
}