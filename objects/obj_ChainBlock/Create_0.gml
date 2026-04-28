/// @description Initialize
event_inherited();
//snd = snd_BlockBreakHeavy;
respawnSprt = sprt_BombBlockBreak;
extSprt = sprt_BombBlockExt;

destroy = false;
time = 0;

function SetExtraRespawnVars(_respBlock)
{
	_respBlock.timeLeft = timeLeft;
	_respBlock.right = right;
	_respBlock.left = left;
	_respBlock.up = up;
	_respBlock.down = down;
	_respBlock.upright = upright;
	_respBlock.upleft = upleft;
	_respBlock.downright = downright;
	_respBlock.downleft = downleft;
}
