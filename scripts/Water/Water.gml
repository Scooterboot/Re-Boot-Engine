#region water_init
function water_init(bottom)
{
	WaterBot = bottom;

	InWater = sign(in_water());
	InWaterPrev = InWater;
	InWaterTop = sign(in_water_top());
	InWaterTopPrev = InWaterTop;

	SplashY = y;

	//WaterLerp = 0;

	EnteredWater = -1;
	LeftWaterTop = -1;
	LeftWater = -1;

	WaterShuffleCount = 0;
	WaterShuffleSoundID[0] = snd_WaterShuffle1;
	WaterShuffleSoundID[1] = snd_WaterShuffle2;
	WaterShuffleSoundID[2] = snd_WaterShuffle3;
	WaterShuffleSoundID[3] = snd_WaterShuffle4;
}
#endregion
#region water_at
function water_at(argument0, argument1)
{

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
}
#endregion
#region in_water
function in_water()
{
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
}
#endregion
#region in_water_top
function in_water_top()
{
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
}
#endregion
#region water_splash
function water_splash(Mass,xVel,yVel,Into)
{
	var VelocityX = xVel*0.375;
	var VelocityY = yVel;
	var Sound = 1;

	/*if (object_index == oFXRubble)
	{
	    Into = 1;
	}

	if (object_index == oBomb)
	{
	    Sound = 0;
	}*/

	//var Final = Mass*abs(VelocityY);

	var SplashX = x;

	// -- Large splashes, for Samus sized objects
	var lavapitch = 0.8;
	if (Mass == 2)
	{
	    // -- A few drops spraying about
    
	    //if (VelocityY != 0)
	    if(abs(VelocityY) > 3)
	    {
	        if(!instance_exists(obj_Lava))
	        {
	            repeat (12)
	            {
	                var Drop = instance_create_layer(SplashX,SplashY-4,"Liquids_fg",obj_WaterDrop);
	                Drop.xVel = -2.25+random(4.5);
	                Drop.yVel = -.5-random(2.5);
	                Drop.xVel += VelocityX;
                
	                var Bubble = instance_create_layer(SplashX,SplashY+4,"Liquids_fg",obj_WaterBubble);
	                Bubble.xVel = -1.5+random(3);
	                Bubble.yVel = .4+random(1);
	            }
	        }
        
	        if (Sound)
	        {
	            //audio_stop_sound(snd_SplashLarge);
	            //audio_play_sound(snd_SplashLarge,0,false);
	            if(Into)
	            {
	                audio_stop_sound(snd_SplashLarge);
	                var snd = audio_play_sound(snd_SplashLarge,0,false);
	                audio_sound_pitch(snd,1);
	                if(instance_exists(obj_Lava))
	                {
	                    audio_sound_pitch(snd,lavapitch);
	                }
	            }
	            else
	            {
	                audio_stop_sound(snd_SplashLargeExit);
	                var snd = audio_play_sound(snd_SplashLargeExit,0,false);
	                audio_sound_pitch(snd,1);
	                if(instance_exists(obj_Lava))
	                {
	                    audio_sound_pitch(snd,lavapitch);
	                }
	            }
	        }
	    }
	    else
	    {
	        if (Sound)
	        {
	            if (Into)
	            {
	                audio_stop_sound(snd_SplashMedium);
	                var snd = audio_play_sound(snd_SplashMedium,0,false);
	                audio_sound_pitch(snd,1);
	                if(instance_exists(obj_Lava))
	                {
	                    audio_sound_pitch(snd,lavapitch);
	                }
	            }
	            else
	            {
	                if(audio_is_playing(snd_SplashSmall))
	                {
	                    audio_stop_sound(snd_SplashTiny2);
	                    var snd = audio_play_sound(snd_SplashTiny2,0,false);
	                    audio_sound_pitch(snd,1);
	                    if(instance_exists(obj_Lava))
	                    {
	                        audio_sound_pitch(snd,lavapitch);
	                    }
	                }
	                else
	                {
	                    audio_stop_sound(snd_SplashSmall);
	                    var snd = audio_play_sound(snd_SplashSmall,0,false);
	                    audio_sound_pitch(snd,1);
	                    if(instance_exists(obj_Lava))
	                    {
	                        audio_sound_pitch(snd,lavapitch);
	                    }
	                }
	            }
	        }
	    }
    
	    // -- Two sideways splash cascade
    
	    Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_Splasher);
	    Splash.xVel = 0.25 + max(VelocityX,-0.25); //1;
	    Splash.sprite_index = sprt_WaterSplashLarge;
	    Splash.image_alpha = 0.7;
	    Splash.image_xscale = 1;
    
	    //if (VelocityY == 0)
	    if(abs(VelocityY) <= 3)
	    {
			Splash.Size = .5;
	    }
    
	    Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_Splasher);
	    Splash.xVel = -0.25 + min(VelocityX,0.25); //1;
	    Splash.sprite_index = sprt_WaterSplashLarge;
	    Splash.image_alpha = 0.7;
	    Splash.image_xscale = -1;
    
	    //if (VelocityY == 0)
	    if(abs(VelocityY) <= 3)
	    {
			Splash.Size = .5;
	    }
    
	    // -- The one large splash effect
    
	    Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
	    Splash.Speed = .3333;
	    Splash.sprite_index = choose(sprt_WaterSplashLarge,sprt_WaterSplashHuge);
	    Splash.image_alpha = 0.7;
	    Splash.image_xscale = choose(1,-1);
	    Splash.depth = 65;
	    Splash.Splash = 1;
    
	    //if (VelocityY == 0)
	    if(abs(VelocityY) <= 3)
	    {
			Splash.image_xscale *= .8;
			Splash.image_yscale *= .5;
	    }
    
	    // -- The one large below-water splash effect
    
	    //if (VelocityY > 0)
	    /*if(abs(VelocityY) > 3)
	    {
			Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
			Splash.Speed = .4;
			Splash.sprite_index = sprt_WaterSplashHuge;
			Splash.image_alpha = 0.5;
			Splash.image_xscale = 1;
			Splash.image_yscale = -1;
			Splash.depth = 65;
	    }*/
    
	    // -- Blue water surface splash
    
	    Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
	    Splash.Speed = .25;
	    Splash.sprite_index = sprt_WaterSplash;
	    Splash.image_alpha = 0.225;
	    Splash.depth = 65.5;
    
	    //if (VelocityY == 0)
	    if(abs(VelocityY) <= 3)
	    {
			Splash.image_xscale *= .8;
			Splash.image_yscale *= .5;
			Splash.Speed = .333;
	    }
    
	    Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
	    Splash.Speed = .25;
	    Splash.sprite_index = sprt_WaterSplash;
	    Splash.image_alpha = 0.225;
	    Splash.image_xscale = -1;
	    Splash.depth = 65.5;
    
	    //if (VelocityY == 0)
	    if(abs(VelocityY) <= 3)
	    {
	        Splash.image_xscale *= .8;
	        Splash.image_yscale *= .5;
	        Splash.Speed = .333;
	    }
	}



	// -- Wave Beam "Splashes"
	else if (Mass == 1)
	{
	    // -- Blue water surface splash
    
	    Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
	    Splash.Speed = .25;
	    Splash.sprite_index = sprt_WaterSplash;
	    Splash.image_alpha = 0.225;
	    Splash.depth = 65.5;
	    Splash.image_xscale *= .8;
	    Splash.image_yscale *= .5;
	    Splash.Speed = .333;
    
	    if (VelocityY == 0 or (object_is_ancestor(object_index,obj_Projectile) && type == ProjType.Beam))//isBeam))
	    {
	        Splash.image_xscale *= .6;
	        Splash.image_yscale *= .35;
	        Splash.Speed = .35;
	    }
    
	    Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
	    Splash.Speed = .25;
	    Splash.sprite_index = sprt_WaterSplash;
	    Splash.image_alpha = 0.225;
	    Splash.image_xscale = -1;
	    Splash.depth = 65.5;
	    Splash.image_xscale *= .8;
	    Splash.image_yscale *= .5;
	    Splash.Speed = .333;
    
	    if (VelocityY == 0 or (object_is_ancestor(object_index,obj_Projectile) && type == ProjType.Beam))//isBeam))
	    {
	        Splash.image_xscale *= .6;
	        Splash.image_yscale *= .35;
	        Splash.Speed = .35;
	    }
	}



	// -- Medium splashes, for Missile sized objects

	else if (Mass == 0)
	{
		CancelSound = 0;
 
		/*if (object_index == oSpazerFire)
		{
			if (CantSound)
			{
				CancelSound = 1;
			}
		}*/
 
		if (Sound)
		{
			if (Into && (!object_is_ancestor(object_index,obj_Projectile) || (object_is_ancestor(object_index,obj_Projectile) && type != ProjType.Beam)))//!isBeam)))//object_index != oBeam && object_index != oPebble)
			{
				//sound_play_pos(sndSplashSmall,x,y);
				//audio_stop_sound(snd_SplashSmall);
				//audio_play_sound(snd_SplashSmall,0,false);
				audio_play_sound(snd_SplashTiny,0,false);
			}
			else if (!CancelSound)
			{
				//audio_stop_sound(sndSplashTiny);
				//sound_play_pos(sndSplashTiny,x,y);
				//audio_stop_sound(snd_SplashTiny);
				//audio_play_sound(snd_SplashTiny,0,false);
				audio_stop_sound(snd_SplashSkid);
				audio_play_sound(snd_SplashSkid,0,false);
			}
		}

		// -- A few drops spraying about
 
		if (VelocityY != 0 && (!object_is_ancestor(object_index,obj_Projectile) || (object_is_ancestor(object_index,obj_Projectile) && type != ProjType.Beam)))//!isBeam)))// && object_index != oPebble)
		{
			repeat (4)
			{
				var Drop = instance_create_layer(SplashX,SplashY-4,"Liquids_fg",obj_WaterDrop);
				Drop.xVel = -2.25+random(4.5);
				Drop.yVel = -.5-random(2.5);
				Drop.xVel += VelocityX;
			}
		} 
 
		// -- Two sideways splash cascade
 
		Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_Splasher);
		Splash.xVel = 0.2 + max(VelocityX,-0.2);//.8;
		Splash.sprite_index = sprt_WaterSplashLarge;
		Splash.image_alpha = 0.7;
		Splash.image_xscale = 1;
		Splash.Size = .5; 
 
		if (VelocityY == 0 or (object_is_ancestor(object_index,obj_Projectile) && type == ProjType.Beam))//isBeam))
		{
			Splash.Size = .25;
		}
 
		Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_Splasher);
		Splash.xVel = -0.2 + min(VelocityX,0.2)//-.8;
		Splash.sprite_index = sprt_WaterSplashLarge;
		Splash.image_alpha = 0.7;
		Splash.image_xscale = -1;
		Splash.Size = .5; 
 
		if (VelocityY == 0 or (object_is_ancestor(object_index,obj_Projectile) && type == ProjType.Beam))//isBeam))
		{
			Splash.Size = .25;
		} 
 
 
		// -- The one large splash effect
 
		Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
		Splash.Speed = .3333;
		Splash.sprite_index = choose(sprt_WaterSplashLarge,sprt_WaterSplashHuge);
		Splash.image_alpha = 0.7;
		Splash.image_xscale = choose(1,-1);
		Splash.depth = 65;
		Splash.Splash = 1;
		Splash.image_xscale *= .7;
		Splash.image_yscale *= .7;
 
		if (VelocityY == 0 or (object_is_ancestor(object_index,obj_Projectile) && type == ProjType.Beam))//isBeam))
		{
			Splash.image_xscale *= .8;
			Splash.image_yscale *= .7;
		}
 
		// -- Blue water surface splash
 
		Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
		Splash.Speed = .25;
		Splash.sprite_index = sprt_WaterSplash;
		Splash.image_alpha = 0.225;
		Splash.depth = 65.5;
		Splash.image_xscale *= .8;
		Splash.image_yscale *= .5;
		Splash.Speed = .333;

		if (VelocityY == 0 or (object_is_ancestor(object_index,obj_Projectile) && type == ProjType.Beam))//isBeam))
		{
			Splash.image_xscale *= .6;
			Splash.image_yscale *= .35;
			Splash.Speed = .35;
		}
 
		Splash = instance_create_layer(SplashX,SplashY,"Liquids_fg",obj_SplashFXAnim);
		Splash.Speed = .25;
		Splash.sprite_index = sprt_WaterSplash;
		Splash.image_alpha = 0.225;
		Splash.image_xscale = -1;
		Splash.depth = 65.5;
		Splash.image_xscale *= .8;
		Splash.image_yscale *= .5;
		Splash.Speed = .333;

		if (VelocityY == 0 or (object_is_ancestor(object_index,obj_Projectile) && type == ProjType.Beam))//isBeam))
		{
			Splash.image_xscale *= .6;
			Splash.image_yscale *= .35;
			Splash.Speed = .35;
		}
	}
}
#endregion
#region water_update
function water_update(Mass,xVel,yVel)
{
	InWater = sign(in_water());
	InWaterTop = sign(in_water_top());
	EnteredWater = max(EnteredWater-2,0);
	LeftWater = max(LeftWater-2,0);
	LeftWaterTop = max(LeftWaterTop-2,0);
	SplashY = y;

	if (InWaterPrev != InWater)
	{
		InWaterPrev = InWater;
 
		if (InWater)
		{
			water_splash(Mass,xVel,yVel,1);
			EnteredWater = (Mass+1)*30;
		}
		else
		if (!object_is_ancestor(object_index,obj_Projectile) || (object_is_ancestor(object_index,obj_Projectile) && type != ProjType.Beam))//!object_index.isBeam))
		{
			water_splash(Mass,xVel,0,0);
			LeftWater = (Mass+1)*15;
		}
	}

	if (InWaterTopPrev != InWaterTop)
	{
		InWaterTopPrev = InWaterTop;
 
		if (!InWaterTop) && (!object_is_ancestor(object_index,obj_Projectile) || (object_is_ancestor(object_index,obj_Projectile) && type != ProjType.Missile))//!object_index.isMissile))
		{
			water_splash(Mass,xVel,yVel,0);
			LeftWaterTop = (Mass+1)*25;
		} 
	}
}
#endregion