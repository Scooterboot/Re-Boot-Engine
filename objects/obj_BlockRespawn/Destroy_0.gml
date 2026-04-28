/// @description Respawn Tile

if(initialTime > 0)
{
	if(place_meeting(x,y,obj_Player))
	{
		var re = instance_create_layer(x,y,layer,obj_BlockRespawn);
		re.sprite_index = sprite_index;
		re.blockIndex = blockIndex;
		re.respawnTime = initialTime;
		re.initialTime = initialTime;
		re.image_xscale = image_xscale;
		re.image_yscale = image_yscale;
		self.SetExtraRespawnVars(re);
		re.SetExtraRespawnVars = self.SetExtraRespawnVars;
	}
	else if(blockIndex != noone)
	{
		var bl = instance_create_layer(x,y,layer,blockIndex);
		bl.visible = true;
		bl.respawnTime = initialTime;
		bl.image_xscale = image_xscale;
		bl.image_yscale = image_yscale;
		self.SetExtraRespawnVars(bl);
	}
}