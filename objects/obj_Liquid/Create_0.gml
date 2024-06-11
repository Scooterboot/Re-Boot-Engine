/// @description Initialize

enum LiquidType
{
	Water,
	Lava,
	Acid
}
liquidType = LiquidType.Water;

time = 0;

posX = 0;
velX = 0;

moveY = false;
bottom = bbox_bottom;
bobAcc = -(1 / 256);//-0.0125/4;
bobSpeed = 0;//-0.05;
bobBtm = 0.25;

liquidShuffleCount = 0;
liquidShuffleSnd[0] = snd_WaterShuffle1;
liquidShuffleSnd[1] = snd_WaterShuffle2;
liquidShuffleSnd[2] = snd_WaterShuffle3;
liquidShuffleSnd[3] = snd_WaterShuffle4;

liquidShuffleSnd[4] = snd_LavaShuffle1;
liquidShuffleSnd[5] = snd_LavaShuffle2;
liquidShuffleSnd[6] = snd_LavaShuffle3;
liquidShuffleSnd[7] = snd_LavaShuffle4;

#region CreateSplash
function CreateSplash(_entity, _mass, _velX, _velY, _into, _sound = true, _isBeam = false)
{
	var vx = _velX*0.375,
		vy = _velY;
	
	/*var pitch = 1;
	if(liquidType == LiquidType.Lava)
	{
		pitch = 0.8;
	}*/
	var _snd = "";
	if(liquidType == LiquidType.Lava)
	{
		_snd = "_Lava";
	}
	
	var splX = _entity.x,
		splY = bbox_top;
	
	#region mass of 2 (indicates player-sized objects)
	if(_mass == 2)
	{
		if(abs(vy) > 3)
		{
			if(liquidType != LiquidType.Lava)
			{
				repeat(12)
				{
					var drop = instance_create_layer(splX,splY-4,layer,obj_WaterDrop);
					drop.liquidType = liquidType;
					drop.velX = -2.25 + random(4.5) + vx;
					drop.velY = -1.5 - random(2.5);
					
					var bub = CreateBubble(splX,splY+4, -1.5 + random(3), 0.4 + random(1));
					bub.spriteIndex = sprt_WaterBubble;
				}
			}
        
	        if(_sound)
	        {
	            if(_into)
	            {
	                //audio_stop_sound(snd_SplashLarge);
	                //audio_play_sound(snd_SplashLarge,0,false, 1,0,pitch);
					var sndIndex = asset_get_index("snd_SplashLarge"+_snd);
					audio_stop_sound(sndIndex);
					audio_play_sound(sndIndex,0,false);
	            }
	            else
	            {
	                //audio_stop_sound(snd_SplashLargeExit);
	                //audio_play_sound(snd_SplashLargeExit,0,false, 1,0,pitch);
					var sndIndex = asset_get_index("snd_SplashLargeExit"+_snd);
					audio_stop_sound(sndIndex);
					audio_play_sound(sndIndex,0,false);
	            }
	        }
		}
		else
		{
			if(_sound)
	        {
	            if(_into)
	            {
	                //audio_stop_sound(snd_SplashMedium);
	                //audio_play_sound(snd_SplashMedium,0,false, 1,0,pitch);
					var sndIndex = asset_get_index("snd_SplashMedium"+_snd);
					audio_stop_sound(sndIndex);
					audio_play_sound(sndIndex,0,false);
	            }
	            else
	            {
					var sndIndex = asset_get_index("snd_SplashSmall"+_snd);
	                if(audio_is_playing(sndIndex))
	                {
	                    //audio_stop_sound(snd_SplashTiny2);
	                    //audio_play_sound(snd_SplashTiny2,0,false, 1,0,pitch);
						var sndIndex2 = asset_get_index("snd_SplashTiny2"+_snd);
						audio_stop_sound(sndIndex2);
						audio_play_sound(sndIndex2,0,false);
	                }
	                else
	                {
	                    //audio_stop_sound(snd_SplashSmall);
	                    //audio_play_sound(snd_SplashSmall,0,false, 1,0,pitch);
						audio_stop_sound(sndIndex);
						audio_play_sound(sndIndex,0,false);
	                }
	            }
	        }
		}
		
		
		// --- Two sideways splash cascade ---
		var splash = instance_create_layer(splX,splY,layer,obj_Splasher);
		splash.liquid = id;
		splash.image_xscale = 1;
		splash.image_alpha = 0.7;
		splash.velX = 0.25 + min(vx,0.25);
		if(abs(vy) <= 3)
	    {
			splash.scale = 0.5;
	    }
		
		splash = instance_create_layer(splX,splY,layer,obj_Splasher);
		splash.liquid = id;
		splash.image_xscale = -1;
		splash.image_alpha = 0.7;
		splash.velX = -0.25 + min(vx,0.25);
		if(abs(vy) <= 3)
	    {
			splash.scale = 0.5;
	    }
		// ------
		
		
		// --- The one large splash effect ---
		splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
		splash.liquid = id;
		splash.sprite_index = choose(sprt_WaterSplashLarge,sprt_WaterSplashHuge);
		splash.image_xscale = choose(1,-1);
		splash.image_alpha = 0.7;
		splash.depth += 1;
		splash.splash = true;
		splash.animSpeed = 1.0 / 3;
		if(abs(vy) <= 3)
		{
			splash.image_xscale *= 0.8;
			splash.image_yscale *= 0.5;
		}
		// ------
		
		/*// --- The one large below-water splash effect ---
		if(abs(vy) > 3)
		{
			splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
			splash.liquid = id;
			splash.sprite_index = sprt_WaterSplashHuge;
			splash.image_xscale = 1;
			splash.image_yscale = -1;
			splash.image_alpha = 0.5;
			splash.depth += 1;
			splash.animSpeed = 0.4;
		}
		// ------*/
		
		// --- Blue water surface splash ---
		splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
		splash.liquid = id;
		splash.sprite_index = sprt_WaterSplash;
		splash.image_alpha = 0.225;
		splash.depth += 2;
		splash.animSpeed = 0.25;
		if(abs(vy) <= 3)
		{
			splash.image_xscale *= 0.8;
			splash.image_yscale *= 0.5;
			splash.animSpeed = 1.0 / 3;
		}
		
		splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
		splash.liquid = id;
		splash.sprite_index = sprt_WaterSplash;
		splash.image_xscale = -1;
		splash.image_alpha = 0.225;
		splash.depth += 2;
		splash.animSpeed = 0.25;
		if(abs(vy) <= 3)
		{
			splash.image_xscale *= 0.8;
			splash.image_yscale *= 0.5;
			splash.animSpeed = 1.0 / 3;
		}
		// ------
	}
	#endregion
	
	#region mass of 1 (indicates projectile-sized objects)
	if(_mass == 1)
	{
		if (_sound)
		{
			if (_into && !_isBeam)
			{
				//audio_play_sound(snd_SplashTiny,0,false, 1,0,pitch);
				var sndIndex = asset_get_index("snd_SplashTiny"+_snd);
				audio_play_sound(sndIndex,0,false);
			}
			else
			{
				//audio_stop_sound(snd_SplashSkid);
				//audio_play_sound(snd_SplashSkid,0,false, 1,0,pitch);
				var sndIndex = asset_get_index("snd_SplashSkid"+_snd);
				audio_stop_sound(sndIndex);
				audio_play_sound(sndIndex,0,false);
			}
		}

		// --- spraying droplets ---
		if (vy != 0 && !_isBeam)
		{
			repeat (4)
			{
				var drop = instance_create_layer(splX,splY,layer,obj_WaterDrop);
				drop.liquidType = liquidType;
				drop.velX = -2.25 + random(4.5) + vx;
				drop.velY = -0.5 - random(2.5);
			}
		}
		// ------

		// -- Two sideways splash cascade
		var splash = instance_create_layer(splX,splY,layer,obj_Splasher);
		splash.liquid = id;
		splash.image_xscale = 1;
		splash.scale = 0.5;
		splash.image_alpha = 0.7;
		splash.velX = 0.2 + max(vx, -0.2);
		if (vy == 0 || _isBeam)
		{
			splash.scale = 0.25;
		}

		splash = instance_create_layer(splX,splY,layer,obj_Splasher);
		splash.liquid = id;
		splash.image_xscale = -1;
		splash.scale = 0.5;
		splash.image_alpha = 0.7;
		splash.velX = -0.2 + min(vx, 0.2);
		if (vy == 0 || _isBeam)
		{
			splash.scale = 0.25;
		} 

		// --- The one large splash effect ---
		splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
		splash.liquid = id;
		splash.sprite_index = choose(sprt_WaterSplashLarge,sprt_WaterSplashHuge);
		splash.image_xscale = choose(1,-1) * 0.7;
		splash.image_yscale = 0.7;
		splash.image_alpha = 0.7;
		splash.depth += 1;
		splash.splash = true;
		splash.animSpeed = 1.0 / 3;
		if (vy == 0 || _isBeam)
		{
			splash.image_xscale *= 0.8;
			splash.image_yscale *= 0.7;
		}
		// ------
 
		// --- Blue water surface splash ---
		splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
		splash.liquid = id;
		splash.sprite_index = sprt_WaterSplash;
		splash.image_xscale = 0.8;
		splash.image_yscale = 0.5;
		splash.image_alpha = 0.225;
		splash.depth += 2;
		splash.animSpeed = 1.0 / 3;
		if (vy == 0 || _isBeam)
		{
			splash.image_xscale *= 0.6;
			splash.image_yscale *= 0.35;
			splash.animSpeed = 0.35;
		}

		splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
		splash.liquid = id;
		splash.sprite_index = sprt_WaterSplash;
		splash.image_xscale = -0.8;
		splash.image_yscale = 0.5;
		splash.image_alpha = 0.225;
		splash.depth += 2;
		splash.animSpeed = 1.0 / 3;
		if (vy == 0 || _isBeam)
		{
			splash.image_xscale *= 0.6;
			splash.image_yscale *= 0.35;
			splash.animSpeed = 0.35;
		}
		// ------
	}
	#endregion
	
	#region mass of 0 (for wave beam or similar)
	if(_mass == 0)
	{
		// -- Blue water surface splash
		
		var splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
		splash.liquid = id;
		splash.sprite_index = sprt_WaterSplash;
		splash.image_xscale = 0.8;
		splash.image_yscale = 0.5;
		splash.image_alpha = 0.225;
		splash.depth += 2;
		splash.animSpeed = 1.0 / 3;
		if(vy == 0 || _isBeam)
		{
			splash.image_xscale *= 0.6;
			splash.image_yscale *= 0.35;
			splash.animSpeed = 0.35;
		}
		
		splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
		splash.liquid = id;
		splash.sprite_index = sprt_WaterSplash;
		splash.image_xscale = -0.8;
		splash.image_yscale = 0.5;
		splash.image_alpha = 0.225;
		splash.depth += 2;
		splash.animSpeed = 1.0 / 3;
		if(vy == 0 || _isBeam)
		{
			splash.image_xscale *= 0.6;
			splash.image_yscale *= 0.35;
			splash.animSpeed = 0.35;
		}
	}
	#endregion
}
#endregion
#region CreateSplash_Extra
function CreateSplash_Extra(_entity, _size, _velX, _velY, _sound = true, _skidSound = true)
{
	/*var pitch = 1;
	if(liquidType == LiquidType.Lava)
	{
		pitch = 0.8;
	}*/
	var _snd = "";
	var _count = 0;
	if(liquidType == LiquidType.Lava)
	{
		_snd = "_Lava";
		_count = 4;
	}
	
	var splX = irandom_range(_entity.bbox_left+1,_entity.bbox_right-1),
		splY = bbox_top;
	
	var splash = instance_create_layer(splX,splY,layer,obj_SplashFXAnim);
	splash.liquid = id;
	splash.sprite_index = sprt_WaterSplashSmall;
	splash.image_index = 3;
	splash.image_xscale = choose(1,-1);
	splash.image_alpha = 0.4;
	splash.depth += 1;
	splash.splash = true;
	splash.animSpeed = 0.25;
	
	if (_velX == 0 && abs(_velY) < 2)
	{
		splash.sprite_index = sprt_WaterSplashTiny;
		splash.image_index = 0;
		splash.image_yscale = choose(0.3,0.5,0.7,1);
		splash.image_xscale = choose(1.4,1);
		splash.x += irandom_range(-2,2);
	}
	else if (abs(_velX) > 0 && !_entity.stepSplash)
	{
		splash.sprite_index = sprt_WaterSkid;
		splash.image_index = 1;
		splash.image_xscale = choose(1,-1);
		splash.image_yscale = (0.4 + min(0.6,abs(_velX)/10)) * (choose(1, 0.5 + random(0.4)));
		splash.image_alpha = 0.6;
		splash.splash = false;
		splash.velX = _velX/4.5;
		splash.x += _velX * 2;
		splash.y--;
		
		_entity.stepSplash = 2;
		
		if (choose(0,1,1) == 0)
		{
			splash.image_yscale *= 0.1;
			_entity.stepSplash = 1;
		}
	}

	if(_size == 1)
	{
		splash.sprite_index = sprt_WaterSkidLarge;
		splash.image_index = 0;
		splash.image_yscale = 1;
		splash.image_xscale = 1;
		splash.image_alpha = 0.5;
		splash.splash = false;
		splash.animSpeed = 0.5;
		splash.x -= _velX;
		repeat (3)
		{
			var drop = instance_create_layer(_entity.x,splY-4,layer,obj_WaterDrop);
			drop.liquidType = liquidType;
			drop.velX = -2.25+random(4.5) + _velX/2;
			drop.velY = -0.5-random(2.5);
		}
		
		if (_sound && _skidSound)
		{
			//audio_play_sound(snd_SplashSkid,0,false);
			var sndIndex = asset_get_index("snd_SplashSkid"+_snd);
			audio_play_sound(sndIndex,0,false);
		}
	}
	
	if (_sound && (!audio_is_playing(liquidShuffleSnd[liquidShuffleCount+_count]) || (abs(_velX) > 0 && irandom(7) == 0)) && (abs(_velX) > 0 || irandom(23) == 0))
	{
		audio_play_sound(liquidShuffleSnd[liquidShuffleCount+_count],0,false);
		liquidShuffleCount = choose(0,1,2,3);
	}
}
#endregion
#region CreateBubble

bubbleList = ds_list_create();
function CreateBubble(_x, _y, _velX, _velY)
{
	var bub = new Bubble(id, _x, _y, _velX, _velY);
	ds_list_add(bubbleList,bub);
	return bub;
}

function Bubble(_liq, _x, _y, _velX, _velY) constructor
{
	liquid = _liq;
	
	posX = _x;
	posY = _y;
	velX = _velX;
	velY = _velY;
	
	maxSpeed = 0.5;
	
	spriteIndex = sprt_WaterBubbleSmall;
	canSpread = true;
	breathed = 1;
	
	fadeIn = 0;
	kill = false;
	canBubble = false;
	spawned = false;
	
	timer = 25 + random(40);
	index = irandom(4);
	
	imgAlpha = 0.833-random(0.1);
	alpha = imgAlpha;
	alphaMult = 0.9;
	scale = choose(1, 0.9, 0.8, 0.7);
	
	_delete = false;
	
	function Update()
	{
		var extraRng = 64,
			cam = obj_Camera;
		if (!instance_exists(cam) || 
			posX < cam.x-extraRng || posX > cam.x+global.resWidth+extraRng || 
			posY < cam.y-extraRng || posY > cam.y+global.resHeight+extraRng)
		{
			_delete = true;
			exit;
		}
		
		if(!canBubble)
		{
			if(canSpread)
			{
				if(ds_list_size(liquid.bubbleList) > 70 && choose(0,1) == 1)
				{
					_delete = true;
					exit;
				}
				if(ds_list_size(liquid.bubbleList) > 120 && choose(0,1,1) == 1)
				{
					_delete = true;
					exit;
				}
			}
			
			canBubble = true;
		}
		
		posX += velX + liquid.velX / 3;
		posY += velY * (1 + kill);
		
		timer--;
		velX *= 0.91;
		if(liquid.liquidType == LiquidType.Lava)
		{
			if(spriteIndex == sprt_WaterBubble)
			{
				spriteIndex = sprt_WaterBubbleSmall;
			}
			timer--;
			velY = max(velY-0.075,-maxSpeed);
		}
		else
		{
			velY = max(velY-0.015,-maxSpeed);
		}
		
		if(spriteIndex == sprt_WaterBubbleSmall)
		{
			index += 0.25;
			if(index >= 20)
			{
				spriteIndex = choose(sprt_WaterBubbleTiny,sprt_WaterBubbleTiny2);
			}
		}
		else
		{
			index += 0.2;
			if(spriteIndex == sprt_WaterBubble)
			{
				index += 0.3;
				if(index >= 18)
				{
					spriteIndex = sprt_WaterBubbleTiny;
					repeat(3)
					{
						var bub = liquid.CreateBubble(floor(posX-2+irandom(4)),floor(posY+irandom(3)),velX/1.35,0);
						bub.spriteIndex = choose(sprt_WaterBubbleTiny,sprt_WaterBubbleTiny2);
						bub.index = choose(2,3,4);
						bub.alpha = 0.75;
						bub.kill = kill;
						bub.canSpread = false;
						bub.maxSpeed *= (0.9 + random(0.1));
					}
				}
			}
		}
		
		breathed = min(breathed+0.1,1);
		fadeIn = min(fadeIn+0.25, 1);
		
		if((timer <= 1 && velY < 0) || kill)
		{
			if((spriteIndex != sprt_WaterBubble && spriteIndex != sprt_WaterBubbleSmall) || kill)
			{
				alpha -= 0.025;
				if(liquid.liquidType == LiquidType.Lava)
				{
					alpha -= 0.05;
				}
			}
		}
		if(alpha <= 0)
		{
			_delete = true;
			exit;
		}
		
		if(canBubble && !spawned)
		{
			if(canSpread)
			{
				var bub = liquid.CreateBubble(floor(posX-2+irandom(4)),floor(posY+irandom(3)),velX/1.35,0);
				bub.spriteIndex = choose(sprt_WaterBubbleTiny,sprt_WaterBubbleTiny2);
				bub.index = choose(2,3,4);
				bub.alpha = 0.75;
				bub.kill = kill;
				bub.canSpread = false;
				bub.maxSpeed *= (0.9 + random(0.1));
				
				spawned = true;
			}
		}
		
		if(!collision_point(posX,posY,obj_Liquid,false,true))
		{
			if(alpha > 0.05)
			{
				if(collision_point(posX,posY+3,obj_Liquid,false,true))
				{
					repeat(3)
					{
						var spl = instance_create_layer(posX - 1 + irandom(2), posY, "Liquids_fg", obj_SplashFXFade);
						spl.liquid = liquid;
						spl.image_index = irandom(2);
						spl.image_alpha = min(alpha * 2, 1);
						spl.velX = choose(-0.5,-0.3,-0.15,0.15,0.3,0.5);
						spl.velY = -0.5;
						spl.animSpeed = 0.1;
					}
				}
			}
			
			_delete = true;
		}
	}
	
	function Draw()
	{
		if(_delete)
		{
			exit;
		}
		
		var fAlpha = (1+alpha)/2*alphaMult;
		
		if (canSpread && !kill)
		{
			fAlpha = alpha * 0.8 * fadeIn;
			scale = breathed;
		}
		else
		{
			fAlpha = alpha * 0.9 * fadeIn;
			scale = 1;
		}
		
		var sprIndex = spriteIndex;
		if(liquid.liquidType == LiquidType.Lava)
		{
			sprIndex = scr_ConvertToLavaSprite(spriteIndex);
		}
		else if(liquid.liquidType == LiquidType.Acid)
		{
			sprIndex = scr_ConvertToAcidSprite(spriteIndex);
		}
		
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprIndex,index,posX,posY,scale,scale,0,c_white,fAlpha);
		gpu_set_blendmode(bm_normal);
	}
}

#endregion

spriteW = sprite_get_width(sprite_index);
spriteH = sprite_get_height(sprite_index);
function scaledW() { return spriteW * image_xscale; }
function scaledH() { return spriteH * image_yscale; }