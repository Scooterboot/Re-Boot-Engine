/// @description Initialize
event_inherited();

freezeImmune = true;
ignorePlayerImmunity = true;

function Entity_ModifyDamageTaken(_selfLifeBox, _dmgBox, _dmg, _dmgType, _dmgSubType)
{
	return 0;
}

function PauseAI()
{
	return (global.GamePaused() || dmgFlash > 0);
}