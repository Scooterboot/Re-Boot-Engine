/// @description 
event_inherited();

if(dead)
{
	for(var i = 128; i < room_width-128; i += 32)
	{
		for(var j = room_height/2+64; j < room_height-64; j += 32)
		{
			if(irandom(1) == 0)
			{
				self.NPCDropItem(i+irandom(32),j+irandom(32));
			}
		}
	}
}
else
{
	instance_destroy(enviroHandler);
}

instance_destroy(head);
//instance_destroy(rHand);

global.rmMusic = global.music_ItemRoom;