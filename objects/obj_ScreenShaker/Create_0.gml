/// @description Initialize

active = false;

timeLeft = 0;
shakeStep = 0;
shakeStepDir = 1;
shakeX = 0;
shakeY = 0;

useCustomDir = false;
duration = 0;
shakeIntensity = 3;
shakeRate = 3;//2;

shakeDirection = 0;

function Shake(_duration, _shakeIntensity = 3, _shakeRate = 3, _useCustomDir = false, _shakeDirection = 0)
{
	if(!active)
	{
		duration = _duration;
		shakeIntensity = _shakeIntensity;
		shakeRate = _shakeRate;
		useCustomDir = _useCustomDir;
		shakeDirection = _shakeDirection;
		
		active = true;
	}
	else if((duration-timeLeft) < _duration && 
			duration == _duration &&
			shakeIntensity == _shakeIntensity && 
			shakeRate == _shakeRate &&
			useCustomDir == _useCustomDir)
	{
		timeLeft = 0;
	}
}