
include <utils.scad>
include <motor.scad>
include <dragonutils.scad>
use <spinebase.scad>
use <wing.scad>


body();



module body(bodyLen = 130, tray = false, showMotionAreas = true) {


    module tailBase() {
        rotate([90, 0, 0]) spineBase();
    }

    module neckBase() {
        mirror([0,1,0]) rotate([90, 0, 0]) spineBase();
    }


    translate([0, bodyLen/2, 0]) neckBase();

    if (showMotionAreas && !tray) {
        for (a = [0 : 0.25 : 1])
            for (b = [0 : 0.25 : 1])
                wingBase(testTilt = a, testLocation = b);
    }
    else {
        wingBase(tray = tray);
    }
    
    translate([0, -bodyLen/2, 0]) tailBase();

}








