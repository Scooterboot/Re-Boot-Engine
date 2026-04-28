
var hpad = 64,
	vpad = 64;
global.cullRegionLeft = global.cameraX - hpad;
global.cullRegionTop = global.cameraY - vpad;
global.cullRegionRight = global.cameraX+global.resWidth + hpad;
global.cullRegionBottom = global.cameraY+global.resHeight + vpad;

if(oldCamX != global.cameraX || oldCamY != global.cameraY)
{
	self.EnableObjs();
	
	oldCamX = global.cameraX;
	oldCamY = global.cameraY;
}

self.EnableSpecialObjs();
