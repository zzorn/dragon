
frontMouthWidth = 20;
mouthLenght = 40;
botJawHeight = 20;

javAxelY = mouthLenght+ 3;
javAxelZ = botJawHeight-4;

bitWidth = 5;
bitHeight = 2.5;


// alahuuli etu
translate([-frontMouthWidth/2, 0, 0]){
	cube([frontMouthWidth, bitWidth, bitHeight]);
} 
// alahuulet sivu
translate([-frontMouthWidth/2, 0, 0]){
	cube([bitWidth, mouthLenght, bitHeight]);
} 
translate([frontMouthWidth/2-bitWidth, 0, 0]){
	cube([bitWidth, mouthLenght, bitHeight]);
} 
// alaleukaluu viistosti ylos
translate([frontMouthWidth/2-bitWidth, mouthLenght , 0])rotate([75]){
	cube([bitWidth, botJawHeight, bitHeight]);
} 
translate([-frontMouthWidth/2, mouthLenght , 0])rotate([75]){
	cube([bitWidth, botJawHeight, bitHeight]);
} 
// botJaw Axelplace
translate([-frontMouthWidth/2, javAxelY , javAxelZ ]){
	cube([frontMouthWidth, bitWidth, bitWidth]);
} 
// alaleukaluu viistosti ylos
translate([frontMouthWidth/2-bitWidth, mouthLenght ,javAxelZ])rotate([-75, 20, 0]){
	#cube([bitWidth, botJawHeight, bitHeight]);
} 
translate([-frontMouthWidth/2, mouthLenght , javAxelZ])rotate([-75, -20, 0]){
	#cube([bitWidth, botJawHeight, bitHeight]);
}






	//cylinder(10 ,20,20  , $fn = 40);