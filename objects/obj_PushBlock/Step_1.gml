/// @description 

if(global.gamePaused)
{
	exit;
}

var sfxFlag = false,
	dustFlag = false;
var player = instance_place(x-2,y,obj_Player);
if(!instance_exists(player))
{
	player = instance_place(x+2,y,obj_Player);
}
if(pushState == PushState.Push && instance_exists(player) && player.isPushing && player.pushBlock == id && abs(fVelX) > 0)
{
	with(player)
	{
		var vx = pushMove[pushFrameSequence[scr_floor(frame[Frame.Push])]];
		sfxFlag = (vx >= 3);
		dustFlag = (vx >= 2);
	}
}

var nonPushFlag = (pushState != PushState.Push && abs(fVelX) > 1);
if(grounded && (nonPushFlag || sfxFlag))
{
	if(moveSnd == noone || !audio_is_playing(moveSnd) || sndStopped)
	{
		audio_stop_sound(moveSnd);
		moveSnd = audio_play_sound(snd_PushBlock_Move,0,false);
		audio_sound_loop(moveSnd,true);
		audio_sound_loop_start(moveSnd,0);
		audio_sound_loop_end(moveSnd,0.115);
		sndStopped = false;
	}
}
else if(audio_is_playing(moveSnd))
{
	audio_sound_loop(moveSnd,false);
	sndStopped = true;
}

if(grounded && (nonPushFlag || dustFlag))
{
	var posX = irandom_range(bb_left()-2,x-5),
		posY = irandom_range(bb_bottom()-2,bb_bottom()+1);
	if(sign(velX) == -1)
	{
		posX = irandom_range(x+5,bb_right()+2);
	}
	if(irandom(1) == 0)
	{
		posX = irandom_range(bb_left()-2,bb_right()+2);
	}
	if(liquid)
	{
		var bub = liquid.CreateBubble(posX,posY,0,0);
		bub.canSpread = false;
		bub.kill = true;
	}
	else
	{
		part_particles_create(obj_Particles.partSystemB,posX,posY,obj_Particles.bDust[0],1);
	}
}

if(pushState == PushState.None)
{
	var frict = 0.5;
	if(!grounded)
	{
		frict = 0.125;
	}
	if(liquid)
	{
		frict = 0.75;
		if(!grounded)
		{
			frict = 0.375;
		}
	}
	if(velX > 0)
	{
		velX = max(velX-frict,0);
	}
	if(velX < 0)
	{
		velX = min(velX+frict,0);
	}
}

fGrav = grav[instance_exists(liquid)];

if(!grounded)
{
    velY = min(velY+fGrav, 7);
}

fVelX = velX;
fVelY = velY;

Collision_Normal(fVelX,fVelY,true);

var downAng = GetEdgeAngle(Edge.Bottom);
var downSlopeFlag = (downAng >= 60 && downAng <= 300);
if(!entity_place_collide(0,2) || downSlopeFlag)
{
	grounded = ((bb_bottom()+2) >= room_height);
}

EntityLiquid_Large(x-xprevious, y-yprevious);

var xx = x+mBlockOffsetX,
	yy = y+mBlockOffsetX;
mBlock.isSolid = false;
mBlock.UpdatePosition(xx,yy, true);
mBlock.isSolid = true;

var _xdif = xx-mBlock.x;
if(_xdif != 0)
{
	velX = 0;
	fVelX = 0;
	position.X -= _xdif;
	x = scr_round(position.X);
}
var _ydif = yy-mBlock.y;
if(_ydif != 0)
{
	velY = 0;
	fVelY = 0;
	position.Y -= _ydif;
	y = scr_round(position.Y);
}

if(pushState == PushState.Push)
{
	velX = 0;
}

pushState = PushState.None;