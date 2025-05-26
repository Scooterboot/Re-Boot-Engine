
var this = id;
var colFlag = false;
with(obj_Camera)
{
	colFlag = collision_rectangle(x, y, x+global.resWidth-1, y+global.resHeight-1,this,false,true);
}

if(!active && colFlag)
{
	instance_destroy();
}