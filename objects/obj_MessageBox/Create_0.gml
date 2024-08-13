/// @description Initialize
event_inherited();
header = "";
description = "";
messageType = 0;
enum Message
{
	Item,
	Expansion,
	Simple
}
var order2 = -1;
order = 0;
for(var i = 0; i < instance_number(obj_MessageBox); i++)
{
	var mBox = instance_find(obj_MessageBox,i);
	if(instance_exists(mBox) && mBox.id != id && mBox.messageType != Message.Item)
	{
		order2 = max(mBox.order,order2);
		if(mBox.order == order)
		{
			order++;
		}
	}
}
order = max(order, order2+1);

messageDuration = 0;
messageDurMax_Item = audio_sound_length(mus_ItemFanfare) * 60;
messageDurMax_Expan = 90;
messageDurMax_Simple = 60;
messageAlpha = 0;
kill = false;

cSelect = false;
cCancel = false;
cStart = false;

rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;


descScrib = scribble(description);
descScrib.starting_format("fnt_GUI_Small2",c_white);
descScrib.align(fa_center,fa_top);
//descScrib.align(fa_center,fa_bottom);