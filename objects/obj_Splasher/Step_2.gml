/// @description Update

if(global.gamePaused)
{
	exit;
}
if(!instance_exists(liquid))
{
	instance_destroy();
	exit;
}

x += velX;
x = clamp(x,liquid.bbox_left,liquid.bbox_right);
y = scr_round(liquid.bbox_top);

timer--;

if (timer < timeEnd)
{
	timeEnd = random_range(0,4);
	if(abs(velX) > 1)
	{
		timeEnd = random_range(0,2);
	}
	else if(abs(velX) < 0.2)
	{
		timeEnd = random_range(0,7);
	}
	
	timer = 7;
	scale -= 0.1 + ((abs(velX) < 0.2) * 0.05);
	velX += liquid.velX * (1-scale) * 0.375;
	
	if(scale > 0.1)
	{
		var splash = instance_create_layer(x, y, liquid.layer,obj_SplashFXAnim);
		splash.liquid = liquid;
		splash.sprite_index = choose(sprt_WaterSplashLarge,sprt_WaterSkidLarge);
		splash.image_xscale = image_xscale;
		splash.image_yscale = scale;
		splash.image_alpha = 0.7;
		splash.depth += 1;
		splash.splash = true;
		splash.animSpeed = 1.0 / 3;
		splash.velX = velX*0.1;
	}
	else
	{
		instance_destroy();
	}
}