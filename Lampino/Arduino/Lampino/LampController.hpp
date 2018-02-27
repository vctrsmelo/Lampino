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
		normal = 199,

    sentinel = 198,

		getNumberOfLamps = 150,
   
		getLampBrightness = 160,
		setLampBrightness = 170
	};

  enum CommandStage
  {
    started, readSomething, finishedReading
  };

	class Controller
	{
        private:
        Lamp lamps[MAX_SIZE];
        byte lampsArraySize;

        Command mode = normal;
        CommandStage commandStage = started;

        byte indexCorrection = 200;

        int indexForAnswer = -1;
        int valueForAnswer = -1;

        Command convertToCommand(const byte value);

        void resetState();

        void readByte(const byte value);
        void executeCurrentCommand();

        void sendAnswer(const byte answer);
        void sendAnswer(const byte answer[], const byte answerSize);
        
        void getNumberOfLamps();
        void getLampBrightness();
        void setLampBrightness();

        public:
		    Controller(const byte lamps[], const byte arraySize);
		    void receivedByte(const byte value);
	};

}

#endif // _LAMP_CONTROLLER_H_
