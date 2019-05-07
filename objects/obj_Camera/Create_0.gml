/// @description Initialize

camLimitMax = 16;//32;
camLimitX = camLimitMax;
camLimitY = 0;
velX = 0;
velY = 0;
fVelX = velX;
fVelY = velY;
camSpeedX = 0;
camSpeedY = 0;
xDir = 0;
yDir = 0;
playerX = x + (global.resWidth/2);
playerY = y + (global.resHeight/2);
targetX = playerX;
targetY = playerY;
if(instance_exists(obj_Player))
{
	playerX = obj_Player.x;
	playerY = obj_Player.y;
	targetX = playerX;
	targetY = playerY;
}
prevPlayerX = playerX;
prevPlayerY = playerY;