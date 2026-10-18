
if(activeState == UI_ActiveState.Active)
{
	if(state == UI_SMState.Default)
	{
		if(!BentoLayerExists(defaultMenuLayer))
		{
			self.CreateDefaultMenu();
		}
		BentoLayerSetDrawWhenBackgrounded(true, defaultMenuLayer);
	}
	else if(BentoLayerExists(defaultMenuLayer))
	{
		BentoLayerSetDrawWhenBackgrounded(false, defaultMenuLayer);
	}
	
	if(state == UI_SMState.Display)
	{
		
	}
	else
	{
		
	}
	
	if(state == UI_SMState.Audio)
	{
		
	}
	else
	{
		
	}
	
	if(state == UI_SMState.Gameplay)
	{
		
	}
	else
	{
		
	}
	
	if(state == UI_SMState.Keyboard)
	{
		if(!BentoLayerExists(kbBindMenuLayer))
		{
			self.CreateKBBindMenu();
		}
	}
	else if(BentoLayerExists(kbBindMenuLayer))
	{
		BentoLayerDestroy(kbBindMenuLayer);
	}
	
	if(state == UI_SMState.Controller)
	{
		
	}
	else
	{
		
	}
	
	cleanUp = true;
	BentoLayerDestroy(inputBlockLayer);
}
else
{
	if(activeState == UI_ActiveState.Activating || activeState == UI_ActiveState.Deactivating)
	{
		if(!BentoLayerExists(inputBlockLayer))
		{
			BentoLayerCreate(inputBlockLayer);
		}
	}
	
	if(activeState == UI_ActiveState.Inactive)
	{
		state = UI_SMState.Default;
		
		if(cleanUp)
		{
			BentoLayerDestroy(defaultMenuLayer);
			
			BentoLayerDestroy(inputBlockLayer);
			cleanUp = false;
		}
	}
}

if(activeState != UI_ActiveState.Inactive)
{
	if(updateText || obj_UI_Controller.updateText)
	{
		for(var i = 0; i < array_length(headerTextRaw); i++)
		{
			headerText[i] = UI_InsertIconsIntoString(headerTextRaw[i]);
		}
		for(var i = 0; i < array_length(footerTextRaw); i++)
		{
			footerText[i] = UI_InsertIconsIntoString(footerTextRaw[i]);
		}
		updateText = false;
	}
}
else
{
	updateText = true;
}

if(activeState == UI_ActiveState.Active || activeState == UI_ActiveState.Inactive)
{
	screenFade = max(screenFade-screenFadeRate,0);
}
else if(activeState == UI_ActiveState.Activating || activeState == UI_ActiveState.Deactivating)
{
	screenFade = min(screenFade+screenFadeRate,1);
	if(screenFade >= 1)
	{
		activeState = (activeState == UI_ActiveState.Activating) ? UI_ActiveState.Active : UI_ActiveState.Inactive;
	}
}
