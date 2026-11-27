
if(activeState == UI_ActiveState.Active)
{
	self.UpdateText();
	if(screenFade > 0)
	{
		self.UpdateBentoEnviro(environment);
	}
	screenFade = min(screenFade+screenFadeRate,1);
}
else
{
	updateText = true;
	if(screenFade <= 0)
	{
		instance_destroy();
	}
	screenFade = max(screenFade-screenFadeRate,0);
}