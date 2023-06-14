/// @description Interface inheritence
event_inherited();
lhc_inherit_interface("IMovingSolid");

function CheckPlayer_Top()
{
	return instance_place(x,y-1,obj_Player);
}
function CheckPlayer_Bottom()
{
	return instance_place(x,y+1,obj_Player);
}
function CheckPlayer_Left()
{
	return instance_place(x-1,y,obj_Player);
}
function CheckPlayer_Right()
{
	return instance_place(x+1,y,obj_Player);
}