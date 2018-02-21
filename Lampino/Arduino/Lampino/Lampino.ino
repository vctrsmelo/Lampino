int redLed = 11;
int yellowLed = 10;
int greenLed = 9;

int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by
uint8_t byteRead = 0;
int selectedLed = -1;

// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(redLed, OUTPUT);
  pinMode(yellowLed, OUTPUT);
  pinMode(greenLed, OUTPUT);
  Serial.begin(115200);
  Serial.flush();
}

// the loop routine runs over and over again forever:
void loop() {
    if(Serial.available() > 0 ) {
        byteRead = Serial.read();

        Serial.println(byteRead);

        if (selectedLed != -1 && byteRead >= 0 && byteRead <= 255) {
          analogWrite(selectedLed, byteRead);
          selectedLed = -1;
        }
  
        if ( byteRead == 'A' ) {
          selectedLed = redLed;
        }

        if ( byteRead == 'B' ) {
          selectedLed = greenLed;
        }

        if ( byteRead == 'C' ) {
          selectedLed = yellowLed;
        }
    }
   //delay(50);
}
