/// @description Initialize
event_inherited();

freezeImmune = true;
ignorePlayerImmunity = true;

function ModifyDamageTaken(damage,object,isProjectile)
{
	return 0;
}

function PauseAI()
{
	return (global.GamePaused() || dmgFlash > 0);
}