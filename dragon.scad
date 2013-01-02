
dragon();

module dragon(width = 50, length = 300, wingspan = 300) {
    
    spacing = 10;
    
    
    // Body
    bodyLength = length * 0.3;        
    translate([-width/2,0,0]) {
        body(width, bodyLength);
    } 

    // Neck
    neckWidth = width * 0.4;
    neckLength = length * 0.4;
    neckSegments = 2;
    translate([-neckWidth/2, bodyLength + spacing, 0]) {
        neck(neckWidth, neckLength, neckSegments, spacing);
    }

    // Head
    headWidth = width * 0.5;
    headLength = length * 0.15;
    translate([-headWidth/2, bodyLength + spacing + neckLength + spacing*neckSegments, 0]) {
        head(headWidth, headLength);
    }
}



module body(width, length) {
    
    height = width * 0.5;

    cube([width,length,height]);
    
    
}

module neck(width, length, neckSegments, spacing) {
    segmentLength = length / neckSegments;
    for (segment = [1 : neckSegments]) {
        translate([0, (segment - 1) * (segmentLength+spacing), 0]) {
            neckSegment(width, segmentLength);
        }
    }
}

module neckSegment(width, length) {
    height = width * 0.8;
    
    boneH = width * 0.1;
    
    neckBone(width, length, boneH);
    
    translate([0,0,height - boneH]) {
        neckBone(width, length, boneH);
    }
}

module neckBone(w, l, h) {
    cube([w, l, h]);
}


module head(headWidth, headLength) {
    headHeight = headWidth * 0.5;
    cube([headWidth,headLength,headHeight]);
}




