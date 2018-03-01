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
