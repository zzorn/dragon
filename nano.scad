// nano

// extrasize for printing
extraSize = 0.3;


// the board size
nanoWidth     = 17.8 + extraSize;
nanoLenght    = 43.3 + extraSize;
nanoThickness = 1.6 + extraSize;

// usb port measurments
usbHeight      = 4 + extraSize;
usbWidth       = 7.5 + extraSize;
usbLenght      = 9.3 + extraSize;
usbInsideBoard = 6.8 + extraSize/2;

// pins on top measurments
pinsOnTopHeight = 9 + extraSize;
pinsOnTopWidth  = 7.9 + extraSize;
pinsOnTopLenght = 5 + extraSize ;

// pinbase on top measurments
pinBaseOnTopH = 2.4 + extraSize;
pinBaseOnTopW = 2 + extraSize;

// debugLeds
ledsOnTopH       = 1 + extraSize;
ledsOnTopL       = 3.7 + extraSize;
ledsOnTopFromEnd = 12.3;

// bottomPin measurments
botSidePinH       = 0;
botSidePinW       = 0;
botSidePinL       = 38.2 + extraSize;
botSidePinFromEnd =  2.5 - extraSize/2;

// resetButton
resetButtonL     = 2.9 + extraSize;
resetButtonH     = 1.8 + extraSize;
resetButtonW     = 4.0 + extraSize;
resetButtonFromS = 7.2 + extraSize/2;
resetButtonFromE = 17.3 + extraSize/2;

// microcontroller at top
microContrH     = 0.5 + extraSize;
microContrW     = 7.8 + extraSize;
microContrMidFromE = 27.7 - extraSize/2;
microContrMidFromS = 8.5 - 5.8 - extraSize/2;

//TODO little thing at top

// microcontrollerAtTop
translate([microContrMidFromE , microContrMidFromS ,nanoThickness])rotate([0, 0, 45]){
	cube([microContrW, microContrW, resetButtonH]);
}


// reset button
translate([resetButtonFromE , resetButtonFromS ,nanoThickness]){
	cube([resetButtonL, resetButtonW, microContrH]);
}

// leds on top
translate([ledsOnTopFromEnd, 0,nanoThickness]){
	cube([ledsOnTopL, nanoWidth, ledsOnTopH]);
}

// board
translate([0, 0,0]){
	cube([nanoLenght, nanoWidth, nanoThickness]);
}


// usbPort
translate([nanoLenght-usbInsideBoard, nanoWidth/2-usbWidth/2, nanoThickness]){
	cube([usbLenght, usbWidth, usbHeight]);
}

//pins on top
translate([0, nanoWidth/2-pinsOnTopWidth/2, nanoThickness]){
	cube([pinsOnTopWidth, pinsOnTopWidth, pinsOnTopHeight]);
}

// pin base on top
translate([botSidePinFromEnd, 0, nanoThickness]){
	cube([botSidePinL, pinBaseOnTopW, pinBaseOnTopH]);
}
translate([botSidePinFromEnd, nanoWidth-pinBaseOnTopW, nanoThickness]){
	cube([botSidePinL, pinBaseOnTopW, pinBaseOnTopH]);
}