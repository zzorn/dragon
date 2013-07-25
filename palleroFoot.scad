foot();
module foot(){

	epsilon = 0.001;
	extrasize = 0.2;
	batteryR = 5 + extrasize;
	batteryHoleH = 7 + extrasize;
	footR = 15;
	footH = 8;
	

	difference(){
		cylinder(r = footR , footH );
		translate([0,1.5*batteryR,footH-batteryHoleH]) { 
				cylinder(r = batteryR , batteryHoleH+ epsilon );
		}
		translate([0,-1.5*batteryR,footH-batteryHoleH]) { 
				cylinder(r = batteryR , batteryHoleH+ epsilon );
		}	
	}
}
