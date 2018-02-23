#include "LampController.hpp"

LampController::LampController::LampController(const byte lamps[], const byte arraySize)
{
	this->lampsArraySize = arraySize;

    for (int i = 0; i < arraySize; ++i)
    {
    	Lamp newLamp;
    	newLamp.pin = lamps[i];
    	newLamp.brightness = 0;

    	this->lamps[i] = newLamp;
    }
}

LampController::Command LampController::LampController::convertToCommand(byte value)
{
  switch(value)
  {
    case 150:
      return getNumberOfLamps;
      break;

    case 155:
      return getLampBrightness;
      break;

    case 160:
      return setLampBrightness;
      break;

    case 255:
    default:
      return normal;
  }
}

void LampController::LampController::received(const byte command)
{
	switch(this->mode)
	{
		case normal:
			this->mode = this->convertToCommand(command);
			break;

		case getNumberOfLamps:
			this->sendNumberOfLamps();
      break;
		
		default:
      break;
	}
}

void LampController::LampController::sendNumberOfLamps()
{
	Serial.write(this->lampsArraySize);
}
