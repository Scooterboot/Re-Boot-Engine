/// @description 
event_inherited();

image_speed = 0;
image_index = 0;

//isBeingPushed = false;
enum PushState
{
	None,
	Push,
	Grapple
}
pushState = PushState.None;

grav[0] = 0.33;//0.11;
grav[1] = 0.1;//0.05;
fGrav = grav[0];

justFell = false;

grounded = true;

solids[0] = "ISolid";
solids[1] = "IMovingSolid";
solids[2] = "IPlayer";

moveSnd = noone;
sndStopped = false;

water_init(bbox_bottom-y);
CanSplash = 1;
StepSplash = 0;

#region pushblock_water
function pushblock_water()
{
	var xVel = x - xprevious,
		yVel = y - yprevious;
    
	WaterBot = bbox_bottom-y;

	water_update(2,xVel,yVel);

	/// -- Extra Splash -- \\\

	CanSplash ++;

	if (CanSplash > 65535)
	{
		CanSplash = 0;
	}

	if (in_water() && !in_water_top() && (CanSplash mod 2 == 0))
	{
		var splashx = x+random_range(16,-16);
		Splash = instance_create_layer(splashx,SplashY,"Liquids_fg",obj_SplashFXAnim);
		Splash.Speed = .25;
		Splash.sprite_index = sprt_WaterSplashSmall;
		Splash.image_alpha = 0.4;
		Splash.depth = 65;
		Splash.Splash = 1;
		Splash.image_index = 3;
		Splash.image_xscale = choose(1,-1);
    
		if (xVel == 0 && yVel == 0)
		{
			/*Splash.image_yscale = .65;
			Splash.image_index = 5;
			Splash.image_xscale = .75;*/
			Splash.image_yscale = choose(.3,.5,.7,1);
			Splash.image_index = 0;
			Splash.image_xscale = choose(1.4,1);
			Splash.sprite_index = sprt_WaterSplashTiny;
			Splash.x += irandom(4) - 2;
		}
		else if (abs(xVel) > 1 && !StepSplash)
		{
			Splash.sprite_index = sprt_WaterSkid;
			Splash.image_alpha = 0.6;
			Splash.depth = 65;
			Splash.image_index = 1;
			Splash.image_xscale = choose(1,-1);
			Splash.Splash = 0;
			Splash.x += xVel * 2;
			Splash.xVel = xVel/4.5;
			Splash.image_yscale = (.4 + min(.6,abs(xVel)/10)) * (choose(1, .5 + random(.4)));//.8 + random(.2);
			Splash.y --;
        
			StepSplash = 2;
        
			/*if (choose(0,1,1) == 0)
			{
				Splash.image_yscale *= .1;
				StepSplash = 1;
			}*/
		}
	}

	/// -- Underwater Bubbles -- \\\ 

	if ((EnteredWater /*or (State == "DASH" && InWater)*/) && choose(1,1,1,0) == 1)
	{
		Bubble = instance_create_layer(x-16+random(32),bbox_bottom+random(bbox_top-y),"Liquids_fg",obj_WaterBubble);
 
		if (yVel > 0)
		{
			Bubble.yVel += yVel/4;
		}
 
		if (EnteredWater < 60 && (!grounded || abs(xVel) < 5))
		{
			Bubble.Alpha *= (EnteredWater/60);
			Bubble.AlphaMult *= (EnteredWater/60);
		} 
	}

	/// -- Leaving Drops

	if (LeftWater && choose(1,1,1,0,0) == 1)
	{
		Drop = instance_create_layer(x-16+random(32),y+4,"Liquids_fg",obj_WaterDrop);
 
		with (Drop)
		{
			if (water_at(x,y))
			{
				Dead = 1;
				instance_destroy();
			}
		}
	}

	if (LeftWaterTop && choose(1,1,1,0,0) == 1)
	{
		Drop = instance_create(x-16+random(32),bbox_bottom+random(bbox_top-y+4),"Liquids_fg",obj_WaterDrop);
 
		with (Drop)
		{
			if (water_at(x,y))
			{
				Dead = 1;
				instance_destroy();
			}
		}
	}
}
#endregion

mBlock = instance_create_layer(x-16,y-16,"Collision",obj_MovingTile);
mBlock.image_xscale = 2;
mBlock.image_yscale = 2;
mBlock.ignoredEntity = id;

passthru = 0;
passthruMax = 2;

block_list = ds_list_create();

function entity_place_collide()
{
	/// @description entity_place_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = scr_round(position.X),
		yy = scr_round(position.Y);
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	//return lhc_place_meeting(xx+offsetX,yy+offsetY,solids);
	return SkipOwnMovingTile(instance_place_list(xx+offsetX,yy+offsetY,all,block_list,true));
}

function entity_position_collide()
{
	/// @description entity_position_collide
	/// @param offsetX
	/// @param offsetY
	/// @param baseX=x
	/// @param baseY=y
	
	var offsetX = argument[0],
		offsetY = argument[1],
		xx = scr_round(position.X),
		yy = scr_round(position.Y);
	if(argument_count > 2)
	{
		xx = argument[2];
		if(argument_count > 3)
		{
			yy = argument[3];
		}
	}
	//return lhc_position_meeting(xx+offsetX,yy+offsetY,solids);
	return SkipOwnMovingTile(instance_position_list(xx+offsetX,yy+offsetY,all,block_list,true));
}

function entity_collision_line(x1,y1,x2,y2, prec = true, notme = true)
{
	//return lhc_collision_line(x1,y1,x2,y2,solids,prec,notme);
	return SkipOwnMovingTile(collision_line_list(x1,y1,x2,y2,all,prec,notme,block_list,true));
}

function SkipOwnMovingTile(num, checkOnlyMoving = false)
{
	for(var i = 0; i < num; i++)
	{
		if(instance_exists(block_list[| i]) && 
		((asset_has_any_tag(block_list[| i].object_index,solids,asset_object) && !checkOnlyMoving) ||
		(asset_has_any_tag(block_list[| i].object_index,"IMovingSolid",asset_object) && checkOnlyMoving)))
		{
			var block = block_list[| i];
			
			if(block != mBlock)
			{
				ds_list_clear(block_list);
				return true;
			}
		}
	}
	ds_list_clear(block_list);
	return false;
}

function ModifyFinalVelY(fVY)
{
	var fellVel = 1;
	if((entity_place_collide(0,fVY+fellVel) || (bbox_bottom+fVY+fellVel) >= room_height) && fVY >= 0)
	{
		justFell = true;
	}
	else
	{
		if(justFell && fVY >= 0 && fVY <= fGrav)
		{
			fVY += fellVel;
		}
		justFell = false;
	}
	return fVY;
}

function ModifySlopeXSteepness_Up(steepness)
{
	return 2;
}
function ModifySlopeXSteepness_Down(steepness)
{
	return 3;
}
function ModifySlopeYSteepness_Up(steepness)
{
	return 1;
}
function ModifySlopeYSteepness_Down(steepness)
{
	return 2;
}

function OnXCollision(fVX)
{
	velX = 0;
	fVelX = 0;
}

function OnBottomCollision(fVY)
{
	if(!grounded)
	{
		audio_play_sound(snd_PushBlock_Land,0,false);
			
		repeat(8)
		{
			var bbleft = position.X + (bbox_left-x),
				bbright = position.X + (bbox_right-x),
				bbbottom = position.Y + (bbox_bottom-y) + fVY;
			part_particles_create(obj_Particles.partSystemB,irandom_range(bbleft,bbright),bbbottom,obj_Particles.bDust[1],1);
		}
			
		grounded = true;
	}
}

function OnYCollision(fVY)
{
	velY = 0;
	fVelY = 0;
}

function CanMoveUpSlope_Right()
{
	return CanMoveUpSlope_LeftRight(-1);
}

function CanMoveUpSlope_Left()
{
	return CanMoveUpSlope_LeftRight(1);
}
function CanMoveUpSlope_LeftRight(dir)
{
	if(!grounded)
	{
		var yspeed = abs(fVelY);
		var ynum = 0;
		while(!entity_place_collide(0,ynum) && ynum <= yspeed)
		{
			ynum++;
		}
		
		var steepFlag = !entity_place_collide(dir,ynum+1);
		return (fVelY >= 0 && steepFlag);
	}
	return false;
}