/// @description 
event_inherited();

rotation = 0;

for(var i = 0; i < 8; i++)
{
	var xscale = -2,
		yscale = 1;
	var offsetX = 0,
		offsetY = -24;
	if(i == 1)
	{
		xscale = 2;
	}
	if(i == 2 || i == 3)
	{
		xscale = 1;
		offsetX = 16;
	}
	if(i == 6 || i == 7)
	{
		xscale = -1;
		offsetX = -16;
	}
	if(i == 2 || i == 7)
	{
		yscale = 2;
		offsetY = -16;
	}
	if(i == 3 || i == 6)
	{
		yscale = -2;
		offsetY = 16;
	}
	if(i == 4 || i == 5)
	{
		yscale = -1;
		offsetY = 24;
		if(i == 4)
		{
			xscale = 2;
		}
	}
	mSlope[i] = instance_create_layer(x+offsetY,y+offsetY,"Collision",obj_MovingSlope_4th);
	mSlope[i].image_xscale = xscale;
	mSlope[i].image_yscale = yscale;
	mSlope[i].ignoredEntity = id;
	mSlope_OffsetX[i] = offsetX;
	mSlope_OffsetY[i] = offsetY;
}

function SkipOwnMovingTile(num, checkOnlyMoving = false)
{
	for(var i = 0; i < num; i++)
	{
		if(instance_exists(block_list[| i]) && 
		((asset_has_any_tag(block_list[| i].object_index,solids,asset_object) && !checkOnlyMoving) ||
		(asset_has_any_tag(block_list[| i].object_index,"IMovingSolid",asset_object) && checkOnlyMoving)))
		{
			var block = block_list[| i];
			
			var flag = false;
			for(var j = 0; j < array_length(mSlope); j++)
			{
				if(block == mSlope[j])
				{
					flag = true;
				}
			}
			if(block != mBlock && !flag)
			{
				ds_list_clear(block_list);
				return true;
			}
		}
	}
	ds_list_clear(block_list);
	return false;
}

rotScale = 5;
surfW = sprite_get_width(sprite_index) + 8;
surfH = sprite_get_height(sprite_index) + 8;
surf = surface_create(surfW*rotScale,surfH*rotScale);