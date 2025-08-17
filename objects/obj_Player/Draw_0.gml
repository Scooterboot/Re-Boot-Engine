/// @description Player Graphics and After Images

var liquidMovement = (liquidState > 0);

PaletteSurface();
var palSurf = palSurface;
if(stateFrame == State.CrystalFlash && torsoR == sprt_Player_CrystalFlash)
{
	palSurf = cFlashPalSurf;
}
UpdatePlayerSurface(palSurf);

if(drawAfterImage && !global.gamePaused)
{
	var aftImg = new AfterImage(id,afterImgAlphaMult,afterImageNum);
	ds_list_add(afterImageList, aftImg);
}
for(var i = ds_list_size(afterImageList)-1; i >= 0; i--)
{
	if(afterImageList[| i]._delete)
	{
		ds_list_delete(afterImageList,i);
	}
}
for(var i = 0; i < ds_list_size(afterImageList); i++)
{
	var aftImg = afterImageList[| i];
	aftImg.Update();
		
	if(!aftImg._delete)
	{
		aftImg.Draw();
	}
}

PreDrawPlayer(x,y,0,1);

if(liquid && !liquidMovement && item[Item.GravitySuit])
{
	gravGlowAlpha += 0.01*gravGlowNum*(!global.gamePaused);
	if(gravGlowAlpha <= 0.75)
	{
		gravGlowNum = max(gravGlowNum,1);
	}
	if(gravGlowAlpha >= 1)
	{
		gravGlowNum = -1;
	}
}
else
{
	gravGlowAlpha = max(gravGlowAlpha - 0.05*(!global.gamePaused),0);
	gravGlowNum = 10;
}
var hurtflag = (dmgFlash <= 0 && invFrames > 0 && (invFrames&1) && !global.roomTrans);
if(gravGlowAlpha > 0 && !hurtflag)
{
	var col = c_fuchsia,
		alp = gravGlowAlpha;
	gpu_set_fog(true,col,0,0);
	gpu_set_blendmode(bm_add);
	for(var i = 0; i < 360; i += 45)
	{
		for(var j = 1; j < 3; j++)
		{
			var gx = x+scr_ceil(lengthdir_x(j,i)),
				gy = y+scr_ceil(lengthdir_y(j,i));
			DrawPlayer(gx, gy, rotation, alp * 0.08);
		}
	}
	gpu_set_blendmode(bm_normal);
	gpu_set_fog(false,0,0,0);
}

if((state == State.Spark || state == State.BallSpark) && shineEnd > 0)
{
	var sEnd = abs(shineEnd-shineEndMax),
		sEndMax = shineEndMax-7;
	var dist = abs(scr_wrap(sEnd/sEndMax,-0.5,0.5)) * 20;
	if(dist > 0 && sEnd < sEndMax)
	{
		for(var i = 0; i < 2; i++)
		{
			var edir = shineDir + (sEnd/sEndMax * 360) + 180*i;
			DrawPlayer(x+lengthdir_x(dist,edir),y+lengthdir_y(dist,edir),rotation,0.5);
		}
	}
}

DrawPlayer(x,y,rotation,1);
PostDrawPlayer(x,y,0,1);

if(!global.gamePaused)
{
	chargeReleaseFlash = max(chargeReleaseFlash - 1, 0);
}
dmgFlash = max(dmgFlash - 1, 0);