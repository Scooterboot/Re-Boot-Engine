/// @description Initialize
event_inherited();

life = 200;
lifeMax = 200;
damage = 10;

dmgMult[DmgType.Beam][0] = 0; // all
dmgMult[DmgType.Charge][0] = 0; // all
dmgMult[DmgType.Explosive][1] = 0; // missile
dmgMult[DmgType.Explosive][2] = 1; // super missile
dmgMult[DmgType.Explosive][3] = 0; // bomb
dmgMult[DmgType.Explosive][4] = 1; // power bomb

//dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
//dmgMult[DmgType.Misc][3] = 0; // screw attack
dmgMult[DmgType.Misc][5] = 0; // boost ball

dropChance[0] = 0; // nothing
dropChance[1] = 0; // energy
dropChance[2] = 1; // large energy
dropChance[3] = 0; // missile
dropChance[4] = 254; // super missile
dropChance[5] = 0; // power bomb

mSpeed2 = 1;
mSpeed = mSpeed2;

dirFrame = 5*dir;
frame = 0;
frameCounter = 0;
frameSeq = [0,1,2,1];

jetFlameSprt = sprt_GrappleRipper_Flame;
jetFrame = 0;
jetFrameCounter = 0;
jetFrame2 = 0;
jetFrameSeq = [0,1,2,1];

function PauseAI()
{
	return (global.GamePaused() || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}

/*function ModifyDamageTaken(damage,object,isProjectile)
{
	dmgAbsorb = (object.object_index == obj_GrappleBeamShot);
	return damage;
}
function OnDamageAbsorbed(damage, object, isProjectile)
{
	if(object.object_index == obj_GrappleBeamShot)
	{
		object.grappled = true;
		//object.grapBlockPosX = x + abs(bbox_right-bbox_left)/2;
		//object.grapBlockPosY = y + abs(bbox_bottom-bbox_top)/2;
		object.grapBlock = id;
	}
}*/