/// @description Initialize
event_inherited();

life = 2000;
lifeMax = 2000;

freezeImmune = true;

dmgMult[DmgType.Beam][0] = 0; // all

dmgMult[DmgType.Explosive][3] = 0; // bomb
dmgMult[DmgType.Explosive][4] = 0; // power bomb
dmgMult[DmgType.Explosive][5] = 0; // splash 

dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 0; // screw attack

dmgAbsorb = true;

damage = 20;

ignorePlayerImmunity = true;

/*function DmgCollide(posX,posY,object,isProjectile)
{
	var npc = id;
	
	var adposX = lengthdir_x(8,image_angle-90),
		adposY = lengthdir_y(8,image_angle-90);
	
	with(object)
	{
		return place_meeting(posX,posY,npc) || place_meeting(posX-adposX,posY-adposY,npc);
	}
	return false;
}*/
function ModifyDamageTaken(damage,object,isProjectile)
{
	if(instance_exists(realLife))
	{
		var adposX = lengthdir_x(8,image_angle-90),
			adposY = lengthdir_y(8,image_angle-90);
		if(isProjectile && !place_meeting(x-adposX,y-adposY,object))
		{
			return realLife.ModifyDamageTaken(damage,object,isProjectile);
		}
	}
	return 0;
}

function OnDamageAbsorbed(damage, object, isProjectile)
{
	if(instance_exists(realLife))
	{
		realLife.OnDamageAbsorbed(damage, object, isProjectile);
	}
}

function NPCDeath(_x,_y)
{
	instance_destroy();
}