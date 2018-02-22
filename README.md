# Commands
## Format
Every command has one of the following formarts
```
Command
```
or
```
Command Parameter
```
or
```
Command Parameter Parameter
```
Where each value should be a single byte.

## Values
Every communication is read as a byte, so we reserve the following values:
- [0 - 100] - Brightness value
- [101 - 199] - Commands
- [200 - 255] - [Lamp Indexes](#LampIndex)

# <a name="LampIndex"></a> Lamp Indexing

The lamps are accessed adding 200 to them, so if the lamp array is as follows
```
lamps = [lampA, lampB, lampC]
```
To access ``lampB`` you'll send the code ``201``

# Read
## Number of Lamps - ``150``
On connection send this command to receive the number of connected lamps
```
150
```
You'll receive one answer with the number of connected lamps

## Lamps Brightness
### For Every Lamp - ``155``
To receive the brightness of every lamp, send
```
155
```
You'll receive an answer for each connected lamp with a value from 0 to 100

### For Specific Lamp - ``155`` ``Index``
To receive the brightness of a specific lamp send the command followed by the [lamp index](#LampIndex), so:
```
155 201
```
Would send you the brightness from the second lamp in the array

# Write
## Change Lamp Brightness
### For Every Lamp - ``190`` ``Value``
To change every lamp brightness you have to send the value between 0 and 100, so to have every lamp at half brightness you would send this
```
190 50
```

### For Specific Lamp - ``190`` ``Value`` ``Index``
To change a lamp's brightness you have to send the value between 0 and 100 followed by the [index](#LampIndex) of the lamp. So to turn a Lamp off you would send something like this.
```
190 0 200
```
While to have it at half brightness you could send
```
190 50 200
```
