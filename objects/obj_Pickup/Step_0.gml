/// @description Player pickup logic
if(global.gamePaused)
{
	//image_speed = 0;
	exit;
}
//else
//{
	//image_speed = imSpeed;
//}

visible = !place_meeting(x,y,obj_Breakable);

if(!collected)
{
	if(instance_exists(obj_Player) && !place_meeting(x,y,obj_Tile))
	{
		var P = obj_Player;
		if(place_meeting(x-P.fVelX-P.move2,y-P.fVelY,P))
		{
			CollectItem();
			if(!isExpansion)
			{
				obj_UI.CreateMessageBox(itemHeader,itemDesc,Message.Item);
				obj_Audio.playItemFanfare = true;
				global.gamePaused = true;
			}
			else
			{
				obj_UI.CreateMessageBox(expanHeader,expanDesc,Message.Expansion);
				audio_stop_sound(snd_ExpansionGet);
				audio_play_sound(snd_ExpansionGet,0,false);
			}
			collected = true;
		}
	}
}
else
{
	instance_destroy();
}