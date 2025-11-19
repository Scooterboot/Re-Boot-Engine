/// @description Initialize
event_inherited();

spawnPos = new Vector2(xstart,ystart-112);
patternCenter = new Vector2(xstart,ystart+66);
endPos = new Vector2(xstart,ystart+64);

position = new Vector2(spawnPos.X,spawnPos.Y);
x = scr_round(position.X);
y = scr_round(position.Y);

image_yscale = 0;
coreFrame = 0;
coreFrameCounter = 0;
coreFrameSeq = [1,2,3,2];
height = sprite_get_height(sprite_index);
mouthOpen = false;

npcID = "SporeSpawn";

life = 960;
lifeMax = 960;

freezeImmune = true;

dmgResist[DmgType.Beam][DmgSubType_Beam.All] = 0;
dmgResist[DmgType.Charge][DmgSubType_Beam.All] = 2;

dmgResist[DmgType.Explosive][DmgSubType_Explosive.Bomb] = 0;
dmgResist[DmgType.Explosive][DmgSubType_Explosive.PowerBomb] = 0;
dmgResist[DmgType.ExplSplash][DmgSubType_Explosive.All] = 0;

dmgResist[DmgType.Misc][DmgSubType_Misc.All] = 0;

dropChance[0] = 0; // nothing
dropChance[1] = 20; // energy
dropChance[2] = 20; // large energy
dropChance[3] = 20; // missile
dropChance[4] = 20; // super missile
dropChance[5] = 20; // power bomb

damage = 12;

ignorePlayerImmunity = true;

enviroHandler = instance_create_depth(0,0,0,obj_SporeSpawn_EnviroHandler);

phase = 0;

ai = array_create(4,0);

moveRadiusX = 64;
moveRadiusY = 48;
moveAngle = 90;
moveAngleSpd = 1.4;
moveDir = -1;

function Entity_ModifyDamageTaken(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType)
{
	if(_dmgBox.creator.object_index != obj_Player && image_yscale != 0)
	{
		return self.CalcDamageResist(_dmg, _dmgType, _dmgSubType);
	}
	return 0;
}
function NPC_OnDamageTaken(_selfLifeBox, _dmgBox, _finalDmg, _dmg, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600, _npcDeathType = -1)
{
	if(ai[0] == 2)
	{
		moveDir *= -1;
	}
	ai[0] = 1;
	ai[1] = 0;
}

function PauseAI()
{
	return (global.GamePaused() || dmgFlash > 0);
}

mouthTop = instance_create_layer(x,y,layer,obj_SporeSpawn_Top);
mouthTop.realLife = id;
mouthTop.life = life;
mouthTop.lifeMax = lifeMax;
mouthTop.damage = damage;
mouthBottom = instance_create_layer(x,y,layer,obj_SporeSpawn_Bottom);
mouthBottom.realLife = id;
mouthBottom.life = life;
mouthBottom.lifeMax = lifeMax;
mouthBottom.damage = damage;