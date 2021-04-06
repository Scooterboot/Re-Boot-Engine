/// -- Spawn Splashes --

if(global.gamePaused)
{
	exit;
}

x += xVel;


if (instance_exists(obj_Liquid))
{
	y = floor(obj_Liquid.y);
}

Timer -= 1;

var num = random_range(0,4);
if(abs(xVel) > 1)
{
	num = random_range(0,2);
}
else if(abs(xVel) < 0.2)
{
	num = random_range(0,7);
}

if (Timer < num)
{
	Timer = 7;
	Size -= 0.1+((abs(xVel) < 0.2)*0.05);
	//xVel += obj_Water.MoveX*(1-Size)*0.375;
 
	if(Size > 0.1)
	{
		Splash = instance_create_layer(x, y, "Liquids_fg",obj_SplashFXAnim);
		Splash.sprite_index = sprite_index;
		Splash.image_alpha = 0.7;
		Splash.Speed = .3333;
		Splash.image_xscale = image_xscale;
		Splash.image_yscale = Size;
		Splash.Splash = 1;
		Splash.depth = 65;
		Splash.sprite_index = choose(sprt_WaterSplashLarge,sprt_WaterSkidLarge);
		Splash.xVel = xVel*0.1;
	}
	else
	{
		instance_destroy();
	}
}