

use<utils.scad>
include<motor.scad>
include<nano.scad>

pallero();

// size is diameter of the creature
module pallero(size = 100, aspect = 0.92) {
    r = size / 2;
    footD = size*0.3;
    footH = 10;
    $fn = 50;
    
    gap = 1;
    
    eyeLedDiam = 3;
    eyeLedGap = 0.2;
    
    eyeSize = size*0.23;
    eyeLidSizeFactor = 0.9;
    eyeDistance = size*0.2;
    
    shellThickness = 2;
    visorThickness = 1;
    
    hollowSpaceAngle = 120;
    hollowerCubeTile = (hollowSpaceAngle - 90) /2;
    
    footZ = -r*aspect +footH*0.8;

    module eye(y, dia = eyeSize, eyeAspect = 1.3, cutout=false) {        
        if (cutout) {
            // Eyesocket
            scale([1, 1, eyeAspect])
                sphere(r=dia/2);
            // Pupils    
            translate([-dia/2, -y*eyeSize*0.05, 0])
                rotate([0, -90, 0]) {
                    cylinder(r=eyeLedDiam/2+eyeLedGap, h = 40, center=true);
                    translate([0, 0, 4])
                        cylinder(r1=eyeLedDiam/2+eyeLedGap+0.5, r2=eyeLedDiam/2+eyeLedGap+1, h = 40);
                }
        }
        else {
            // Fill
            scale([1, 1, eyeAspect])
                sphere(r=dia/2+1);
            // supports 
            translate([-dia/2, -y*eyeSize*0.05, 0])
                rotate([0, -90, 0])
                    cylinder(r=dia/2, h = size*0.7, center=true);
        }
    }

    difference() {
        union() {
            // Body
            difference() {
                scale([1,1,aspect])    
                    sphere(r);
                // Hollow out part of body
                intersection() {
                    for (a=[-hollowerCubeTile, hollowerCubeTile])
                        rotate([0, 45+a, 0])
                            translate([0, -size/2, 0])
                                cube([size/sqrt(2), size, size/sqrt(2)]);
                    scale([1,1,aspect])    
                        sphere(r-shellThickness);
                }

                // Foot    
                translate([0, 0, footZ-footH]){
	                cylinder(r = footD/2+gap, h = footH);
                }
            }

            // Foot    
            translate([0, 0, footZ-footH]){
	            cylinder(r = footD/2, h = footH);
            }

            // Eye support
            difference() {
                intersection() {
                    scale([1,1,aspect])    
                        sphere(r-shellThickness-visorThickness-1.5);
                    
                    for (y = [-1, 1]) {
                        translate([size*0.45, y*eyeDistance, 0])
                            eye(y, dia=eyeSize*1.3);
                    }
                }
    
                // Eyes        
                for (y = [-1, 1]) {
                    translate([size*0.45, y*eyeDistance, 0])
                        eye(y, dia=eyeSize*1.2, cutout=true);
                }
            }
        }
        
        
        #translate([-22, 0, 0]) {
            rotate([0, 90, 0]) {
                nano(center=true, usbConnectorCutoutLength = 20);
            }
        }

        // Axis rotational motor        
        #translate([0, 0, footZ]) {
            rotate([0, 90, 0]) {
                motor(centerAtAxis=true);
            }
        }
        
        // Eye motor
        #translate([0, 0, 0]) {
            rotate([0, 0, 90]) {
                motor(centerAtAxis=true);
            }
        }


        // Eye holes in outer shell
        for (y = [-1, 1]) {
            translate([size*0.45, y*eyeDistance, 0])
                eye(y, cutout=true);
        }

        // Eyelid visor cutouts TODO: work on these
        *translate([size*(1-eyeLidSizeFactor)/2, 0, 0])
            eyeVisor(size*eyeLidSizeFactor, aspect, cutout=true);
    }


    // Eyelids implemented visor style
    translate([size*(1-eyeLidSizeFactor)/2-1, 0, 0])
        eyeVisor(size*eyeLidSizeFactor, aspect, visorThickness, state=1/*clamp((timeOscilate(offset=0.5)-0.1)*2)*/);
 
}




module eyeVisor(dia, aspect, thickness = 1, gap = 1, state = 0.5, cutout = false, baseDia = 5) {
    a = 30;
    maxOpen = 30;
    axisDia = baseDia;
    axisLen = 10;
    
    module visorHalf(up = 1, state, extraGap = 0) {
        rotate([0, up*(a/2+state*maxOpen), 0])
            union() {
                for (y=[-1, 1]) {
                    translate([baseDia*2,y*(dia/2-3),0])
                        rotate([90*y, 0, 0])
                            cylinder(r=baseDia/2, h = axisLen);
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





