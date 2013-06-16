//rotate([0,-90,0]){
//
	//motor(false);
//}
extraMotorSize =1;
N20MotorHeight = 10 + extraMotorSize;
N20MotorWidth = 12 + extraMotorSize;
N20MotorPartLenght = 15 + extraMotorSize;
N20GearPartLenght = 9 + extraMotorSize;


//extraMotorSize = extra size when using as hole
//wireSpaceLenght = lenght of the space for wires behind motor
//placeForVires = if true there are place for wires... othervise not
//wallRemower =  parameter to remove thin walls if using as a hole 
//						set to zero if you want to print the motor

module motor(placeForVires = true, wireSpaceLenght = 5, 
				 wallRemover = 0.1){

// Motor whit these mesurments
//http://i1040.photobucket.com/albums/b403/guokunli/T2Q1irXhxaXXXXXXXX_649914550_conew1.jpg



 
// width of motor
width = N20MotorWidth;
// height of motor
height = N20MotorHeight;
// lenght of the motor part
motorLenght = N20MotorPartLenght;
// lenght of the gear part
gearLenght = N20GearPartLenght;
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
	rotate([90,0,90])translate([0,0, -wallRemover]){
		cylinder(motorLenght+2*wallRemover,radiusW, radiusW, $fn = fn);
	}
	translate([-wallRemover, -radiusW, -radiusH]){	
		cube([motorLenght+2*wallRemover, width, height]);
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
