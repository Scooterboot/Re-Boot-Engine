
function place_collide(offsetX, offsetY)
{
	return place_meeting(x+offsetX,y+offsetY,obj_Tile);
}

function position_collide(offsetX, offsetY)
{
	return position_meeting(x+offsetX,y+offsetY,obj_Tile);
}

function lhc_place_collide()
{
	/// @description lhc_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = x,
		yy = y;
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	return lhc_place_meeting(xx+offsetX,yy+offsetY,"ISolid");
}

function lhc_position_collide(offsetX, offsetY)
{
	return lhc_position_meeting(x+offsetX,y+offsetY,"ISolid");
}

function collide_rect(x1, y1, x2, y2)
{
	var rect = collision_rectangle(x1,y1,x2,y2,obj_Tile,true,true);
	return (rect != noone);
}

/*function scr_GetSlopeAngle(slope)
{
	var ang = 315;
	if(sign(slope.image_yscale) > 0)
	{
		if(sign(slope.image_xscale) > 0)
		{
			ang = 360 - ((45 / slope.image_xscale) * (1 + (1 - 1 / slope.image_yscale)));
		}
		else
		{
			ang = (45 / abs(slope.image_xscale)) * (1 + (1 - 1 / slope.image_yscale));
		}
	}
	else
	{
		if(sign(slope.image_xscale) > 0)
		{
			ang = 180 + ((45 / slope.image_xscale) * (1 + (1 - 1 / abs(slope.image_yscale))));
		}
		else
		{
			ang = 180 - ((45 / abs(slope.image_xscale)) * (1 + (1 - 1 / abs(slope.image_yscale))));
		}
	}
	return ang;
}*/