
var hpad = 64,
	vpad = 64;
global.cullRegionLeft = global.cameraX - hpad;
global.cullRegionTop = global.cameraY - vpad;
global.cullRegionRight = global.cameraX+global.cameraWidth + hpad;
global.cullRegionBottom = global.cameraY+global.cameraHeight + vpad;

if(oldCamX != global.cameraX || oldCamY != global.cameraY)
{
	self.EnableObjs();
	
	oldCamX = global.cameraX;
	oldCamY = global.cameraY;
}

self.EnableSpecialObjs();
