
function scr_round(val)
{
	return sign(val) * floor(abs(val)+0.5);
}

function scr_ceil(val)
{
	return sign(val) * ceil(abs(val));
}

function scr_floor(val)
{
	return sign(val) * floor(abs(val));
}

function scr_wrap(val,vmin,vmax)
{
	/// @param val
	/// @param min
	/// @param max
	while(val >= vmax || val < vmin)
	{
	    if(val >= vmax)
	    {
	        val -= (vmax-vmin);
	    }
	    else if(val < vmin)
	    {
	        val += ((vmax-vmin));
	    }
	}
	return val;
}

function AngleFlip(angle, dir)
{
	var c = dcos(angle),
		s = dsin(angle);
	return darctan2(s,c*dir);
}

function ReflectAngle(_src, _dest)
{
	var _diffAng = angle_difference(scr_wrap(_src,0,360),scr_wrap(_dest,0,360));
	return _src + (180 - 2*_diffAng);
}