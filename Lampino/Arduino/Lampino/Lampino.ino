int led = 11;           // the PWM pin the LED is attached to
int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by
uint8_t byteRead = 0;
bool readBrightCommand = false;

// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(led, OUTPUT);
  Serial.begin(115200);
  Serial.flush();
}

// the loop routine runs over and over again forever:
void loop() {

    if(Serial.available() > 0 ) {
        byteRead = Serial.read();
//        Serial.flush();
//        analogWrite(led, byteRead);

      Serial.println(byteRead);
    
      if ( readBrightCommand == true ) {
        analogWrite(led, byteRead);
        readBrightCommand = false;
      }

      if ( byteRead == 0 ) {
        readBrightCommand = true;
      }
//        if (byteRead >= 0 && byteRead <= 255) {
//          analogWrite(led, byteRead);
//        }
    }
   delay(50);
}
