/// @description place_collide(offsetX, offsetY)
/// @param offsetX
/// @param  offsetY
function place_collide(argument0, argument1)
{
	var ox = argument0, oy = argument1;
	return place_meeting(x+ox,y+oy,obj_Tile);
}