rotate([0,-90,0]){

	motor(false);
}


module motor(placeForVires = true, wireSpaceLenght = 5){

// Motor whit these mesurments
//http://i1040.photobucket.com/albums/b403/guokunli/T2Q1irXhxaXXXXXXXX_649914550_conew1.jpg

// width of motor
width = 12;
// height of motor
height = 10;
// lenght of the motor part
motorLenght = 15;
// lenght of the gear part
gearLenght = 9;
// tickness and radius of the root of the shaft
shaftRoot = 1;
shaftRootR = 2;
// lenght height and widt of the shaft
shaftLenght = 10;
shaftHeight = 2.5;
shaftWidth = 3;

// $fn value for cylinders
fn = 40;

// some calvculated parameters for easier use
radiusW = width/2;
radiusH = height/2;
motorWhitoutShaftL = motorLenght+gearLenght+shaftRoot;

if (placeForVires){
	//place for wires
	translate([-wireSpaceLenght,-radiusW,-radiusW]){
		cube([wireSpaceLenght, width, width]);
	}
}
 
// motor part

intersection(){
	rotate([90,0,90]){
		cylinder(motorLenght,radiusW, radiusW, $fn = fn);
	}
	translate([0, -radiusW, -radiusH]){	
		cube([motorLenght, width, height]);
	}
}

//gear part

translate([motorLenght,-radiusW,-radiusH]){
	cube([gearLenght, width, height]);
   translate([gearLenght, radiusW, radiusH])rotate([0,90,0]){
		cylinder(shaftRoot, shaftRootR, shaftRootR, $fn = fn);
	}   

}

// shaft

translate([motorWhitoutShaftL, 0, 0]){
	intersection(){
		translate([0, -shaftWidth/2, -shaftWidth/2]){
			cube([shaftLenght, shaftWidth, shaftHeight]);
		}
		rotate([0,90,0]){
			cylinder(shaftLenght, shaftWidth/2, shaftWidth/2, $fn = fn);
		}
	}
}

}
