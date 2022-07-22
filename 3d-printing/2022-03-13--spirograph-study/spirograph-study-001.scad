
R = 2;
K = 5;
RR = R * K;

function fx(i) = (RR+R)*cos(i) -R*cos((RR+R)/R*i);
function fy(i) = (RR+R)*sin(i) -R*sin((RR+R)/R*i);
function f(i) = [fx(i), fy(i)];
p = [ for(i=[0:360]) f(i) ];

echo(p);
polygon(points=p);
