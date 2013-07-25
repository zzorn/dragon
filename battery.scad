motor();
module motor(){
extrasize = 0.3;
extraInEnd = 2;
// 70 are batteruy lenght lenght is battery holes lenght
lenght = 70 + extrasize + extraInEnd;
// battery dia
dia = 18.3 + extrasize;
// minimiwallThickness 
wallT = 2;
// lenght of the piese at end of battery minus end
minusEndL = 3;
// same whit +
plusEndL = 6;
epsilon = 0.001;
// hole for wire
wireholeR = 2;
// plus end metalpice
metalPieseT = 1 + extrasize;
metalPieceWidth = 10;
caseLenght = lenght + minusEndL + plusEndL;

difference(){
	union(){
			// case
			translate([-dia/2-wallT,-lenght/2,0]) 
					cube([dia+2*wallT,  lenght ,3/5*dia + 2* wallT]);

			//minusend of case
			translate([-dia/2-wallT,-lenght/2 -minusEndL,0]) 
					cube([dia+2*wallT,  minusEndL+epsilon ,dia + 2*wallT]);

			// plusend
			translate([-dia/2-wallT,+lenght/2 -epsilon,0])	
			 	cube([dia+2*wallT,  plusEndL+epsilon ,dia + 2*wallT]);

}
	// place for metalpiece
	translate([-metalPieceWidth/2,+lenght/2 -epsilon +plusEndL/2,10])rotate([25,0,0])
 		cube([metalPieceWidth,  metalPieseT ,dia + wallT]);

	// pluswire
	translate([0,lenght/2 + 1.1*plusEndL+epsilon, dia/2+1.2*wallT]) rotate([90]) 			cylinder(3*plusEndL/5, r2= wireholeR, r1 = 3*wireholeR);

	// battery
	translate([0,lenght/2, dia/2+2*wallT]) rotate([90]) 
		cylinder(lenght, r= dia/2);

	// minuswireHole
	translate([0,lenght/2, dia/2+2*wallT]) rotate([90]) 
		cylinder(3/2*lenght, r= wireholeR);
	// screwhole
	translate ([0,0,-epsilon])
		cylinder(r = 1.6, , h = wallT*2.2 , $fn = 30 );
	translate ([0,0,wallT])
		cylinder(r = 5, , h = wallT*2 , $fn = 30 );
}
}
