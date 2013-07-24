
testPrint();


module vibMotor(wires = true, wiresL = 1){
	extrasize = 0.2;
	width = 4.8 + extrasize;
	lenght = 11.3 + extrasize;

	translate([-width/2, -width/2, 0]){
		// motor
		cube([width,width,lenght]);
	}
	if (wires == true){
		translate([0,0,-wiresL]){
			// wires
			cylinder(r =width/2, wiresL+ 0.001);
		}
	}
}


module testPrint(){
	difference(){
		translate([-5,-5,0])  cube([10,10,13]);
		translate([0,0,1.501]) vibMotor(wiresL = 2);
	}
}