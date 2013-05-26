
Tau = 6.28318530717958647692;

function clamp(value, minValue, maxValue) = max(minValue, min(maxValue, value));
function mix(pos, start, end) = start + pos * (end -start);
function map(pos, srcStart, srcEnd, start, end) = start + ((pos-srcStart) / (srcEnd-srcStart)) * (end - start);

function smoothmix(pos, start, end) = start + (0.5-cos(pos*360/2) * 0.5 ) * (end - start);
function smoothmap(pos, srcStart, srcEnd, start, end) = start + smoothmix( (pos-srcStart) / (srcEnd - srcStart), 0, 1) * (end - start);

module horn(length = 50, angle = 45, r1 = 15, r2 = 5, aspect1 = 1, aspect2 = 1, ballStart = true, ballEnd = true, smoothness = 30, maxSegments = 30) {
    a = angle * 0.5;
    minSegments = 4;
    segments = clamp(length * 1, minSegments, maxSegments);
    segLen = 1.0*length / segments;
    segRot = a / segments;
    segLen = (length / segments) * map(a, 0, 90, 1.75, 2.5);

    for ( i = [0 : segments] ) {
        rotate([map(i, 0, segments, 0, a),0,0])
            translate([0,0,map(i, 0, segments, 0, length)])
                rotate([map(i, 0, segments, 0, a*map(a, 0, 90, 1, 0.65)),0,0])
                    scale([smoothmap(i, 0, segments, aspect1, aspect2), 1, 1])
                        cylinder(h = segLen, r1 = map(i, 0, segments+1, r1, r2), r2 = map(i + 2, 0, segments+1, r1, r2), $fn=smoothness);
    }

    if (ballStart) {
        scale([aspect1, 1, 1])
            sphere(r=r1, $fn=smoothness);
        
    }

    if (ballEnd) {
        rotate([a,0,0])
            translate([0,0,length])
                rotate([a*map(a, 0, 90, 1, 0.65),0,0])
                    scale([aspect2, 1, 1])
                        translate([0, 0, segLen])
                            sphere(r=map(segments + 2, 0, segments+1, r1, r2), $fn=smoothness);
        
    }
}

module doubleHorn(l1 = 50, l2 = 30, a1 = 30, a2 = 20, r1 = 5, r2 = 15, r3 = 10, aspect1 = 1, aspect2 = 1, aspect3 = 1, ballStart = true, ballEnd = true, smoothness = 30, , maxSegments = 30) {
    horn(l1, a1, r2, r1, aspect2, aspect1, true, ballStart, smoothness, maxSegments);
    rotate([0, 180, 0])
        horn(l2, a2, r2, r3, aspect2, aspect3, false, ballEnd, smoothness, maxSegments);
}

module cutPlane(size = 1000) {
    translate([-size/2, -size/2, -size])
        cube([size, size, size]);
}

module roundedAngle(a = 90, r = 10, l = 40, h = 5, rot = 0, extraThickness = 0) {
    rotate([0,0,rot]) {
        cylinder(h, r = r, $fn=40);
        rotate([0,0,a/2]) {
            translate([-r + h/2, 0, 0]) {
                cube([r + extraThickness, l, h]);
                translate([0, 0, h/2])
                    rotate([-90,0,0])
                        cylinder(h=l, r = h/2, $fn=40);
            }
        }            
        rotate([0,0,-a/2]) {
            translate([-extraThickness - h/2, 0, 0]) {
                cube([r + extraThickness, l, h]);
                translate([r + extraThickness, 0, h/2])
                    rotate([-90,0,0])
                        cylinder(h=l, r = h/2, $fn=40);
            }
        }
    }
}


module splitAlongZ0(xOffset = 30, yOffset = 30, cutSize = 1000) {

    difference() {
        translate([-xOffset/2, -yOffset/2, 0])
            child(0);
        cutPlane(cutSize);
    }    

    difference() {
        translate([xOffset/2, yOffset/2, 0])
            rotate([0, 180, 0])
                child(0);
        cutPlane(cutSize);
    }       
}


// Fastening knob holes - use pieces of filament to fasten
module knob(knobH = 8, knobD = 3, hole = true) {
    glap = 0.6;

    if (hole) {
        translate([0,0,-knobH/2]) cylinder(h = knobH+glap/2, r = knobD/2+glap/4, $fn=20);
        //cube([knobD, knobD, knobH], center = true);
    }
    else {
        cylinder(h = knobH - glap/2, r = knobD/2 - glap/4, $fn=20);
        //cube([knobD - glap, knobH - glap, knobD - glap]);
    }
}

module cylinderTorus(h, outerR, innerR, center = false, smoothness = 30) {
    difference() {
        cylinder(h = h, r = outerR, center = center, $fn=smoothness);
        translate([0,0,-1])
            cylinder(h = h+2, r = innerR, center = center, $fn=smoothness);
    }
}

// Draws a line from start to start + offset.
module lineRel(start, offset, startDiam = 5, endDiam = 5, aspect = 1, roundedStart = true, roundedEnd = true, smoothness = 30) {
    line(start, start + offset, startDiam, endDiam, aspect, roundedStart, roundedEnd, smoothness);
}

// Draws a line from start to end.
module line(start, end, startDiam = 5, endDiam = 5, aspect = 1, roundedStart = true, roundedEnd = true, smoothness = 30) {

    x = end[0] - start[0];
    y = end[1] - start[1];
    z = end[2] - start[2];
    
    len = sqrt(x*x + y*y + z*z);

    yRot = acos(z / (len + 0.000001)); // Add small value to avoid crash if length is zero
    zRot = atan2(y, x);

    if (len <= 0) {
        // In case we have zero length line, only render end blob if activated
        if (roundedEnd || roundedStart) {
            scale([1,1,aspect]) {
                sphere(r=max(startDiam/2,endDiam/2), $fn = smoothness);
            }
        }
    }    
    else {
        translate(start) {
            rotate([0, 0, zRot])
                rotate([0, yRot, 0]) {
                    // Aspect ratio scaling
                    scale([aspect,1,1]) { 
                        // Rounded start
                        if (roundedStart) {
                            sphere(r=startDiam/2, $fn = smoothness);
                        }
                        
                        // Line
                        cylinder(h=len, r1=startDiam/2, r2 = endDiam/2, $fn = smoothness);
                        
                        // Rounded end
                        if (roundedEnd) {
                            translate([0, 0, len])
                                sphere(r=endDiam/2, $fn = smoothness);
                        }
                    }                
                }
        }
    }


}

//line([-20, -20, -30], [30, 20, 20], startDiam = 20, endDiam = 50, aspect=0.5, roundedEnd=false);
//roundedAngle();
// horn();
//doubleHorn();



