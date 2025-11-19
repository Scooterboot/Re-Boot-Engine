/// @description Initialize
event_inherited();

life = 2000;
lifeMax = 2000;

freezeImmune = true;
dmgAbsorb = true;
damage = 20;
ignorePlayerImmunity = true;

function Entity_CanTakeDamage(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType)
{
	if(instance_exists(realLife))
	{
		return realLife.Entity_CanTakeDamage(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType);
	}
	return false;
}
function Entity_ModifyDamageTaken(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType)
{
	var adposX = lengthdir_x(8,image_angle-90),
		adposY = lengthdir_y(8,image_angle-90);
	if(instance_exists(realLife) && !place_meeting(x-adposX,y-adposY,_dmgBox))
	{
		return realLife.Entity_ModifyDamageTaken(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType);
	}
	return 0;
}
function OnDamageAbsorbed(_selfLifeBox, _dmgBox, _damage, _dmgType, _dmgSubType)
{
	if(instance_exists(realLife))
	{
		realLife.OnDamageAbsorbed(_selfLifeBox, _dmgBox, _damage, _dmgType, _dmgSubType);
	}
}

function NPCDeath(_x,_y)
{
	instance_destroy();
}