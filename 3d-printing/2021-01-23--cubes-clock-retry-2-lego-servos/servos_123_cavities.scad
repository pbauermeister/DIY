include <definitions.scad>
use <servos_123.scad>

module servos_cavities_render() {
    servos_render(with_cavities=true);
}

module servos_cavities_from_stl() {
    import("servos_123_cavities.stl");
}

module servos_cavities() {
    //servos_cavities_render();
    servos_cavities_from_stl();
}

servos_cavities();