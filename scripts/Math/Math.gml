
function scr_round(val)
{
	//return (val + (abs(frac(val)) >= 0.5)*sign(val) - frac(val));
	var val2 = floor(abs(val)+0.5);
	return val2 * sign(val);
}

function scr_ceil(val)
{
	//return (val + (abs(frac(val)) > 0)*sign(val) - frac(val));
	var val2 = ceil(abs(val));
	return val2 * sign(val);
}

function scr_floor(val)
{
	//return (val - frac(val));
	var val2 = floor(abs(val));
	return val2 * sign(val);
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