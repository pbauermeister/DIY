
STEPS = 50*3;
RANGE = 360;
LIM = 0.09;
K = 1;

for (xx=[0:STEPS]) {
	x = xx / STEPS * RANGE;

	for (yy=[0:STEPS]) {
		y = yy / STEPS * RANGE;

		for (zz=[0:STEPS]) {
			z = zz / STEPS * RANGE;

			val 	= sin(x*K) * cos(y*K)
                  	+ sin(y*K) * cos(z*K)
                  	+ sin(z*K) * cos(x*K);
			into = abs(val) < LIM;
			if (into) {
				translate([xx, yy, zz])
				cube();
			}
		}

	}

}