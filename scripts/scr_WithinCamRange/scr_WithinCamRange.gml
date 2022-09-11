function scr_WithinCamRange(xx = -1, yy = -1)
{
	var posX = x,
		posY = y;
	if(xx != -1)
	{
		posX = xx;
	}
	if(yy != -1)
	{
		posY = yy;
	}
	//return (instance_exists(obj_Camera) && point_distance(x,y,obj_Camera.x+global.resWidth/2,obj_Camera.y+global.resHeight/2) <= global.resWidth*1.375)
	var extraRng = 64,
		cam = obj_Camera;
	return (instance_exists(cam) && posX >= cam.x-extraRng && posX <= cam.x+global.resWidth+extraRng && posY >= cam.y-extraRng && posY <= cam.y+global.resHeight+extraRng);
}