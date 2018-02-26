#include "LampController.hpp"
//
const int arraySize = 3;
// 
byte redLed = 11;
byte yellowLed = 10;
byte greenLed = 9;
// 
//int brightness = 0;    // how bright the LED is
byte byteRead = 0;
//int selectedLed = -1;
// 
byte leds[arraySize] = {redLed, yellowLed, greenLed};  
// 
//const char communicationProtocol = 'X';
 
// the setup routine runs once when you press reset
LampController::Controller controller(leds, arraySize);

void setup() {
  // declare pin 9 to be an output:
//  pinMode(redLed, OUTPUT);
//  pinMode(yellowLed, OUTPUT);
//  pinMode(greenLed, OUTPUT);
  Serial.begin(115200);
  Serial.flush();
}
 
// the loop routine runs over and over again forever
void loop() {
    while(Serial.available() > 0 ) {
      
        byteRead = Serial.read();

        controller.receivedByte(byteRead);
 
//        Serial.println(byteRead);
 
//        if ( byteRead == communicationProtocol ) {
//           Serial.println(sizeOfArray(leds));
//        }
 
//        if (selectedLed != -1) {
//          analogWrite(selectedLed, byteRead);
//          selectedLed = -1;
//        } else if ( byteRead < arraySize ) {
//          selectedLed = leds[byteRead];
//        }
    }
   //delay(50);
}
