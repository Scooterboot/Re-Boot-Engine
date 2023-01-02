/// @description Initialize
event_inherited();

life = 2000;
lifeMax = 2000;

freezeImmune = true;

dmgMult[DmgType.Beam][0] = 0; // all
dmgMult[DmgType.Charge][0] = 0; // all
dmgMult[DmgType.Explosive][0] = 0; // all

dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 0; // screw attack

//dmgAbsorb = true;

damage = 20;

ignorePlayerImmunity = true;

/*function OnDamageAbsorbed(damage, object, isProjectile)
{
	if(realLife != noone)
	{
		realLife.OnDamageAbsorbed(damage, object, isProjectile);
	}
}*/

function NPCDeath(_x,_y)
{
	instance_destroy();
}