

spheresize = 20;
footH = 3;
footR = 3;

%sphere(spheresize , $fn = 40);
translate([0, 0, -spheresize- footH]){
	cylinder(r = footR, h = footH, $fn = 30);
}