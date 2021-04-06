
function scr_wrap(val,vmin,vmax)
{
	/// @param val
	/// @param min
	/// @param max
	if(val mod 1 == 0)
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
	return(val);
}
