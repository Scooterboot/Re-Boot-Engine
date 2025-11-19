/// @description Initialize
event_inherited();
image_speed = 0;
scaleTimer = 0;
scaleMult = 0.05;
scale = scaleMult*scaleTimer;
image_xscale = scale;
image_yscale = scale;
pAlpha = 1;
alpha2 = 1;
image_alpha = pAlpha*alpha2;

doorOpenType[DoorOpenType.Bomb] = true;
doorOpenType[DoorOpenType.PBomb] = true;
blockBreakType[BlockBreakType.Bomb] = true;
blockBreakType[BlockBreakType.PBomb] = true;
blockBreakType[BlockBreakType.Chain] = true;

multiHit = true;

//switchLOSCheck = false;

type = ProjType.Bomb;

damageType = DmgType.ExplSplash;
damageSubType[DmgSubType_Explosive.PowerBomb] = true;

dmgBoxes[0] = self.CreateDamageBox(0,0,sprite_index,hostile);
function DamageBoxes()
{
	if(damage > 0)
	{
		if(instance_exists(dmgBoxes[0]))
		{
			dmgBoxes[0].mask_index = sprite_index;
			dmgBoxes[0].image_xscale = image_xscale;
			dmgBoxes[0].image_yscale = image_yscale;
			dmgBoxes[0].Damage(x,y,damage,damageType,damageSubType,freezeType,freezeTime,npcDeathType);
		}
	}
}

distort = instance_create_depth(x,y,depth-1,obj_Distort);