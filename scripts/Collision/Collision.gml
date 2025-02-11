
function object_is_in_array(_obj, _arr)
{
	for(var i = 0; i < array_length(_arr); i++)
	{
		if(_obj == _arr[i] || object_is_ancestor(_obj,_arr[i]))
		{
			return true;
		}
	}
	return false;
}

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

function rectangle_intersect_line(rx1,ry1,rx2,ry2, x1,y1,x2,y2)
{
	if(lines_intersect(x1,y1,x2,y2, rx1,ry1,rx2,ry1, true) > 0 || // top
		lines_intersect(x1,y1,x2,y2, rx1,ry2,rx2,ry2, true) > 0 || // bottom
		lines_intersect(x1,y1,x2,y2, rx1,ry1,rx1,ry2, true) > 0 || // left
		lines_intersect(x1,y1,x2,y2, rx2,ry1,rx2,ry2, true) > 0) // right
	{
		return true;
	}
	if(point_in_rectangle(x1,y1, rx1,ry1,rx2,ry2) || point_in_rectangle(x2,y2, rx1,ry1,rx2,ry2))
	{
		return true;
	}
	return false;
}

#region experimental (inefficient and laggy)

function instance_place_array(_x, _y, obj)
{
	if(place_meeting(_x,_y,obj))
	{
		var result = [];
		var num = 0;
		with(obj)
		{
			if(place_meeting(x-(_x-other.x), y-(_y-other.y), other))
			{
				result[num] = id;
				num++;
			}
		}
		return result;
	}
	return [noone];
}

function collision_circle_array(_x, _y, radius, obj, prec, notme)
{
	var num = 0;
	var result = [];
	with(obj)
	{
		if(notme && id == other.id)
		{
			continue;
		}
		if(!collision_circle(_x,_y,radius,id,prec,false))
		{
			continue;
		}
		result[num] = id;
		num++;
	}
	return result;
}
function collision_ellipse_array(x1, y1, x2, y2, obj, prec, notme)
{
	var num = 0;
	var result = [];
	with(obj)
	{
		if(notme && id == other.id)
		{
			continue;
		}
		if(!collision_ellipse(x1,y1,x2,y2,id,prec,false))
		{
			continue;
		}
		result[num] = id;
		num++;
	}
	return result;
}
function collision_line_array(x1, y1, x2, y2, obj, prec, notme)
{
	var num = 0;
	var result = [];
	with(obj)
	{
		if(notme && id == other.id)
		{
			continue;
		}
		if(!collision_line(x1,y1,x2,y2,id,prec,false))
		{
			continue;
		}
		result[num] = id;
		num++;
	}
	return result;
}
function collision_point_array(_x, _y, obj, prec, notme)
{
	var num = 0;
	var result = [];
	with(obj)
	{
		if(notme && id == other.id)
		{
			continue;
		}
		if(!collision_point(_x,_y,id,prec,false))
		{
			continue;
		}
		result[num] = id;
		num++;
	}
	return result;
}
function collision_rectangle_array(x1, y1, x2, y2, obj, prec, notme)
{
	var num = 0;
	var result = [];
	with(obj)
	{
		if(notme && id == other.id)
		{
			continue;
		}
		if(!collision_rectangle(x1,y1,x2,y2,id,prec,false))
		{
			continue;
		}
		result[num] = id;
		num++;
	}
	return result;
}

#endregion
