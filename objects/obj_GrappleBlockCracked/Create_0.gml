/// @description Initialize
event_inherited();
crumble = false;
canBeCulled = true;
time = 0;
//timeLeft = 300;
//respawnTime = 20;

respawnSprt = sprt_GrappleBlockBreak;
extSprt = sprt_GrappleBlockCrackedExt;

function SetExtraRespawnVars(_respBlock)
{
	_respBlock.timeLeft = timeLeft;
}
