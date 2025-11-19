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
	self.BreakBlock(_x,_y,blockBreakType);
	self.OpenDoor(_x,_y,doorOpenType);
	//self.ShutterSwitch(_x,_y,doorOpenType);
}

//npcDeathType = 3;

image_speed = 0;
image_index = 0;

frame = 0;
frameCounter = 0;
frameSeq = [0,0,1,1,2,3,4];

function Entity_OnDamageDealt(_selfDmgBox, _lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType)
{
	var partSys = obj_Particles.partSystemA,
		partEmit = obj_Particles.partEmitA;
	self.DmgPartEmitRegion(partSys, partEmit, _selfDmgBox, _lifeBox);
	
	var ent = _lifeBox.creator;
	if(freezeType > 0 && !ent.freezeImmune)
	{
		part_emitter_burst(partSys,partEmit,obj_Particles.partFreeze,21*(1+isCharge));
	}
	
	if(object_is_ancestor(ent.object_index,obj_NPC))
	{
		var posX = ent.x+ent.deathOffsetX,
			posY = ent.y+ent.deathOffsetY;
		part_particles_create(obj_Particles.partSystemA,posX,posY,obj_Particles.partFlareFX,1);
	}
}

dist = instance_create_depth(0,0,depth+1,obj_Distort);
dist.left = x-18;
dist.right = x+18;
dist.top = y-18;
dist.bottom = y+18;
dist.alpha = 0.5;
dist.alphaNum = 1;
dist.alphaRate = 0.25;
dist.alphaRateMultDecr = 2;
dist.colorMult = 0.5;
dist.spread = 0.5;
dist.width = 0.5;