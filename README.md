# Setup
## Requirements
- Arduino IDE - https://www.arduino.cc/en/Main/OldSoftwareReleases
- iPhone app - Yet to be released
- or Xcode - https://itunes.apple.com/br/app/xcode/id497799835?l=en&mt=12
- Project code - https://github.com/vicmelo/Lampino.git
- 1 Arduino Uno
- 1 Protoboard
- 1 BLE Link Bee - Bluetooth component
- 3 Leds
- 4 Wires
- 3 330 ohm Resistors

## Arduino
![alt text](https://raw.github.com/vicmelo/Lampino/feature/SpeechRecognition/IMG_1826.JPG)
- In the Arduino, set up 3 jumpers in the 9th, 10th and 11th pins.
- Set up another jumper in the ground pin (GND).
- In the protoboard, connect the ground jumper in any column of the negative line .
- Set up the leds as shown in the image.
- Connect one of the remaining jumpers in the same line as one of the connectors of the leds as shown in the image.
- Do the same for the other 2 jumpers and other 2 leds.
- Connect one resistor in the same line as the ground jumper and in the same column as on of the leds connector.
- Do the same for the other resistors and leds.

## BLE Link
It is necessary to rename Ble Link in order to connect it to the app.
The complete instructions can be found here https://www.dfrobot.com/wiki/index.php/Bluno_SKU:DFR0267#Configure_the_BLE_through_AT_command
But basically what you'll have to do is:
- Connect the BLE link to your computer with an USB cable
- Open the Arduino IDE
- Go to Tools > Port > Make sure the correct board is selected
- Open the serial monitor - Tools > Serial Monitor
- Make sure the "No line ending" and "115200 baud" options are selected
- Type in 
```
+++
```
and hit send, you should see a message saying "Enter AT mode"
- Change the line ending option to "Both NL & CR"
- Type in 
```
AT+NAME=LAMPINO
```
to rename the bluetooth component and hit enter
- Type in 
```
AT+NAME=?
```
and hit enter to make sure you were able to rename the component successfully. You should be able to see LAMPINO on your monitor 

## Project
- Download the project https://github.com/vicmelo/Lampino.git
- Open the Arduino IDE
- Go to File > Open > Location_Where_You_Downloaded_The_Project > Lampino > Arduino > Lampino > Lampino.ino
- Connect the Arduino through an USB port
- Select your port on Tools > Port (It will probably be something ending with “Arduino/Genuino Uno") 
- Remove the two yellow jumpers shown in the image
![alt text](https://raw.github.com/vicmelo/Lampino/feature/SpeechRecognition/IMG_1825.JPG)
- Go to Sketch > Verify
- Go to Sketch > Upload
- After finished uploading, put the two yellow jumpers back and keep the Arduino connected.

## Iphone App - Coming soon
Download the iPhone app - Yet to be released - and open it. The app should automatically connect with the Arduino and it should show the three connected leds.

## Or Xcode
- Download Xcode - https://itunes.apple.com/br/app/xcode/id497799835?l=en&mt=12
- Go to File > Open > Location_Where_You_Downloaded_The_Project > Lampino > Lampino.xcodeproj
- Connect an iPhone through an USB port
- Go to Project > Build
- Go to Project > Run

The app should be installed in your iPhone and automatically connect with the Arduino. The app should show the three connected leds.

# Commands
## Format
Every command has one of the following formarts
```
Command Sentinel
```
or
```
Command Parameter Sentinel
```
or
```
Command Parameter Parameter Sentinel
```
Where each value should be a single byte. As you can see, every command should end with the sentinel, this way the board knows to not wait for further commands.
Every answer from the board will also end with the sentinel.

## Values
Every communication is read as a byte, so we reserve the following values:
- [0 - 100] - Brightness value
- [101 - 197] - Commands
- 198 - Sentinel
- 199 - Internal use, for "normal" state
- [200 - 255] - [Lamp Indexes](#LampIndex)

# <a name="LampIndex"></a> Lamp Indexing

The lamps are accessed adding 200 to them, so if the lamp array is as follows
```
lamps = [lampA, lampB, lampC]
```
To access ``lampB`` you'll send the code ``201``

# Read
## Number of Lamps - ``150`` ``Sentinel``
On connection send this command to receive the number of connected lamps
```
150 198
```
You'll receive one answer with the number of connected lamps

## Lamps Brightness
### For Every Lamp - ``160`` ``Sentinel``
To receive the brightness of every lamp, send
```
160 198
```
You'll receive an answer for each connected lamp with a value from 0 to 100

### For Specific Lamp - ``160`` ``Index`` ``Sentinel``
To receive the brightness of a specific lamp send the command followed by the [lamp index](#LampIndex), so:
```
160 201 198
```
Would send you the brightness from the second lamp in the array

# Write
## Change Lamp Brightness
### For Every Lamp - ``170`` ``Value`` ``Sentinel``
To change every lamp brightness you have to send the value between 0 and 100, so to have every lamp at half brightness you would send this
```
170 50 198
```

### For Specific Lamp - ``170`` ``Value`` ``Index`` ``Sentinel``
To change a lamp's brightness you have to send the value between 0 and 100 followed by the [index](#LampIndex) of the lamp. So to turn a Lamp off you would send something like this.
```
170 0 200 198
```
While to have it at half brightness you could send
```
170 50 200 198
```
