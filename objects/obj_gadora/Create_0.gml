/// @description Initialize
event_inherited();

npcID = 0;

life = 250;
lifeMax = 250;
damage = 20;

deathType = 2;
deathTimer = 0;

freezeImmune = true;
dmgMult[DmgType.Beam][0] = 0; // all
dmgMult[DmgType.Charge][0] = 0; // all
dmgMult[DmgType.Explosive][0] = 1; // all
dmgMult[DmgType.Explosive][3] = 0; // bomb
dmgMult[DmgType.Explosive][4] = 0; // power bomb
dmgMult[DmgType.Explosive][5] = 0; // splash damage
dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 0; // screw attack
dmgMult[DmgType.Misc][5] = 0; // boost ball

lhc_inherit_interface("ISolid");

eyeState = 0; // 0 = closed, 1 = open, 2 = attack
eyeTimer = 0;
eyeChance = 0;
eyeVuln = false;

frame = 0;
frameCounter = 0;
frameNum = 1;
eyeFrame = 0;
eyeFrameCounter = 0;
eyeFrameNum = -1;

function ModifyDamageTaken(damage,object,isProjectile)
{
	var xx = x+lengthdir_x(8,image_angle)*image_xscale,
		yy = y+lengthdir_y(8,image_angle)*image_xscale;
	if(isProjectile && eyeVuln && collision_circle(xx,yy,12,object,true,true) && place_meeting(x,y,object))
	{
		return damage;
	}
	return 0;
}

function DmgColPlayer()
{
	return collision_rectangle(bbox_left-2,bbox_top-2,bbox_right+2,bbox_bottom+2,obj_Player,false,true);
}