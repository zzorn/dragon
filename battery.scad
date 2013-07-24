
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
					cube([dia+2*wallT,  lenght ,3/5*dia + wallT]);

			//minusend of case
			translate([-dia/2-wallT,-lenght/2 -minusEndL,0]) 
					cube([dia+2*wallT,  minusEndL+epsilon ,dia + wallT]);

			// plusend
			translate([-dia/2-wallT,+lenght/2 -epsilon,0])	
			 	cube([dia+2*wallT,  plusEndL+epsilon ,dia + wallT]);

	}
	// place for metalpiece
	translate([-metalPieceWidth/2,+lenght/2 -epsilon +plusEndL/2,8])rotate([25,0,0])
 		cube([metalPieceWidth,  metalPieseT ,dia + wallT]);

	// pluswire
	translate([0,lenght/2 + plusEndL+epsilon, dia/2+wallT]) rotate([90]) 			cylinder(3*plusEndL/5, r2= wireholeR, r1 = 3*wireholeR);

	// battery
	translate([0,lenght/2, dia/2+wallT]) rotate([90]) 
		cylinder(lenght, r= dia/2);

	// minuswireHole
	translate([0,lenght/2, dia/2+wallT]) rotate([90]) 
		cylinder(3/2*lenght, r= wireholeR);
}