function scr_WithinCamRange()
{
	//return (instance_exists(obj_Camera) && point_distance(x,y,obj_Camera.x+global.resWidth/2,obj_Camera.y+global.resHeight/2) <= global.resWidth*1.375)
	var extraRng = 64,
		cam = obj_Camera;
	return (instance_exists(cam) && x >= cam.x-extraRng && x <= cam.x+global.resWidth+extraRng && y >= cam.y-extraRng && y <= cam.y+global.resHeight+extraRng);
}