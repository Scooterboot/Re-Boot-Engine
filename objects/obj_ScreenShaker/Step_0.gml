/// @description Shake

shakeX = 0;
shakeY = 0;

if(timeLeft < duration)
{
	if(!useCustomDir)
	{
		shakeDirection = irandom(36)*10;
	}
	
	shakeStep += +shakeRate*shakeStepDir;
	if(shakeStep == 0)
	{
		shakeStep += +shakeRate*shakeStepDir;
	}
	if(abs(shakeStep) >= shakeIntensity)
	{
		shakeStepDir *= -1;
	}
	shakeStep = clamp(shakeStep,-shakeIntensity,shakeIntensity);
	
	var slowdown = min(2 * (1 - timeLeft/duration), 1);
	shakeX = lengthdir_x(1,shakeDirection)*shakeStep * slowdown;
	shakeY = lengthdir_y(1,shakeDirection)*shakeStep * slowdown;
	
	timeLeft++;
}
else
{
	instance_destroy();
}
