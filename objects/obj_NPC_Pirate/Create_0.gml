/// @description Initialize
event_inherited();

moveSpeed = 1;//1.5;

palIndex = pal_SpacePirate_Grey;

hurtSound = snd_SpacePirate_Voice;

enum PirateState
{
	Stand,
	Shoot,
	Run,
	Turn
}
state = PirateState.Run; // stand, shoot, run, turn
prevState = state;
runCounter = 0;

sprtStand = sprt_PirateStand;
sprtShoot = sprt_PirateShoot;
sprtRun = sprt_PirateRun;
sprtTurn = sprt_PirateTurn;

currentSprt = sprtRun;
currentFrame = 0;

frame[3] = 0;
frameCounter[3] = 0;

standFrameSequence = array(2,1,0,1,2,3,4,3,2);
//shootFrameSequence = array(0,1,2,3,4,3,2,1,0);
shootFrameSequence = array(0,1,2,3,4,5,4,3,2,1,0);

shotsFired = false;

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

function DmgCollide(posX,posY,object,isProjectile)
{
	if(!instance_exists(object)) { return false; }
	
	var offX = object.x-posX,
		offY = object.y-posY;
	return collision_rectangle(bb_left()-4 + offX,bb_top()-2 + offY,bb_right()+4 + offX,bb_bottom()+1 + offY,object,true,true);
}