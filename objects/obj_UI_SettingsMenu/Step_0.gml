
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
		
	}
	else
	{
		
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

/*self.SetControlVars_Press();

if(activeState == UI_ActiveState.Active)
{
	currentPage = noone;
	if(state == UI_SMState.Default)
	{
		if(!instance_exists(defaultPage))
		{
			self.CreateDefaultPage();
		}
		currentPage = defaultPage;
	}
	
	if(state == UI_SMState.Display)
	{
		if(!instance_exists(displayPage))
		{
			self.CreateDisplayPage();
		}
		currentPage = displayPage;
	}
	else
	{
		instance_destroy(displayPage);
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
		if(!instance_exists(kbBindPage))
		{
			self.CreateKBBindPage();
		}
		currentPage = kbBindPage;
	}
	else
	{
		instance_destroy(kbBindPage);
	}
	
	if(state == UI_SMState.Controller)
	{
		
	}
	else
	{
		
	}
	
	
	if(instance_exists(currentPage))
	{
		currentPage.UpdatePage();
	}
	
	
	
	/*currentPage = noone;
	
	if(state == UI_SMState.Display)
	{
		if(!instance_exists(displayPage))
		{
			self.CreateDisplayPage();
		}
		currentPage = displayPage;
	}
	if(state == UI_SMState.Audio)
	{
		
	}
	if(state == UI_SMState.Gameplay)
	{
		
	}
	if(state == UI_SMState.Controls)
	{
		
	}
	
	var pageFlag = true;
	if(canTabSwitch)
	{
		if(!instance_exists(headerPage))
		{
			self.CreateHeaderPage();
		}
		else
		{
			headerPage.UpdatePage();
		}
		var tabMove = (cMenuR1 && rMenuR1) - (cMenuL1 && rMenuL1);
		if(tabMove != 0)
		{
			state = scr_wrap(state+tabMove, 0, UI_SMState._Length);
			audio_play_sound(snd_MenuTick,0,false);
			pageFlag = false;
		}
		
		// temp
		if((cMenuCancel && rMenuCancel) || (cClickR && rClickR))
		{
			activeState = UI_ActiveState.Deactivating;
		}
		//
	}
	
	canTabSwitch = true;
	if(pageFlag && instance_exists(currentPage))
	{
		currentPage.UpdatePage();
		if(currentPage.hasModalEle)
		{
			canTabSwitch = false;
		}
	}//
}
else
{
	if(activeState == UI_ActiveState.Inactive)
	{
		for(var i = array_length(pageArr)-1; i >= 0; i--)
		{
			instance_destroy(pageArr[i]);
			array_delete(pageArr, i, 1);
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

self.SetControlVars_Release();
*/