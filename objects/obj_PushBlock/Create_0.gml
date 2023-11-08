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

function explodePush(_proj,_velX)
{
	if(!place_meeting(x,y-2,obj_Player))
	{
		var _dir = sign(_velX);
		if(_velX == 0)
		{
			_dir = sign(x - _proj.x);
		}
		var _spd = 4;
		if(_proj.object_index == obj_MissileShot)
		{
			_spd = 6;
		}
		if(_proj.object_index == obj_SuperMissileShot)
		{
			_spd = 10;
		}
		if(_proj.x > bbox_left && _proj.x < bbox_right)
		{
			_spd *= abs(x - _proj.x) / (bbox_right-x);
			if(_spd <= 1 || (_velX != 0 && sign(_velX) != sign(x - _proj.x)))
			{
				_spd = 0;
			}
		}
		
		if(abs(_spd) > 0)
		{
			velX += _spd*_dir;
		}
	}
}

mBlockOffsetX = -16;
mBlockOffsetY = -16;
mBlock = instance_create_layer(x+mBlockOffsetX,y+mBlockOffsetX,"Collision",obj_MovingTile);
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
		
		var bbleft = position.X + (bbox_left-x),
			bbright = position.X + (bbox_right-x),
			bbbottom = position.Y + (bbox_bottom-y) + fVY;
		if(liquid)
		{
			repeat(8)
			{
				var bub = liquid.CreateBubble(irandom_range(bbleft,bbright),bbbottom,0,0);
				bub.canSpread = false;
				bub.kill = true;
			}
		}
		else
		{
			repeat(8)
			{
				part_particles_create(obj_Particles.partSystemB,irandom_range(bbleft,bbright),bbbottom,obj_Particles.bDust[1],1);
			}
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