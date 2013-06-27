include <utils.scad>
include <motor.scad>


DragonAspect = 0.8;

SpinalCableDia = 11.5 + 0.2;

FinalDragonSmoothness = 200;


module motorCapsule(motorSpacing = 3, frontSpacing = 1, cutout = false) {
    w = N20MotorWidth + motorSpacing *2;
    l = N20MotorLength + motorSpacing + frontSpacing;
    h = N20MotorHeight + motorSpacing * 2;
    
    if (cutout) {
        motor(centerAtAxis = true, shaftCutout = true);    
    }
    else {
        difference() {
            translate([-l, -w/2, -h/2])
                cube([l, w, h]);
            motor(centerAtAxis = true, shaftCutout = true);    
        }
    }
}

module dragonCrossSection(w1 = 100, w2 = 100, l = 5, aspect = DragonAspect, smoothness = 40) {
    scale([1, aspect, 1])
        cylinder(r1 = w1/2, r2 = w2/2, h = l, $fn=smoothness);
}

