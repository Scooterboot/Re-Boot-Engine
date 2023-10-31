/// @description 

enum ShipState
{
	Idle,
	
	SaveDescend,
	SaveAnim,
	SaveAscend,
	
	Land,
	TakeOff
}

state = ShipState.Idle;

movePlayer = false;
moveY = 0;
moveYMax = 56;

saving = 0;
maxSave = 170;
gameSavedText = "GAME SAVED"+"\n\n"+"ENERGY & AMMO REPLENISHED";

idleAnim = 0;
lightGlow = 0;
lightGlowNum = 1;

hatchOpen = false;
hatchFrame = 0;
hatchFrameCounter = 0;
hatchY = 9;


block[0] = instance_create_layer(x-94,y+44,layer,obj_MovingTile);
block[0].image_yscale = 0.5;
block[1] = instance_create_layer(x+78,y+44,layer,obj_MovingTile);
block[1].image_yscale = 0.5;
block[2] = instance_create_layer(x,y,layer,obj_Gunship_Mask);