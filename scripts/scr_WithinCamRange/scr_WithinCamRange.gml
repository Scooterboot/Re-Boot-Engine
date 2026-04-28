function scr_WithinCamRange(xx = -1, yy = -1, extraRng = 48)
{
	var bleft = bbox_left, bright = bbox_right,
		btop = bbox_top, bbottom = bbox_bottom;
	if(xx != -1)
	{
		bleft = bbox_left-x + xx;
		bright = bbox_right-x + xx;
	}
	if(yy != -1)
	{
		btop = bbox_top-y + yy;
		bbottom = bbox_bottom-y + yy;
	}
	
	return scr_RectangleWithinCam(bleft-extraRng,btop-extraRng,bright+extraRng,bbottom+extraRng)
}

function scr_RectangleWithinCam(x1,y1,x2,y2)
{
	var camX = global.cameraX,
		camY = global.cameraY,
		camW = global.resWidth,
		camH = global.resHeight;
	
	return rectangle_in_rectangle(x1,y1,x2,y2,camX-1,camY-1,camX+camW+1,camY+camH+1) > 0;
}