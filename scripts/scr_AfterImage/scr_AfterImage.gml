///scr_AfterImage(draw, rotation, delay, num, alpha)

var draw = argument0,
r = argument1,
d = argument2,
n = argument3,
a = argument4;

if(draw)
{
	if(!global.gamePaused)
	{
		afterImgCounter += 1;
	}
	if(afterImgCounter > d)
	{
		var echo = instance_create_layer(scr_round(x),scr_round(y),"Player",obj_PlayerEcho);
		echo.surfW = surfW;
		echo.surfH = surfH;
		echo.mask_index = mask_index;
		echo.fadeRate = (1 / max(n,1));
		echo.state = state;
		echo.stateFrame = stateFrame;
		echo.morphFrame = morphFrame;
		echo.morphAlpha = morphAlpha;
		echo.unmorphing = unmorphing;
		echo.dir = dir;
		echo.fDir = fDir;
		echo.torsoR = torsoR;
		echo.torsoL = torsoL;
		echo.legs = legs;
		echo.bodyFrame = bodyFrame;
		echo.legFrame = legFrame;
		echo.ballFrame = ballFrame;
		echo.sprtOffsetX = sprtOffsetX;
		echo.sprtOffsetY = sprtOffsetY;
		echo.runYOffset = runYOffset;
		echo.itemSelected = itemSelected;
		echo.itemHighlighted = itemHighlighted;
		echo.missileArmFrame = missileArmFrame;
		echo.drawMissileArm = drawMissileArm;
		echo.finalArmFrame = finalArmFrame;
		echo.armDir = armDir;
		echo.armOffsetX = armOffsetX;
		echo.armOffsetY = armOffsetY;
		echo.rotation = r;
		echo.alpha2 = a;
		echo.palShader = palShader;
		echo.palIndex = palIndex;
		echo.palIndex2 = palIndex2;
		echo.palDif = palDif;
		echo.item = item;
		echo.misc = misc;
		echo.climbIndex = climbIndex;
		echo.gripFrame = gripFrame;
		echo.gripAimFrame = gripAimFrame;
		echo.liquidState = liquidState;
		echo.dmgFlash = dmgFlash;
		echo.immuneTime = immuneTime;
		echo.velX = x-xprevious;
		echo.velY = y-yprevious;
		if((state == "stand" || state == "crouch") && prevState != state)
		{
			echo.velY = 0;
		}
		afterImgCounter = 0;
	}
}
else
{
	afterImgCounter = 0;
}