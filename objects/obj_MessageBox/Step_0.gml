/// @description Logic
event_inherited();

cSelect = obj_Control.mSelect;
cCancel = obj_Control.mCancel;
cStart = obj_Control.start;
var prSelect = (cSelect && rSelect),
	prCancel = (cCancel && rCancel),
	prStart = (cStart && rStart);

switch (messageType)
{
	case Message.Item:
	{
		if(messageDuration < 360)
		{
			messageAlpha = min(messageAlpha+0.1,1);
			if((prSelect || prCancel || prStart) && messageDuration >= 30)
			{
				obj_Music.skipItemFanfare = true;
				messageDuration = 360;
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
		if(messageDuration < 90)
		{
			messageAlpha = min(messageAlpha+0.1,1);
			/*if(messageDuration >= 15)
			{
				var flag = true;
				for(var i = 0; i < instance_number(obj_MessageBox); i++)
				{
					var mBox = instance_find(obj_MessageBox,i);
					if(instance_exists(mBox) && mBox.id != id && (mBox.messageDuration < 15 || mBox.messageType == Message.Item))
					{
						flag = false;
						messageDuration = 90;
						break;
					}
				}
				if(global.gamePaused && !obj_PauseMenu.pause && !kill && flag)
				{
					global.gamePaused = false;
					kill = true;
				}
			}*/
		}
		else
		{
			messageAlpha = max(messageAlpha-0.1,0);
			kill = true;
		}
		//if(!global.gamePaused)
		//{
			messageDuration++;
		//}
		break;
	}
	case Message.Simple:
	{
		if(messageDuration < 60)
		{
			messageAlpha = min(messageAlpha+0.1,1);
		}
		else
		{
			messageAlpha = max(messageAlpha-0.05,0);
			kill = true;
		}
		//if(!global.gamePaused)
		//{
			messageDuration++;
		//}
		break;
	}
}

if(kill && messageAlpha <= 0)
{
	instance_destroy();
}

rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;