/// @description Initialize
event_inherited();

stationMessage = "ENERGY & AMMO REPLENISHED";

Condition = function()
{
	var p = obj_Player;
	return (p.energy < p.energyMax || 
			p.missileStat < p.missileMax || 
			p.superMissileStat < p.superMissileMax || 
			p.powerBombStat < p.powerBombMax);
}
Interact = function()
{
	var p = obj_Player;
	p.energy = clamp(lerp(p.energy,p.energyMax,0.25),p.energy+1,p.energyMax);
	p.missileStat = clamp(lerp(p.missileStat,p.missileMax,0.25),p.missileStat+1,p.missileMax);
	p.superMissileStat = clamp(lerp(p.superMissileStat,p.superMissileMax,0.25),p.superMissileStat+1,p.superMissileMax);
	p.powerBombStat = clamp(lerp(p.powerBombStat,p.powerBombMax,0.25),p.powerBombStat+1,p.powerBombMax);
}