// TODO screw holes if wanted




// a tray where the hole made of the motor in 2 parts
exampleHoleTray();
//example that shows the motor inside an cube
exampleMotorInCube();




module exampleHoleTray(){
	difference(){
		cube([35 , 16, 12]);
		translate([1.5,2,1.5]){
			miniMotor();
		}
		translate([-0.5,-0.5,5.1]){
			cube([40 , 17, 13]);
   	}
	}
	translate([0,-4,11])rotate([180,0,0]){
		difference(){
			cube([35 , 16, 11]);
			translate([1.5,2,1.5]){
				miniMotor();
			}
			translate([-0.5,-0.5,-7.9]){
				cube([40 , 17, 13]);
  	 		}
		}
	}
}

module exampleMotorInCube(){
	%cube([35 , 16, 12]);
	translate([1.5,2,1.5]){
			miniMotor(showMotorPart = true);
	}
	translate([0,-4,10])rotate([180,0,0]){
		%cube([35 , 16, 10]);
			translate([1.5,2,1.5]){
				miniMotor();
			}
	}
}


//RenderBottomPart = if you dont want the smalltabs on bottom
//								change to false
// showMotorPart = if you want to see the motor part change to true
//placeForWires = extra space for wires
// wireplaceWidth how long place for wires

module miniMotor(RenderBottomPart = true, showMotorPart = false, 
						placeForWires = true, wireplaceWidth = 3){


motorMagnify = 0.5;

// wjhitout flap
motorLenght = 26 + motorMagnify;
motorHeight = 6.8 + motorMagnify; 
motorWidth = 12 + motorMagnify;

// flap parts
flapThickness = 3.8;
flapLenght = 4.2 + motorMagnify;

// measurments for motorPart;
motorpartLenght = motorLenght - 14.7;
motorpartWidth = 8 + motorMagnify;

// measurments for the thin plastic area beside the motor
screwPlaceLenght = 6.6;
screwPlaceThickness = 3.1 + motorMagnify;

// screw hole info

screwPlacePos = 4.7;
screwPlacePos2 = 11.5;
screwPlacePos3 = 23.9;
screwFromSide = 1.8;
screwholeR = 1.8/2;


// measurment for the tabs at the top
tabOnTopPlace1 = motorLenght+0.7;
tabOnTopPlace1S = motorWidth-3.0;
tabOnTopPlace2 = 9;
tabOnTopPlace2S = 1.8;
tabOntopR = 2/2;
tabOnTopH = 1.4;


// measurments for the taps at the bottom
tabsAtBottomPlace1 = 14.9;
tabsAtBottomPlace1S = motorWidth-3;
tabsAtBottomPlace2 = 20.8;
tabsAtBottomPlace2S = 3; 
tabsAtBottomR = 2.6/2;
tabsAtBottomH = 0.7;

epsilon = 0.05;

// Shaft measurments
shaftR = 10/2;
shaftPos = 21.2;
shaftPosS = motorWidth-4.5;
shaftH = 2.5;




// make the motor
plasticPart();
if (showMotorPart){
	translate([epsilon ,motorpartWidth, motorHeight/2]){
			motorPart();
	}
}
if (placeForWires){
	placeForWires();
}




module placeForWires(){
	rotate([90,0,90])translate([motorpartWidth , motorHeight/2,
				-wireplaceWidth+epsilon ]){
			cylinder(wireplaceWidth,motorpartWidth/2, motorpartWidth/2, 
						$fn = 40);
		}
}


module plasticPart(){
	difference(){
		cube([motorLenght, motorWidth, motorHeight]);
		if (showMotorPart){
			translate([-epsilon, motorWidth- motorpartWidth,-epsilon/2]){
				// place for motorPart
				cube([motorpartLenght+epsilon , motorpartWidth+ epsilon,
					 motorHeight+ epsilon]);
			}
	    }
		// screwPlace beside motor 
		translate([-epsilon,-epsilon, screwPlaceThickness+ epsilon]){
			cube([screwPlaceLenght , motorWidth -motorpartWidth+ 2*epsilon, 
				motorHeight - screwPlaceThickness]);
		}
		
	}
	// flap
	translate([motorLenght-epsilon,0,motorHeight - flapThickness]){
		cube([flapLenght , motorWidth, flapThickness]);
	
	}
	// Tabs on top 
	translate([tabOnTopPlace1 ,tabOnTopPlace1S, motorHeight-epsilon]){
		cylinder(tabOnTopH,tabOntopR, tabOntopR/3, 
						$fn = 40);
	}
	translate([tabOnTopPlace2 ,tabOnTopPlace2S, motorHeight- epsilon]){
		cylinder(tabOnTopH,tabOntopR, tabOntopR/3, 
						$fn = 40);
	}
	//shaft
		translate([shaftPos ,shaftPosS, motorHeight-epsilon]){
			cylinder(shaftH ,shaftR , shaftR , 
						$fn = 40);
		}

	if (RenderBottomPart){
	// Tabs AtBottom
		translate([tabsAtBottomPlace1 ,tabsAtBottomPlace1S,
					 -tabsAtBottomH+epsilon]){
			cylinder(tabsAtBottomH,tabsAtBottomR , tabsAtBottomR , 
						$fn = 40);
		}
		translate([tabsAtBottomPlace2 ,tabsAtBottomPlace2S,
						 -tabsAtBottomH+ epsilon]){
			cylinder(tabsAtBottomH,tabsAtBottomR , tabsAtBottomR , 
						$fn = 40);
		}
	}
}


// motor part
module motorPart(){
if (showMotorPart)
	intersection(){
		rotate([90,0,90])translate([0,0, 0]){
			cylinder(motorpartLenght,motorpartWidth/2, motorpartWidth/2, 
						$fn = 40);
		}
		translate([0, -motorpartWidth/2, -motorHeight/2]){	
			cube([motorpartLenght+ epsilon, motorpartWidth, motorHeight]);
		}
	}
}
}