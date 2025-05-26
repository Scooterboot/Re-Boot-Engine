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
	var player = collision_rectangle(bbox_left-2,bbox_top-2,bbox_right+2,bbox_bottom+2,obj_Player,false,true);
	if(instance_exists(player) && !place_meeting(x,y,obj_Breakable))
	{
		CollectItem(player);
		if(!isExpansion)
		{
			obj_UI_Old.CreateMessageBox(itemHeader,itemDesc,Message.Item);
			obj_Audio.playItemFanfare = true;
			global.gamePaused = true;
		}
		else
		{
			obj_UI_Old.CreateMessageBox(expanHeader,expanDesc,Message.Expansion);
			audio_stop_sound(snd_ExpansionGet);
			audio_play_sound(snd_ExpansionGet,0,false);
		}
		collected = true;
	}
}
else
{
	instance_destroy();
}