#include <CapSense.h>

#include <CapSense.h>

#include <CapSense.h>

/* 
* CapitiveSense Library Demo Sketch
* Paul Badger 2008
* Slightly adapted by Bare Conductive 2011 
* Uses a high value resistor e.g. 10 megohm between send pin and receive pin
* Resistor effects sensitivity, experiment with values, 50 kilohm - 50 megohm. Larger resistor values yield larger sensor values.
* Receive pin is the sensor pin - try different amounts of Bare Paint
* Best results are obtained if sensor foil and wire is covered with an insulator such as paper or plastic sheet
*/


CapSense   cs_4_2 = CapSense(4,2);         // 10 megohm resistor between pins 4 & 2, pin 2 is sensor pin, add Bare Paint
// CapSense   cs_4_5 = CapSense(4,5);          // OPTIONAL: for sensor 2, 10 megohm resistor between pins 4 & 6, pin 6 is sensor pin, add Bare Paint
// CapSense   cs_4_8 = CapSense(4,8);          // OPTIONAL: for sensor 3, 10 megohm resistor between pins 4 & 8, pin 8 is sensor pin, add Bare Paint

void setup()                 
{
   cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example   
   Serial.begin(9600);
}

void loop()                    

{    
long start = millis();    
long total1 =  cs_4_2.capSense(30);   
// long total2 =  cs_4_5.capSense(30);     // OPTIONAL for sensor 2   
// long total3 =  cs_4_8.capSense(30);    // OPTIONAL for sensor 3      

// Serial.print(millis() - start);                      // OPTIONAL: check on performance in milliseconds   
// Serial.print(" ");                                     // OPTIONAL: tab character for debug windown spacing

Serial.println(total1);                                // OPTIONAL: To use additional sensors,change Serial.println to Serial.print for proper window spacing    
//Serial.print(" ");                               // OPTIONAL: tab character for window spacing for sensor output 2    
//Serial.print(total2);                           // OPTIONAL: print sensor output 2    
//Serial.print(" ");                               // OPTIONAL: tab character character for sensor output 3    
//Serial.println(total3);                       // print sensor output 3

delay(10);                                          // arbitrary delay to limit data to serial port 
} 

 

