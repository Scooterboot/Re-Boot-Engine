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

saving = -20;
maxSave = 170;
gameSavedText = "GAME SAVED"+"\n\n"+"ENERGY & AMMO REPLENISHED";

idleAnim = 0;

hatchOpen = false;
hatchFrame = 0;
hatchFrameCounter = 0;
hatchY = 9;

lightGlow = 0;
lightGlowNum = 1;

visorLightGlow = 0;
visorLightGlowNum = 1;


block = instance_create_layer(x,y,layer,obj_Gunship_Mask);