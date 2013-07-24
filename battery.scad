
extrasize = 0.3;
extraInEnd = 2;
// 70 are batteruy lenght lenght is battery holes lenght
lenght = 70 + extrasize + extraInEnd;
// battery dia
dia = 18.3 + extrasize;
wallT = 2;
minusEndL = 3;
plusEndL = 5
epsilon = 0.001;
wireholeR = 2;


// case
translate([-dia/2-wallT,-lenght/2,0]) %cube([dia+2*wallT,  lenght ,3/5*dia + wallT]);
//minusend of case
translate([-dia/2-wallT,-lenght/2 -minusEndL,0]) %cube([dia+2*wallT,  minusEndL+epsilon ,dia + wallT]);

// battery
translate([0,lenght/2, dia/2+wallT]) rotate([90]) cylinder(lenght, r= dia/2);

// wireHole
//translate([0,lenght, dia/2+wallT]) rotate([90]) cylinder(2*lenght, r= wireholeR);
