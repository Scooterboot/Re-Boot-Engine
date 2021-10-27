/// @description Reveal logic

if(!visible && !revealTile)
{
    if(place_meeting(x,y,obj_MBBombExplosion) || place_meeting(x,y,obj_PowerBombExplosion) || place_meeting(x,y,obj_MissileExplosion) || place_meeting(x,y,obj_SuperMissileExplosion))
    {
        revealTile = true;
    }
	if(place_meeting(x,y,obj_Projectile) && (object_index == obj_BombBlock || object_index == obj_ChainBlock))
	{
		var shot = instance_place(x,y,obj_Projectile);
		if(shot.isBeam)
		{
			revealTile = true;
		}
	}
}

if(revealTile)
{
    if(!visible)
    {
        for(var i = 0; i < 4; i++)
		{
			var lay = layer_get_id("Tiles_fg"+string(i));
			if(layer_exists(lay))
			{
				var map_id = layer_tilemap_get_id(lay);
				var data = tilemap_get_at_pixel(map_id,x,y) & tile_index_mask;
				if(!tile_get_empty(data))
				{
					data = tile_set_empty(data);
					tilemap_set_at_pixel(map_id,data,x,y);
				}
			}
		}
        visible = true;
    }
    //revealTile = false;
}
