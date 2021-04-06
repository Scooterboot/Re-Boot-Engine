/// -- Animated and Died

if(global.gamePaused)
{
	exit;
}

if(!initIndex)
{
	newIndex = image_index;
	initIndex = true;
}



y += yVel;
if(!instance_exists(obj_Lava))
{
    x += xVel;
    newIndex += Speed;
}
else
{
    x += xVel * 0.75;
    newIndex += Speed * 0.75;
}

if (newIndex >= image_number)
{
    instance_destroy();
}

image_index = newIndex;

Watery = 0;

if (sprite_index == sprt_WaterSplashSmall
or  sprite_index == sprt_WaterSplashLarge
or  sprite_index == sprt_WaterSplashHuge
or  sprite_index == sprt_WaterSplash
or  sprite_index == sprt_WaterSkid
or  sprite_index == sprt_WaterSkidLarge
or  Splash)
{
    Watery = 1;
    if (instance_exists(obj_Liquid))
    {
        y = floor(obj_Liquid.y);
        var ly = obj_Liquid.y - obj_Liquid.yprevious;
        if(ly > 0)
        {
            y = floor(obj_Liquid.y+ly);
        }
    }
}