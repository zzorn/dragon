
include <utils.scad>
include <motor.scad>
use <wing.scad>

body();

module motorCapsule(motorSpacing = 3, frontSpacing = 1) {
    w = N20MotorWidth + motorSpacing *2;
    l = N20MotorLength + motorSpacing + frontSpacing;
    h = N20MotorHeight + motorSpacing * 2;
    difference() {
        translate([-l, -w/2, -h/2])
            cube([l, w, h]);
        motor(centerAtAxis = true, shaftCutout = true);    
    }
}

module tentacleBase(diam = 80) {
    pulleyLen = 15;
    pulleyDiam = 14;
    motorSpacing = 3;
    pulleySpacing = 1;
    motorZOffs = diam/2 - max(pulleyDiam/2, N20MotorHeight/2) - motorSpacing - 5;

    module stringMotor() {
        translate([0, 0, 0]) {
            // Motor space
            translate([0, pulleySpacing, 0])
                rotate([0, 0, 270]) 
                    motorCapsule(motorSpacing = motorSpacing);    

            // Pulley
            rotate([90, 0, 0]) 
                motorPulley(outerDiam = pulleyDiam);
        }
    }

    translate([0, 20, 0]) {
        for (z = [-1, 1])
            translate([0,0,z*motorZOffs])
                stringMotor();
    }

    rotate([-90, 0, 0])
        cylinder(h = 5, r = diam/2);
        
}

module body(bodyLen = 160, tray = false) {


    module tailBase() {
        tentacleBase();
    }

    module neckBase() {
        mirror([0, 1, 0]) tentacleBase();
    }


    translate([0, bodyLen/2, 0]) neckBase();

    wingBase(tray = tray);
    
    translate([0, -bodyLen/2, 0]) tailBase();

}








