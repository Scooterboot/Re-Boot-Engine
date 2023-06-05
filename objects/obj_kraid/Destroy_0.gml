/// @description 
event_inherited();

if(dead)
{
	for(var i = 128; i < room_width-128; i += 16)
	{
		for(var j = room_height/2+64; j < room_height-64; j += 16)
		{
			if(irandom(2) == 0)
			{
				NPCLoot(i,j);
			}
		}
	}
}
else
{
	instance_destroy(enviroHandler);
}

instance_destroy(head);
instance_destroy(rHand);

global.rmMusic = global.music_ItemRoom;