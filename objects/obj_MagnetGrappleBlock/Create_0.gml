event_inherited();

extSprt = sprt_MagnetGrappleBlockExt;

function GetGrapOffsetX(_x)
{
	return scr_floor(clamp(_x, bbox_left, bbox_right-1)/16)*16 + 8 - x;
}
function GetGrapOffsetY(_y)
{
	return scr_floor(clamp(_y, bbox_top, bbox_bottom-1)/16)*16 + 8 - y;
}
