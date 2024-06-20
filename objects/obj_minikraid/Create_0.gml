/// @description Initialize
event_inherited();

life = 400;
lifeMax = 400;

damage = 100;

deathType = 2;

freezeImmune = true;

dmgMult[DmgType.Explosive][1] = 1;//2; // missile
dmgMult[DmgType.Explosive][2] = 1;//2; // super missile

dropChance[0] = 0; // nothing
dropChance[1] = 10; // energy
dropChance[2] = 30; // large energy
dropChance[3] = 20; // missile
dropChance[4] = 40; // super missile
dropChance[5] = 2; // power bomb

dir = image_xscale;
image_xscale = 1;
image_yscale = 1;

moveDir = dir;
prevMoveDir = 0;
moveCounter = 0;
moveCounter2 = 0;
moveSpeed = 0.5;

spikeFire[0] = irandom(10);
spikeFire[1] = irandom(10)+10;
spikeFire[2] = irandom(10);
spikeFireMax = 120;

spikePosX[0] = 8;
spikePosY[0] = 0;
spikePosX[1] = 14;
spikePosY[1] = 13;
spikePosX[2] = 8;
spikePosY[2] = 24;

spitCounter = 0;
spitFired = false;

moveYOffset = array(0,0,1,2,2,2,1,0,0,0,1,2,2,2,1,0);
walkFrame = 0;
walkFrameCounter = 0;
mouthFrame = 0;
mouthFrameCounter = 0;
mouthFrameNum = -1;
handFrame = 0;
handFrameCounter = 0;

tailFrame = 0;
tailFrameCounter = 0;
tailFrameSequence = array(1,2,3,2);
tailFrame2 = 0;


function PauseAI()
{
	return (global.gamePaused || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}

function NPCDropItem(_x,_y)
{
	for(var i = 0; i < 5; i++)
	{
		_NPCDropItem(_x+irandom_range(-12,12),_y+irandom_range(-12,12));
	}
}