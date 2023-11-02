/// @description Transparancy

if(opacity >= 1)
{
	exit;
}

var fade = false;
var fadespeed = 0.05*(1 - opacity);
var _list = ds_list_create();
var triggerBlock = instance_place_list(x,y,obj_TileFadeBlockTrigger,_list,true);
if(triggerBlock > 0)
{
	for(var i = 0; i < triggerBlock; i++)
	{
		if(_list[| i].active)
		{
			fade = true;
			break;
		}
	}
}

if(fade)
{
	image_alpha = max(image_alpha - fadespeed, opacity);
}
else
{
	image_alpha = min(image_alpha + fadespeed, 1);
}