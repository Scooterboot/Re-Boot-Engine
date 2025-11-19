/// @description Initialize
event_inherited();

npcID = 0;

life = 250;
lifeMax = 250;
damage = 20;

deathType = 2;
deathTimer = 0;

freezeImmune = true;

dmgResist[DmgType.Beam][DmgSubType_Beam.All] = 0;
dmgResist[DmgType.Charge][DmgSubType_Beam.All] = 0;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.Bomb] = 0;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.PowerBomb] = 0;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.All] = 0;
dmgResist[DmgType.Misc][DmgSubType_Misc.All] = 0;

dropChance[0] = 0; // nothing
dropChance[1] = 2; // energy
dropChance[2] = 30; // large energy
dropChance[3] = 20; // missile
dropChance[4] = 30; // super missile
dropChance[5] = 20; // power bomb

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

dmgBoxMask = mask_Gadora_HitBox;

function Entity_ModifyDamageTaken(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType)
{
	var xx = x+lengthdir_x(8,image_angle)*image_xscale,
		yy = y+lengthdir_y(8,image_angle)*image_xscale;
	if(_dmgBox.creator.object_index != obj_Player && eyeVuln && collision_circle(xx,yy,12,_dmgBox,true,true))
	{
		return self.CalcDamageResist(_dmg,_dmgType,_dmgSubType);
	}
	return 0;
}
function NPC_OnDamageTaken(_selfLifeBox, _dmgBox, _finalDmg, _dmg, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600, _npcDeathType = -1)
{
	eyeState = 0;
	eyeTimer = 0;
	eyeChance++;
}

function NPCDropItem(_x,_y)
{
	for(var i = 0; i < 3; i++)
	{
		self._NPCDropItem(_x+irandom_range(-4,4),_y+irandom_range(-4,4));
	}
}