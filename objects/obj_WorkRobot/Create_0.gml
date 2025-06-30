/// @description 
event_inherited();

life = 800;
lifeMax = 800;
damage = 0;

dmgMult[DmgType.Beam][0] = 0; // all
dmgMult[DmgType.Charge][0] = 0; // all
dmgMult[DmgType.Explosive][0] = 0; // all
dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 0; // screw attack
dmgMult[DmgType.Misc][5] = 0; // boost ball

freezeImmune = true;

dropChance[0] = 2; // nothing
dropChance[1] = 32; // energy
dropChance[2] = 32; // large energy
dropChance[3] = 32; // missile
dropChance[4] = 2; // super missile
dropChance[5] = 2; // power bomb

mSpeed = 0.2;

currentFrame = 0;

frame = 0;
frameCounter = 0;
eyePalIndex = 0;
eyePalNum = 0;

moveXSeq = [1,1,1,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1];
movedAtFrame = -1;

dir = image_xscale;
image_xscale = 1;
image_yscale = 1;

velX = 0;
velY = 0;
fVelX = 0;
fVelY = 0;

grav[0] = 0.11;
grav[1] = 0.05;
fGrav = grav[0];
maxGrav = 2;

justFell = false;

grounded = false;

sndPlayedAt = 0;

function ChangeDir(newDir)
{
	if(sign(newDir) != 0 && sign(newDir) != dir)
	{
		if(frame >= 3)
		{
			frame = scr_wrap(frame+6*newDir,3,27);
		}
		currentFrame = scr_floor(frame);
		dir = newDir;
	}
}

function OnXCollision(fVX)
{
	ChangeDir(-sign(fVX));
	velX = 0;
	fVelX = 0;
}


topOffsetX = [
 0,-1,-2,-4,
-7,-2, 0, 2,
 7, 4, 2, 1,
 0,-1,-2,-4,
-7,-2, 0, 2,
 7, 4, 2, 1];

for(var i = 0; i < 9; i++)
{
	var type = obj_MovingTile;
	var xscale = 0.5,
		yscale = 0.5;
	if(i >= 3)
	{
		xscale = 1.5;
	}
	if(i == 8)
	{
		yscale = 14/16;
	}
	if(i == 0 || i == 2)
	{
		type = obj_MovingSlope_4th;
		xscale = 1;
		yscale = 1;
		if(i == 0 )//|| i == 7)
		{
			xscale = -1;
		}
	}
	
	var offx = -12,
		offy = -46;
	switch(i)
	{
		case 0:
		{
			offx += 8;
			break;
		}
		case 1:
		{
			offx += 8;
			break;
		}
		case 2:
		{
			offx += 16;
			break;
		}
		case 3:
		{
			offy += 8;
			break;
		}
		case 4:
		{
			offy += 16;
			break;
		}
		case 5:
		{
			offy += 24;
			break;
		}
		case 6:
		{
			offy += 32;
			break;
		}
		
		case 7:
		{
			offy += 40;
			break;
		}
		case 8:
		{
			offy += 48;
			break;
		}
	}
	
	mBlocks[i] = instance_create_layer(x+offx,y+offy,layer_get_id("Collision"),type);
	mBlocks[i].ignoredEntity = id;
	mBlocks[i].image_xscale = xscale;
	mBlocks[i].image_yscale = yscale;
	mBlocks[i].canGrip = false;
	mBlockOffX[i] = offx;
	mBlockOffY[i] = offy;
	
	mBlockOffX_default[i] = offx;
}