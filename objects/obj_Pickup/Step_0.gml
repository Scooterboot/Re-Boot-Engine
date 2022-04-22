/// @description Player pickup logic
if(global.gamePaused)
{
	image_speed = 0;
	exit;
}
else
{
	image_speed = imSpeed;
}

if(!collected)
{
	if(place_meeting(x,y,obj_Player))
	{
		CollectItem();
		if(!isExpansion)
		{
			obj_UI.CreateMessageBox(itemHeader,itemDesc,Message.Item);
			obj_Music.playItemFanfare = true;
			global.gamePaused = true;
		}
		else
		{
			obj_UI.CreateMessageBox(expanHeader,expanDesc,Message.Expansion);
			audio_stop_sound(snd_ExpansionGet);
			audio_play_sound(snd_ExpansionGet,0,false);
		}
		collected = true;
		//global.gamePaused = true;
	}
}
else
{
	instance_destroy();
}