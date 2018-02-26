#ifndef _LAMP_CONTROLLER_H_
#define _LAMP_CONTROLLER_H_

#include "HardwareSerial.h"

namespace LampController
{
    typedef unsigned char byte;
    
    static const byte MAX_SIZE = 10;

    struct Lamp
    {
    	byte pin;
    	byte brightness;
    };
	
	enum Command: byte
	{
		normal = 255,

    sentinel = 254,

		getNumberOfLamps = 150,
		getLampBrightness = 155,

		setLampBrightness = 190
	};

	class LampController
	{
        private:
        Lamp lamps[MAX_SIZE];
        byte lampsArraySize;

        Command mode = normal;

        Command convertToCommand(byte value);
        void sendNumberOfLamps();

        public:
		    LampController(const byte lamps[], const byte arraySize);
		    void received(const byte command);
	};

}

#endif // _LAMP_CONTROLLER_H_
