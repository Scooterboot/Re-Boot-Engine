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

solids = array_concat(ColType_Solid,ColType_MovingSolid);

moveSnd = noone;
sndStopped = false;

function explodePush(_proj,_velX)
{
	if(!place_meeting(x,y-2,obj_Player) || _proj.y > bb_top())
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
		if(_proj.x > bb_left() && _proj.x < bb_right() && (_proj.y < bb_top() || _proj.y > bb_bottom()))
		{
			_spd *= abs(x - _proj.x) / (bb_right(x)-x);
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


function ModifyFinalVelY(fVY)
{
	var fellVel = 1;
	if((entity_place_collide(0,fVY+fellVel) || (bb_bottom()+fVY+fellVel) >= room_height) && fVY >= 0)
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

function ModifySlopeXSteepness_Up()
{
	return 2;
}
function ModifySlopeXSteepness_Down()
{
	return 3;
}
function ModifySlopeYSteepness_Up()
{
	return 1;
}
function ModifySlopeYSteepness_Down()
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
		
		if(liquid)
		{
			repeat(8)
			{
				var bub = liquid.CreateBubble(irandom_range(bb_left(),bb_right()), bb_bottom()+fVY, 0, 0);
				bub.canSpread = false;
				bub.kill = true;
			}
		}
		else
		{
			repeat(8)
			{
				part_particles_create(obj_Particles.partSystemB, irandom_range(bb_left(),bb_right()), bb_bottom()+fVY, obj_Particles.bDust[1], 1);
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