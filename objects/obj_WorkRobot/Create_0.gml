/// @description 
event_inherited();

solidObj = instance_create_layer(x,y,"Collision",obj_WorkRobot_Solid);
solidObj.creator = id;

life = 10;
lifeMax = 10;
damage = 0;//5;

dmgMult[DmgType.Beam][0] = 0; // all
dmgMult[DmgType.Charge][0] = 0; // all
dmgMult[DmgType.Explosive][0] = 0; // all
dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 0; // screw attack

freezeImmune = true;

mSpeed = 0.25;

currentFrame = 0;

frame = 0;
frameCounter = 0;

moveXSeq = array(1,1,1,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1);
movedAtFrame = -1;

topOffsetX = array(
 0,-1,-2,-4,
-7,-2, 0, 2,
 7, 4, 2, 1,
 0,-1,-2,-4,
-7,-2, 0, 2,
 7, 4, 2, 1);

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

water_init(bbox_bottom-y);
CanSplash = 1;
StepSplash = 0;

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

array_resize(solids,2);
solids[0] = "ISolid";
solids[1] = "INPCSolid";

function OnXCollision(fVX)
{
	ChangeDir(-sign(fVX));
	velX = 0;
	fVelX = 0;
}