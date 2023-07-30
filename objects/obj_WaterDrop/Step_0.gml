/// -- Collide Water --

if(global.gamePaused)
{
	exit;
}

if(!init)
{
	if(liquidType == LiquidType.Lava)
	{
		sprite_index = sprt_LavaDrop;
		image_alpha = 0.9;
		grav = 0.18;
	}
	init = true;
}

velY = min(velY+grav,6);

x += velX;
y += velY;

var liquid = instance_place(x,y,obj_Liquid);
if(instance_exists(liquid) && !kill)
{
	var splash = instance_create_layer(x,liquid.bbox_top,liquid.layer,obj_SplashFXAnim);
	splash.liquid = liquid;
	if(velY > 3)
	{
		splash.sprite_index = sprt_WaterSplashSmall;
		splash.image_xscale = choose(-0.7,0.7);
		splash.image_yscale = 0.7;
	}
	else
	{
		splash.sprite_index = sprt_WaterSplashTiny;
		splash.image_xscale = choose(-1,1);
		splash.image_yscale = 1;
	}
	splash.image_alpha = 0.7;
	splash.depth += 1;
	splash.splash = true;
	splash.animSpeed = 1.0 / 3;
	splash.velX = liquid.velX;

	instance_destroy();
}

if(lhc_place_meeting(x,y,solids))
{
	instance_destroy();
}