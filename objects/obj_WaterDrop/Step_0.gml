/// -- Collide Water --

if(global.gamePaused)
{
	exit;
}

/// -- Move

yVel = min(yVel+Gravity,6);

x += xVel;
y += yVel;

/// -- Splash

if (in_water() && !Dead)
{
    Splash = instance_create_layer(x,SplashY,"Liquids_fg",obj_SplashFXAnim);
    if(yVel > 3)
    {
        Splash.sprite_index = sprt_WaterSplashSmall;
        Splash.image_xscale = choose(-.7,.7);
        Splash.image_yscale = .7;
    }
    else
    {
        Splash.sprite_index = sprt_WaterSplashTiny;
        Splash.image_xscale = choose(-1,1);
        Splash.image_yscale = 1;
    }
    Splash.image_alpha = 0.7;
    Splash.Speed = .3333;
    Splash.Splash = 1;
    Splash.depth = 65;
    if(instance_exists(obj_Water))
    {
        Splash.xVel = obj_Water.MoveX;
    }
    else if(instance_exists(obj_Lava))
    {
        Splash.xVel = obj_Lava.MoveX;
    }
    
    instance_destroy();
}