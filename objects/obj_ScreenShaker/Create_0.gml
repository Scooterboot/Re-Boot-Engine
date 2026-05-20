/// @description Initialize

active = false;

timeLeft = 0;
shakeStep = 0;
shakeStepDir = 1;
shakeX = 0;
shakeY = 0;

duration = 0;
shakeIntensity = 3;
shakeRate = 3;//2;

shakeCounter = 0;
shakeCounterMax = 0;

customShakeDir = undefined;
shakeDirection = 0;

function Shake(_duration, _shakeIntensity = 3, _shakeRate = 3, _customShakeDir = undefined, _shakeCounter = 2)
{
	///@description Shake
	///@param _duration
	///@param _shakeIntensity=3
	///@param _shakeRate=3
	///@param _customShakeDir=undefined
	///@param _shakeCounter=2
	
	if(!active || _duration > duration)
	{
		duration = _duration;
		shakeIntensity = _shakeIntensity;
		shakeRate = _shakeRate;
		customShakeDir = _customShakeDir;
		shakeCounterMax = _shakeCounter;
		
		active = true;
		timeLeft = 0;
	}
	else if((duration-timeLeft) < _duration && 
			duration == _duration &&
			shakeIntensity == _shakeIntensity && 
			shakeRate == _shakeRate &&
			customShakeDir == _customShakeDir &&
			shakeCounterMax == _shakeCounter)
	{
		timeLeft = 0;
	}
}