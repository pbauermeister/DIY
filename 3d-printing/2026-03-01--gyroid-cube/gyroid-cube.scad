use <../chamferer.scad>


$fn = $preview ? 16 : 64;

K = 3.5 *.8;
D = 35  + 15;
KCH = 3;
KH  = .85;
TH = .9;

module envelope() {
    scale([1, 1, K*KH])
    chamferer(5, fn=$fn)
    scale([1, 1, 1/K])
    chamferer(D/KCH, "cylinder", fn=$fn)
    cube(D);
}

module shell() {
    difference() {
        envelope();
        
        chamferer(TH, "cylinder", grow=false)
        envelope();        
    }
}

intersection() {
    scale(D/40)
    import("gyroid.stl");

    envelope();
}
shell();

//%cube(D);
