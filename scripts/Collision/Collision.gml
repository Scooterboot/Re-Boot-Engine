
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

function lines_intersect(x1,y1,x2,y2,x3,y3,x4,y4,segment)
{
	//  Returns a vector multiplier (t) for an intersection on the
	//  first line. A value of (0 < t <= 1) indicates an intersection 
	//  within the line segment, a value of 0 indicates no intersection, 
	//  other values indicate an intersection beyond the endpoints.
	//
	//      x1,y1,x2,y2     1st line segment
	//      x3,y3,x4,y4     2nd line segment
	//      segment         If true, confine the test to the line segments.
	//
	//  By substituting the return value (t) into the parametric form
	//  of the first line, the point of intersection can be determined.
	//  eg. x = x1 + t * (x2 - x1)
	//      y = y1 + t * (y2 - y1)
	
	var ua, ub, ud, ux, uy, vx, vy, wx, wy;
    ua = 0;
    ux = x2 - x1;
    uy = y2 - y1;
    vx = x4 - x3;
    vy = y4 - y3;
    wx = x1 - x3;
    wy = y1 - y3;
    ud = vy * ux - vx * uy;
    if (ud != 0) 
    {
        ua = (vx * wy - vy * wx) / ud;
        if (segment) 
        {
            ub = (ux * wy - uy * wx) / ud;
            if (ua < 0 || ua > 1 || ub < 0 || ub > 1) ua = 0;
        }
    }
    return ua;
}