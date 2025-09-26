/// @description Shake

if(global.GamePaused())
{
	exit;
}

if(active && timeLeft < duration)
{
	shakeCounter++;
	if(shakeCounter >= shakeCounterMax)
	{
		if(!useCustomDir)
		{
			shakeDirection = irandom(36)*10;
		}
		
		shakeStep += shakeRate*shakeStepDir;
		if(shakeStep == 0)
		{
			//shakeStep += shakeRate*shakeStepDir;
		}
		if(abs(shakeStep) >= shakeIntensity)
		{
			shakeStepDir *= -1;
		}
		shakeStep = clamp(shakeStep,-shakeIntensity,shakeIntensity);
		
		shakeCounter -= shakeCounterMax;
		
		var slowdown = min(2 * (1 - timeLeft/duration), 1);
		if(duration > 30)
		{
			slowdown = 1;
			var dur = duration-30;
			if(timeLeft >= dur)
			{
				slowdown = min(2 * (1 - (timeLeft-dur)/30), 1);
			}
		}
		shakeX = lengthdir_x(1,shakeDirection)*shakeStep * slowdown;
		shakeY = lengthdir_y(1,shakeDirection)*shakeStep * slowdown;
	}
	
	timeLeft++;
}
else
{
	shakeX = 0;
	shakeY = 0;
	
	active = false;
	timeLeft = 0;
}
