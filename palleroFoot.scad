include<motor.scad>

foot();

module foot(footDia = 30, footH = 10) {

	epsilon = 0.01;
	extrasize = 0.2;
	batteryR = 5 + extrasize;
	batteryHoleH = 7 + extrasize;
	footR = footDia/2;
	$fn = 100;
	

	difference(){
		cylinder(r = footR , footH );
		translate([0,1.5*batteryR,footH-batteryHoleH]) { 
				cylinder(r = batteryR , batteryHoleH+ epsilon );
		}
		translate([0,-1.5*batteryR,footH-batteryHoleH]) { 
				cylinder(r = batteryR , batteryHoleH+ epsilon );
		}	
		
		translate([0,0,footH+1])
    		rotate([0,90,0])
	    	    motor(centerAtAxis=true);
		
	}
}
