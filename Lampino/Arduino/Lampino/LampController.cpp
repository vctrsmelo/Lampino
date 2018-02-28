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
      else
      {
        Serial.println("Invalid current");
      }
      break;

    case Command::setLampBrightness:
      switch(this->commandStage)
      {
        case CommandStage::started:
          this->valueForAnswer = value;
          this->commandStage = CommandStage::readSomething;
          break;

         case CommandStage::readSomething:
          this->indexForAnswer = value - this->indexCorrection;
          this->commandStage = CommandStage::finishedReading;
          break;

         case CommandStage::finishedReading:
           Serial.println("Invalid current");
           this->resetState();
           break;
      }
      break;

    default:
      Serial.println("Invalid current");
      this->resetState();
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

    case Command::setLampBrightness:
      this->setLampBrightness();
      break;
    
    case Command::normal:
    case Command::sentinel:
      Serial.println("Invalid execute");
      this->resetState();
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

// Execute functions helpers

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

void LampController::Controller::setLampBrightness(const byte index, const byte brightness)
{
  Lamp lamp = this->lamps[index];
  lamp.brightness = brightness;
  
  analogWrite(lamp.pin, lamp.brightness);
  
  this->lamps[index] = lamp;
}

bool LampController::Controller::isValidIndex()
{
  return this->indexForAnswer > -1 && this->indexForAnswer < this->lampsArraySize;
}

bool LampController::Controller::isValidValue()
{
  return this->valueForAnswer > -1 && this->valueForAnswer < 101;
}

// Execute functions main functions

void LampController::Controller::getNumberOfLamps()
{
  this->sendAnswer(this->lampsArraySize);
  
  this->resetState();
}

void LampController::Controller::getLampBrightness()
{  
  if(this->isValidIndex())
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
  if(this->isValidIndex() && this->isValidValue())
  {
    this->setLampBrightness(this->indexForAnswer, this->valueForAnswer);
  }
  else if(this->isValidValue())
  {
    for(int i = 0; i < this->lampsArraySize; ++i)
    {
      this->setLampBrightness(i, this->valueForAnswer);
    }
  }
  else
  {
    Serial.println("Invalid brightness");
  }

  this->resetState();
}

