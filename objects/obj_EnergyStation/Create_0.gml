/// @description Initialize
event_inherited();

stationMessage = "ENERGY REPLENISHED";

Condition = function()
{
	var p = obj_Player;
	return (p.energy < p.energyMax);
}
Interact = function()
{
	var p = obj_Player;
	//p.energy = p.energyMax;
	p.energy = clamp(lerp(p.energy,p.energyMax,0.25),p.energy+1,p.energyMax);
}