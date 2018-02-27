#include "LampController.hpp"

// Command functions

LampController::Command LampController::Controller::convertToCommand(const byte value)
{
  switch(value)
  {
    case 150:
      return Command::getNumberOfLamps;
      break;

    case 160:
      return Command::getLampBrightness;
      break;

    case 170:
      return Command::setLampBrightness;
      break;

    case 198:
     return Command::sentinel;
     break;

    case 199:
      return Command::normal;
      break;

    default:
      Serial.println("Invalid command");
      return Command::normal;
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
  this->commandStage = CommandStage::started;
}

void LampController::Controller::readByte(const byte value)
{
  switch(this->mode)
  {
    case Command::normal:
      this->mode = this->convertToCommand(value);
      this->commandStage = CommandStage::started;
      break;

    case Command::getLampBrightness:
      if(this->commandStage == CommandStage::started)
      {
        this->indexForAnswer = value - this->indexCorrection;
        this->commandStage = CommandStage::finishedReading;
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
    case Command::getNumberOfLamps:
      this->getNumberOfLamps();
      break;

    case Command::getLampBrightness:
      this->getLampBrightness();
      break;
    
    default:
      Serial.println("Invalid execute");
      break;
  }
}

void LampController::Controller::receivedByte(const byte value)
{
	if(value == Command::sentinel)
	{
    this->executeCurrentCommand();
	}
  else
  {
    this->readByte(value);
  }
}

// Execute functions

void LampController::Controller::sendAnswer(const byte answer)
{
  byte newAnswer[2] = {answer, Command::sentinel};
  
  Serial.write(newAnswer, 2);
}

void LampController::Controller::sendAnswer(const byte answer[], const byte answerSize)
{
  const byte newAnswerSize = answerSize + 1;
  byte newAnswer[newAnswerSize];

  for(int i = 0; i < newAnswerSize - 1; ++i)
  {
    newAnswer[i] = answer[i];
  }

  newAnswer[newAnswerSize - 1] = Command::sentinel;

  Serial.write(newAnswer, newAnswerSize);
}

void LampController::Controller::getNumberOfLamps()
{
  this->sendAnswer(this->lampsArraySize);
  
  this->resetState();
}

void LampController::Controller::getLampBrightness()
{  
  if(this->indexForAnswer > -1 && this->indexForAnswer < this->lampsArraySize)
  {
    this->sendAnswer(this->lamps[this->indexForAnswer].brightness);
  }
  else
  {
    byte answer[this->lampsArraySize];
    
    for(int i = 0; i < this->lampsArraySize; ++i)
    {
      answer[i] = this->lamps[i].brightness;
    }

    this->sendAnswer(answer, this->lampsArraySize);
  }

  this->resetState();
}

void LampController::Controller::setLampBrightness()
{
  // not implemented
}

