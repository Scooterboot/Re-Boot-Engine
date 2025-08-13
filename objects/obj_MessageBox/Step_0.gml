/// @description Logic
event_inherited();

SetControlVars("menu");
var prSelect = (cMenuAccept && rMenuAccept),
	prCancel = (cMenuCancel && rMenuCancel),
	prStart = (cStart && rStart);

switch (messageType)
{
	case Message.Item:
	{
		if(messageDuration < messageDurMax_Item)
		{
			messageAlpha = min(messageAlpha+0.1,1);
			if((prSelect || prCancel || prStart) && messageDuration >= 30)
			{
				obj_Audio.skipItemFanfare = true;
				messageDuration = messageDurMax_Item;
			}
			global.gamePaused = true;
		}
		else
		{
			messageAlpha = max(messageAlpha-0.1,0);
			kill = true;
		}
		messageDuration++;
		break;
	}
	case Message.Expansion:
	{
		if(messageDuration < messageDurMax_Expan)
		{
			messageAlpha = min(messageAlpha+0.1,1);
		}
		else
		{
			messageAlpha = max(messageAlpha-0.1,0);
			kill = true;
		}
		messageDuration++;
		break;
	}
	case Message.Simple:
	{
		if(messageDuration < messageDurMax_Simple)
		{
			messageAlpha = min(messageAlpha+0.1,1);
		}
		else
		{
			messageAlpha = max(messageAlpha-0.05,0);
			kill = true;
		}
		messageDuration++;
		break;
	}
}

if(kill && messageAlpha <= 0)
{
	instance_destroy();
}

SetReleaseVars("menu");