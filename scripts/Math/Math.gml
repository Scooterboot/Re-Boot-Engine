
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
	/*if(val mod 1 == 0)
	{
	    while(val > vmax || val < vmin)
	    {
	        if(val > vmax)
	        {
	            val -= ((vmax-vmin) + 1);
	        }
	        else if(val < vmin)
	        {
	            val += ((vmax-vmin) + 1);
	        }
	    }
	}
	else
	{
	    var vold = argument[0]+1;
	    while(val != vold)
	    {
	        vold = val;
	        if(val > vmax)
	        {
	            val -= (vmax-vmin);
	        }
	        else if(val < vmin)
	        {
	            val += (vmax-vmin);
	        }
	    }
	}
	return(val);*/
}
