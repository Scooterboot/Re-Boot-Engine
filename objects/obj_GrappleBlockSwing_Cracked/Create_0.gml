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
	return scr_floor(clamp(_x-x, bbox_left-x, bbox_right-x-1)/16)*16 + 8;
}
function GetGrapOffsetY(_y)
{
	return scr_floor(clamp(_y-y, bbox_top-y, bbox_bottom-y-1)/16)*16 + 8;
}
