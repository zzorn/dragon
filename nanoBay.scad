include <nano.scad>;

bayWallT = 3;

bayWidth = nanoWidth + 2*bayWallT;
bayLenght = nanoLenght + 1.5*bayWallT;
bayHeight  = wholeHeight  - epsilon;

bayholeHeight  = pinsOnTopHeight + bayWallT - nanoThickness - epsilon;

nanoBay();

module nanoBay(){
	difference(){
		//bayBase
		cube([bayLenght, bayWidth, bayHeight]);
		// a nanoSized hole
		translate([bayWallT, bayWallT-epsilon, bayholeHeight- epsilon]){
			cube([nanoLenght+epsilon, nanoWidth+ 2*epsilon, bayholeHeight]);
		}
		// nanohole
		rotate([180])translate([bayWallT,-nanoWidth-bayWallT,
					 -wholeHeight+epsilon])	{
			nano();
		}
		// hole forvard and backvards
		translate([-epsilon, bayWallT-epsilon, bayholeHeight +bayWallT - epsilon]){
			cube([nanoLenght+epsilon+ 2* bayWallT, nanoWidth+ 2*epsilon, 
					bayholeHeight]);
		}
		translate([resetButtonFromE + resetButtonL,
					 nanoWidth + bayWallT -resetButtonFromS - resetButtonW, -epsilon]){
			cube([resetButtonL, resetButtonW , bayholeHeight]);
		}
	}
}