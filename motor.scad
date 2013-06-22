//rotate([0,-90,0]){
//
	//motor(false);
//}

use <utils.scad>;

extraMotorSize =0.3;
N20MotorHeight = 10 + extraMotorSize;
N20MotorWidth = 12 + extraMotorSize;
N20MotorPartLenght = 15 + extraMotorSize;
N20GearPartLenght = 9 + extraMotorSize;
N20MotorLength = N20MotorPartLenght + N20GearPartLenght; 
N20MotorWireSpaceLen = 5;
N20MotorShaftDiameter = 3;
N20MotorShaftFlatDepth = 0.5;

//extraMotorSize = extra size when using as hole
//wireSpaceLenght = lenght of the space for wires behind motor
//placeForVires = if true there are place for wires... othervise not
//wallRemower =  parameter to remove thin walls if using as a hole 
//						set to zero if you want to print the motor
// centerAtAxis = if true, origo of motor will be where the axis exits the motor body.  Otherwise at the back of the motor.
// shaftCutout = cut space for shaft.  If false, will instead recreate the flat on the shaft.
// shaftSpacing = Spacing around shaft if it is cutout
module motor(placeForWires   = true, 
             wireSpaceLength = N20MotorWireSpaceLen, 
             wallRemover     = 0.1,
             centerAtAxis    = false,
             shaftCutout     = false, 
             shaftSpacing    = 0.5) {

    // Motor with these mesurments:
    // http://i1040.photobucket.com/albums/b403/guokunli/T2Q1irXhxaXXXXXXXX_649914550_conew1.jpg

     
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
    shaftHeight = N20MotorShaftDiameter - N20MotorShaftFlatDepth;
    shaftWidth = N20MotorShaftDiameter;

    



    // $fn value for cylinders
    fn = 40;

    epsilon = 0.01;

    // some calvculated parameters for easier use
    radiusW = width/2;
    radiusH = height/2;
    motorWhitoutShaftL = motorLenght+gearLenght+shaftRoot;

    // Allow centering at exit shaft position
    xOffs = centerAtAxis ? -motorWhitoutShaftL : 0;
    yOffs = 0;
    zOffs = centerAtAxis ? 0 : 0;
    translate([xOffs, yOffs, zOffs]) {
        if (placeForWires){
	        //place for wires
	        translate([-wireSpaceLength,-radiusW,-radiusW]){
		        cube([wireSpaceLength+epsilon, width, width]);
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

        translate([motorLenght-epsilon,-radiusW,-radiusH]){
	        cube([gearLenght+epsilon, width, height]);
           translate([gearLenght, radiusW, radiusH])rotate([0,90,0]){
		        cylinder(shaftRoot+epsilon, shaftRootR, shaftRootR, $fn = fn);
	        }   

        }

        // shaft

        translate([motorWhitoutShaftL - epsilon, 0, 0]){
            if (shaftCutout)  {
	            rotate([0,90,0]){
		            cylinder(shaftLenght + epsilon, r = shaftWidth/2 + shaftSpacing, $fn = fn);
	            }
            }
            else {
	            intersection(){
		            translate([0, -shaftWidth/2, -shaftWidth/2]){
			            cube([shaftLenght, shaftWidth, shaftHeight + epsilon]);
		            }
		            rotate([0,90,0]){
			            cylinder(shaftLenght + epsilon, r = shaftWidth/2, $fn = fn);
		            }
	            }
            }
        }
    }

}


module motorPulley(innerDiam = 10, outerDiam = 14, flatW = 3) {
    pulley(pulleyDiam = innerDiam, pulleyW = flatW, pulleyWallH = outerDiam - innerDiam, glap = 0.15, axleDiam = N20MotorShaftDiameter, axleFlatDepth = N20MotorShaftFlatDepth, wireHoleDiam = 2);
}
    


