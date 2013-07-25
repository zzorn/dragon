

include<utils.scad>
include<motor.scad>
include<nano.scad>
use<battery.scad>
use<motorcontroller.scad>
use<palleroFoot.scad>

splitAlongZ0(xOffset=70, yOffset=70)
    rotate([90, 0, 0])
        pallero(preview=true);
        
translate([50, -50, 0])        
    foot();

// size is diameter of the creature
module pallero(size = 100, aspect = 0.92, preview = false) {
    r = size / 2;
    footD = size*0.3;
    footH = 10;
    $fn = 100;
    
    gap = 1;
    holeGap = 0.2;
    
    eyeLedDiam = 3;
    eyeLedGap = 0.2;
    
    eyeSize = size*0.25;
    eyeLidSizeFactor = 0.9;
    eyeDistance = size*0.2;
    pupilPlace = 0.1;
    irPupilPlace = -0.4;
    irPupilPlaceZ = -0.6;
    
    shellThickness = 2;
    visorThickness = 1;
    
    hollowSpaceAngle = 120;
    hollowerCubeTile = (hollowSpaceAngle - 90) /2;
    
    eyeVisorAxisDia = 25;
    eyeVisorAxisLen = 5;
    eyeVisorX = size*(1-eyeLidSizeFactor)/2-1;
    eyeVisorAxisHoleDia = 3;
    
    touchSensorHoleDia = 3;
    
    boltRelPos = [[-0.3, -0.21], [0.35, 0.25]];
    boltLen=size*0.3;
    
    footZ = -r*aspect +footH*0.8;

    module eye(y, dia = eyeSize, eyeAspect = 1.3) {        
        // Eyesocket
        scale([1, 1, eyeAspect])
            sphere(r=dia/2);
        // Pupils    
        translate([-dia/2, -y*eyeSize*pupilPlace, 0])
            rotate([0, -90, 0]) {
                cylinder(r=eyeLedDiam/2+eyeLedGap, h = 40, center=true);
                translate([0, 0, 2])
                    cylinder(r1=eyeLedDiam/2+eyeLedGap+0.5, r2=eyeLedDiam/2+eyeLedGap+1, h = 40);
            }
            
        // IR sender    
        translate([-dia/2, -y*eyeSize*irPupilPlace, eyeSize*irPupilPlaceZ])
            rotate([0, -90, 0]) {
                cylinder(r=eyeLedDiam/2+eyeLedGap, h = 40, center=true);
                translate([0, 0, 0])
                    cylinder(r1=eyeLedDiam/2+eyeLedGap+0.5, r2=eyeLedDiam/2+eyeLedGap+1, h = 40);
            }
    }

    difference() {
        union() {
            // Body
            difference() {
                scale([1,1,aspect])    
                    sphere(r);
                // Hollow out part of body
                *intersection() {
                    for (a=[-hollowerCubeTile, hollowerCubeTile])
                        rotate([0, 45+a, 0])
                            translate([0, -size/2, 0])
                                cube([size/sqrt(2), size, size/sqrt(2)]);
                    scale([1,1,aspect])    
                        sphere(r-shellThickness);
                }

                // Foot    
                translate([0, 0, footZ-footH]){
	                cylinder(r = footD/2+gap, h = footH+gap*3);
                }
            }

            // Foot    
            translate([0, 0, footZ-footH]){
	            *cylinder(r = footD/2, h = footH);
            }

        }
        
        union() {
            translate([-25, 0, 0]) {
                rotate([0, 90, 0]) {
                    nano(center=true, usbConnectorCutoutLength = 30);
                }
            }
            translate([10,0,10])
                rotate([90, 0, 0])
                    motorcontroller(useScrews=false);

            // Axis rotational motor        
            translate([0, 0, footZ]) {
                rotate([0, 90, 0]) {
                    motor(centerAtAxis=true);
                }
            }
            
            for (y = [-1, 1]) {
                translate([size*0.45, y*eyeDistance, 0])
                    eye(y, dia=eyeSize, cutout=true);
            }
            
            // Space for electronics
            difference() {
                scale([1,1,aspect])
                    sphere(r=size*0.46);
                translate([size*0.8,0,0])
                    cube([size, size, size], center=true);
                translate([0,0,-25])
                    cube([15, 20, 24], center=true);
                translate([0,0,-size*0.83])
                    cube([size, size, size], center=true);

                // Foot    
                translate([0, 0, footZ-footH]){
	                cylinder(r = footD/2+gap, h = footH+gap*3);
                }

                // Fot position sensor support
                translate([-11,0,-size*0.35])
                    cube([7, 14, 10], center=true);
                    
                // Bolt support
                for (pos = boltRelPos) {
                    translate([-size*pos[0], 0, -size*pos[1]])
                        rotate([90,0,0])
                            cylinder(r=8/2, h=size, center=true);
                }
            }

            // Hole for foot position sensor
            translate([-11,0,-size*0.35])
                cube([5.5, 10, 15], center=true);

            // Battery space
            translate([0, 0, -5])
                rotate([0, 0, 0])
                    battery(cutout=true);
                    
            // Touch sensor holes
            translate([-size/2, 0, 0])
                rotate([0,90,0])
                    cylinder(r=touchSensorHoleDia/2, h = 20, center=true);
            translate([size/2, 0, 0])
                rotate([0,90,0])
                    cylinder(r=touchSensorHoleDia/2, h = 60, center=true);
            translate([0, 0, size/2])
                rotate([0,0,0])
                    cylinder(r=touchSensorHoleDia/2, h = 20, center=true);
            translate([0, size/2, 0])
                rotate([90,0,0])
                    cylinder(r=touchSensorHoleDia/2, h = 20, center=true);
            translate([0, -size/2, 0])
                rotate([90,0,0])
                    cylinder(r=touchSensorHoleDia/2, h = 20, center=true);
                    
            // Bolt holes
            for (pos = boltRelPos) {
                translate([-size*pos[0], -boltLen/2, -size*pos[1]])
                    rotate([90,0,0])
                        bolt(M3, len = boltLen, nutDepth = 50, boltDepth = 50);
            }
        
        }

            
    }


    if (preview) {
        translate([0, 0, footZ-footH]){
            foot();
        }
    }
 
}




module eyeVisor(dia, aspect, thickness = 1, gap = 1, state = 0.5, cutout = false, baseDia = 5, eyeVisorAxisDia = 25, eyeVisorAxisLen = 5, eyeVisorAxisHoleDia=3) {
    a = 30;
    maxOpen = 30;
    axisDia = eyeVisorAxisDia;
    axisLen = eyeVisorAxisLen;    
    
    module visorHalf(up = 1, state, extraGap = 0) {
        rotate([0, up*(a/2+state*maxOpen), 0])
            union() {
                difference() {
                    for (y=[-1, 1]) {
                        translate([baseDia*2,y*(dia/2-1+up*2),0])
                            rotate([90*y, 0, 0])
                                cylinder(r=baseDia/2, h = axisLen);
                        translate([0,y*(dia/2-1+up*5),0])
                            rotate([90*y, 0, 0])
                                cylinder(r=axisDia/2, h = axisLen);
                    }
                    rotate([90, 0, 0])
                        cylinder(r=eyeVisorAxisHoleDia/2+0.2, h=dia+10, center=true);
                }
                intersection() {
                    hollowSphereSector(dia-thickness-gap-thickness+extraGap, thickness+extraGap*2, a);
                    union() {
                        translate([baseDia*1.9,-dia/2,-dia/2])
                            cube(dia);
                        translate([baseDia*2,0,0])
                            rotate([90, 0, 0])
                                cylinder(r=baseDia/2, h = dia, center=true);
                    }
                }
            }
    }
    
    if (cutout) {
        for (z = [-1, 1]) {
            visorHalf(z, state = 0, extraGap = gap);
            visorHalf(z, state = 1, extraGap = gap);
        }
    }
    else {
        for (z = [-1, 1]) {
            visorHalf(z, state = state);
        }
    }
    
    
    
    
}

// Note: angle can be max 180.
module hollowSphereSector(dia, thickness = 1, angle = 90) {
    aa = 180 - angle;
    r = dia/2;

    module lidCut(a) {
        translate([0, r, 0])
            rotate([0, 180+90+a, 0]) {
                translate([-r*2, -r*2, 0])
                    cube(r*2*2);
            }
    }

    difference(){
        // Base
        sphere(r=r);
        
        // Cutout
        sphere(r=r-thickness);
        
        // Cut sector
        lidCut(-aa/2);
        lidCut(aa/2);
    }

}





