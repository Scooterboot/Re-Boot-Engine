/// @description Initialize
event_inherited();

freezeImmune = true;
//ignorePlayerImmunity = true;
bypassPlayerImmune[PlayerImmuneType.Dodge] = false;
bypassPlayerImmune[PlayerImmuneType.Boost] = true;
bypassPlayerImmune[PlayerImmuneType.Speed] = true;
bypassPlayerImmune[PlayerImmuneType.Spark] = false;
bypassPlayerImmune[PlayerImmuneType.Pseudo] = true;
bypassPlayerImmune[PlayerImmuneType.Screw] = true;
bypassPlayerImmune[PlayerImmuneType.Crystal] = false;

function Entity_ModifyDamageTaken(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType)
{
	return 0;
}

function PauseAI()
{
	return (global.GamePaused() || dmgFlash > 0);
}