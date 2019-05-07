/// @description scr_wrap(val, min, max)
/// @param val
/// @param  min
/// @param  max
var val = argument0;
var vmax = argument2;
var vmin = argument1;

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
