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
	return (global.gamePaused || dmgFlash > 0);
}