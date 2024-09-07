/// @description Initialize
event_inherited();

damageType = DmgType.Charge;
freezeType = 0;

dmgDelay = 0;

isCharge = true;
isWave = true;
isPlasma = true;

particleType = -1;

multiHit = true;
tileCollide = false;
function TileInteract(_x,_y)
{
	BreakBlock(_x,_y,blockDestroyType);
	OpenDoor(_x,_y,doorOpenType);
	//ShutterSwitch(_x,_y,doorOpenType);
}

//npcDeathType = 3;

image_speed = 0;
image_index = 0;

frame = 0;
frameCounter = 0;
frameSeq = array(0,0,1,1,2,3,4);

function OnDamageNPC(damage,npc)
{
	var posX = npc.x+npc.deathOffsetX,
		posY = npc.y+npc.deathOffsetY;
	part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.partFlareFX,1);
}

dist = instance_create_depth(0,0,0,obj_Distort);
dist.left = x-20;
dist.right = x+20;
dist.top = y-20;
dist.bottom = y+20;
dist.alpha = 0.5;
dist.alphaNum = 1;
dist.alphaRate = 0.25;
dist.alphaMult = 0.5;
dist.spread = 0.625;