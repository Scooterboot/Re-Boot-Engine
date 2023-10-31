/// @description 
var this = id;
var colFlag = false;
with(obj_Camera)
{
	var wDiff = abs(global.resWidth - global.ogResWidth)/2;
	colFlag = collision_rectangle(x+wDiff, y, x+wDiff+global.resWidth-1, y+global.resHeight-1,this,false,true);
}

if(!active && colFlag)
{
	instance_destroy();
}