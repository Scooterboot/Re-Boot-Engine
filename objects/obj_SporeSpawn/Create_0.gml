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

dmgMult[DmgType.Beam][0] = 0; // all
dmgMult[DmgType.Charge][0] = 2; // all

dmgMult[DmgType.Explosive][3] = 0; // bomb
dmgMult[DmgType.Explosive][4] = 0; // power bomb
dmgMult[DmgType.Explosive][5] = 0; // splash 

dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 0; // screw attack
dmgMult[DmgType.Misc][5] = 0; // boost ball

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

function ModifyDamageTaken(damage,object,isProjectile)
{
	if(isProjectile && image_yscale != 0)
	{
		if(ai[0] == 2)
		{
			moveDir *= -1;
		}
		ai[0] = 1;
		ai[1] = 0;
		
		return damage;
	}
	return 0;
}

function PauseAI()
{
	return (global.gamePaused || dmgFlash > 0);
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