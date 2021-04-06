/// -- Disappear

if(global.gamePaused)
{
	exit;
}

/// -- Move 

Time ++;


if (sprite_index == sprt_WaterBubbleSmall) 
{
	Index += .25;

	if (Index >= 20)
	{
		sprite_index = choose(sprt_WaterBubbleTiny, sprt_WaterBubbleTiny2);
	}
}
else
{
	Index += .2;
 
	if (sprite_index == sprt_WaterBubble) 
	{
		Index += .3;
  
		if (Index >= 18)
		{
			sprite_index = sprt_WaterBubbleTiny;
   
			repeat (3)
			{
				Bubble = instance_create_layer(floor(x-2+random(4)),floor(y+random(3)),"Liquids_fg",obj_WaterBubble);
				Bubble.Alpha = .75;
				Bubble.image_xscale = 1
				Bubble.image_yscale = 1;
				Bubble.Delete = Delete;
				Bubble.CanSpread = 0;
				Bubble.Index = choose(2,3,4);
				Bubble.sprite_index = choose(sprt_WaterBubbleTiny, sprt_WaterBubbleTiny2);
				Bubble.MaxSpeed *= (.9 + random(.1));
				Bubble.xVel = xVel/1.35;  
			}
		}
	}
}

if(instance_exists(obj_Water))
{
	x += xVel + obj_Water.MoveX/3;
}
else if(instance_exists(obj_Lava))
{
	x += xVel + obj_Lava.MoveX/3;
}
y += yVel * (Delete + 1);

FadeIn = min(FadeIn + .25, 1);

xVel *= .91;
if(instance_exists(obj_Lava))
{
	yVel = max(yVel - .075, -MaxSpeed);
}
else
{
	yVel = max(yVel - .15, -MaxSpeed);
}

Breathed = min(Breathed + .1, 1);

/// -- Check

Timer --;
if(instance_exists(obj_Lava))
{
	Timer--;
}

/// -- Fade

if ((Timer <= 1 && yVel < 0) or Delete)
{
	if ((sprite_index != sprt_WaterBubble && sprite_index != sprt_WaterBubbleSmall) or Delete)
	{
		Alpha -= .025;
		if(instance_exists(obj_Lava))
		{
			Alpha -= .05;
		}
	}
}

 
if (CanBubble && !Spawned)
{
	if (CanSpread)
	{
		Spawned = 1;
  
		Max = 3;
		if (Delete)
		{
			Max = 1;
		}

		Bubble = instance_create_layer(floor(x-2+random(4)),floor(y+random(3)),"Liquids_fg",obj_WaterBubble);
		Bubble.Alpha = .75;
		Bubble.image_xscale = 1
		Bubble.image_yscale = 1;
		Bubble.Delete = Delete;
		Bubble.CanSpread = 0;
		Bubble.Index = choose(2,3,4);
		Bubble.sprite_index = choose(sprt_WaterBubbleTiny, sprt_WaterBubbleTiny2);
		Bubble.MaxSpeed *= (.9 + random(.1));
		Bubble.xVel = xVel/1.35;  
	}
}


if (!water_at(x,y) or Alpha <= 0)
{
	instance_destroy();
 
	if (Alpha > .05)
	{
		if (water_at(x,y+3))
		{
			repeat (3)
			{
				Pixel = instance_create_layer(x - 1 + irandom(2), y, "Liquids_fg", obj_SplashFXFade);
				Pixel.yVel = -.5;
				Pixel.Speed = .1;
				Pixel.image_index = irandom(2);
				Pixel.image_alpha = min(Alpha * 2, 1);
				Pixel.xVel = choose(-.5,-.3,-.15,.15,.3,.5);
			}
		}
	}
}

if (CanBubble == 0)
{
	CanBubble = 1;
	visible = 1;
 
	if (CanSpread)
	{ 
		if (instance_number(obj_WaterBubble) > 70)
		{
			if (choose(0,1) == 1)
			{
				instance_destroy();
			}
		}
  
		if (instance_number(obj_WaterBubble) > 120)
		{
			if (choose(0,1,1) == 1)
			{
				instance_destroy();
			}
		}
	}
 
	/*if !(oControl.DrawBubbles)
	{
		if (choose(0,1,1) == 1)
		{
			instance_destroy();
		}
	}*/
}