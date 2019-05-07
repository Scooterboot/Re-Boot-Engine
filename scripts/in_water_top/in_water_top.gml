/// @description in_water_top(void);

/// Is the top of an object in touch with some form of water?

var Return = 0;
/*var Contact = collision_line(x+MaskL,y+MaskT,x+MaskR-1,y+MaskT,oLiquidPuddle,1,1)

if (Contact)
{
	Return = 1;
	SplashY = Contact.y;
}
else*/
if (instance_exists(obj_Liquid)) 
{
	if (bbox_top > obj_Liquid.y)
	{
		Return = 2;
		SplashY = obj_Liquid.y;
	}
}


return Return;