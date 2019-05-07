/// @description in_water(void);

/// Is object in touch with some form of water?

var Return = 0;
/*var Contact = collision_line(x+MaskL,y+MaskB-1,x+MaskR-1,y+MaskB-1,oLiquidPuddle,1,1)

if (Contact)
{
	Return = 1;
	SplashY = Contact.y;
}
else*/
if (instance_exists(obj_Liquid)) //obj_Water
{
	if (y + WaterBot > obj_Liquid.y) //obj_Water
	{
		Return = 2;
		SplashY = obj_Liquid.y; //obj_Water
	}
}


return Return;