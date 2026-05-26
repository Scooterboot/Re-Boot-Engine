
header_raw = "";
header = header_raw;
description_raw = "";
description = description_raw;

updateText = true;

enum Message
{
	Item,
	Expansion,
	Simple
}
messageType = 0;

order = 0;
var order2 = -1;
for(var i = 0; i < instance_number(object_index); i++)
{
	var mBox = instance_find(object_index,i);
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

InitControlVars("menu");
