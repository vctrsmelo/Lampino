#include "LampController.hpp"

// Command functions

LampController::Command LampController::Controller::convertToCommand(const byte value)
{
  switch(value)
  {
    case 150:
      return getNumberOfLamps;
      break;

    case 160:
      return getLampBrightness;
      break;

    case 170:
      return setLampBrightness;
      break;

    case 198:
     return sentinel;
     break;

    case 199:
      return normal;
      break;

    default:
      Serial.println("Invalid command");
      return normal;
      break;
  }
}

// Controller Init

LampController::Controller::Controller(const byte lamps[], const byte arraySize)
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

// Controller command parsing

void LampController::Controller::resetState()
{
  this->indexForAnswer = -1;
  this->valueForAnswer = -1;
  this->mode = normal;
  this->commandStage = started;
}

void LampController::Controller::readByte(const byte value)
{
  switch(this->mode)
  {
    case normal:
      this->mode = this->convertToCommand(value);
      this->commandStage = started;
      break;

    case getLampBrightness:
      if(this->commandStage == started)
      {
        this->indexForAnswer = value;
        this->commandStage = finishedReading;
      }
      break;

    default:
      Serial.println("Invalid current");
      break;
  }
}

void LampController::Controller::executeCurrentCommand()
{
  switch(this->mode)
  {
    case getNumberOfLamps:
      this->sendNumberOfLamps();
      break;

    case getLampBrightness:
      this->sendLampBrightness();
      break;
    
    default:
      Serial.println("Invalid execute");
      break;
  }
}

void LampController::Controller::receivedByte(const byte value)
{
	if(value == sentinel)
	{
    this->executeCurrentCommand();
	}
  else
  {
    this->readByte(value);
  }
}

// Specific functions

void LampController::Controller::sendNumberOfLamps()
{
  byte answer[2] = {this->lampsArraySize, sentinel};
	Serial.write(answer, 2);
  
  this->resetState();
}

void LampController::Controller::sendLampBrightness()
{
  int correctedIndex = this->indexForAnswer - 200;
  
  if(correctedIndex > -1 && correctedIndex < this->lampsArraySize)
  {
    byte answer[2] = {this->lamps[correctedIndex].brightness, sentinel};
    
    Serial.write(answer, 2);
    
  } else {

    byte answer[this->lampsArraySize + 1];
    
    for(int i = 0; i < this->lampsArraySize; ++i)
    {
      answer[i] = this->lamps[i].brightness;
    }

    answer[this->lampsArraySize] = sentinel;

    Serial.write(answer, this->lampsArraySize + 1);
  }

  this->resetState();
}

