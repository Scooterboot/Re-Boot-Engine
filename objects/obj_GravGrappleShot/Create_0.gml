event_inherited();

InitControlVars("player");

damageType = DmgType.Misc;
damageSubType = array_create(DmgSubType_Misc._Length,false);
damageSubType[DmgSubType_Misc.All] = true;
damageSubType[DmgSubType_Misc.Grapple] = true;

particleType = -1;

direction = 0;
speed = 0;
image_speed = 0.5;
layer = layer_get_id("Projectiles_fg");

shootDir = 0;

velocity = 16;

maxSpeed = 250;
speedDecay = 0.96;
maxDist = 200;

grapFrame = 0;

enum GravGrapState
{
	None,
	Ground,
	Object
}
state = GravGrapState.None;

//gunOffsetX = -20;
//gunOffsetY = -20;
/*
enum AntiGravMode
{
	None,
	Ground,
	Entity
}
mode = AntiGravMode.None;

dist = maxDist;

aimX = 0;			//cx
aimY = 0;			//cy
targetX = 0;		//px
targetY = 0;		//py
playerX = 0;		//ox
playerY = 0;		//oy

distAimX = 0;		//dcx
distAimY = 0;		//dcy
animX = 0;			//ncx
animY = 0;			//ncy
distTargetX = 0;	//dpx
distTargetY = 0;	//dpy

aimDist = 0;		//cdist
targetDist = 0;		//pdist
ang = 0;

normX = 0;			//nx
normY = 0;			//ny

gunX = 0;			//tox
gunY = 0;			//toy

function UpdatePoints()
{
	var player = creator;
	
	aimX = player.x+lengthdir_x(100, player.shootDir);
	aimY = player.y+lengthdir_y(100, player.shootDir);
	targetX = x;
	targetY = y;
	playerX = player.x;
	playerY = player.y;
	
	distAimX = aimX - playerX;
	distAimY = aimY - playerY;
	distTargetX = targetX - playerX;
	distTargetY = targetY - playerY;
	
	aimDist = sqrt(distAimX*distAimX + distAimY*distAimY);
	targetDist = sqrt(distTargetX*distTargetX + distTargetY*distTargetY);
	
	ang = arctan2(aimY - playerY, aimX - playerX) + pi;
	
	normX = cos(ang)*dist + targetX;
	normY = sin(ang)*dist + targetY;
	
	//gunX = cos(ang)*gunOffsetX;
	//gunY = sin(ang)*gunOffsetY;
	
	animX = (distAimX/aimDist)*targetDist;
	animY = (distAimY/aimDist)*targetDist;
}

aRot = 0;

function GetScale(_x)
{
	return -((_x-1.0)*(_x-1.0)) + 1.25;
}
function DrawBit(_x, _y, ang, scale, fade)
{
	var ts = scale - 0.25;
	ts = 1.0 - ts;
	ts /= 2.0;
	ts += 0.5;
	
	//var _col = make_color_rgb(floor(scale*100), floor(fade*150*ts), 255);
	var _col = c_white;
	
	//scale = min(scale*0.5, 0.375);
	scale = clamp(scale, 0.625, 1);
	draw_sprite_ext(sprite_index,0, _x,_y, scale,scale, radtodeg(ang), _col, 1);
}*/