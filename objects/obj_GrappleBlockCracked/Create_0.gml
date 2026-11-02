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

function GetGrapOffsetX(_x)
{
	return scr_floor(clamp(_x, bbox_left, bbox_right-1)/16)*16 + 8 - x;
}
function GetGrapOffsetY(_y)
{
	return scr_floor(clamp(_y, bbox_top, bbox_bottom-1)/16)*16 + 8 - y;
}
