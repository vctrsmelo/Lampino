#include "LampController.hpp"

byte redLed = 11;
byte yellowLed = 10;
byte greenLed = 9;

const int arraySize = 3;
byte leds[arraySize] = {redLed, yellowLed, greenLed};  

LampController::Controller controller(leds, arraySize);

byte byteRead = 0;

void setup() {
  Serial.begin(115200);
  Serial.flush();
}
 
// the loop routine runs over and over again forever
void loop() {
    while(Serial.available() > 0 ) {
        controller.receivedByte(Serial.read());
    }
}
