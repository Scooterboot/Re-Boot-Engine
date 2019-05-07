/// @description water_at(x,y)

/// Checks if water at that pixel.

var XP = x,
    YP = y,
    Return = 0;
    
x = argument0;
y = argument1;

/*var Contact = position_meeting(x,y,oLiquidPuddle);

if (Contact)
{
	Return = 1;
	SplashY = Contact.y;
}
else*/
if (instance_exists(obj_Liquid)) 
{
	if (y > obj_Liquid.y)
	{
		Return = 2;
		SplashY = obj_Liquid.y;
	}
}

x = XP;
y = YP;

return Return;