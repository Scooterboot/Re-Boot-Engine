/// @description Initialize
image_speed = 0;
image_index = 0;


// ----- Main -----
#region Main

enum State
{
	Stand,
	Elevator,
	Crouch,
	Walk,
	Run,
	Brake,
	Morph,
	Jump,
	Somersault,
	Grip,
	Spark,
	BallSpark,
	Grapple,
	Hurt,
	DmgBoost,
	Death
};
state = State.Stand; //stand, crouch, morph, jump, somersault, grip, spark, ballSpark, grapple, hurt
prevState = state;
lastState = prevState;

grounded = true;
notGrounded = !grounded;

wallJumpDelay = 6;
canWallJump = false;

uncrouch = 0;

ballBounce = 0;
mockBall = false;

aimAngle = 0; //2 = verticle up, 1 = diagonal up, 0 = forward, -1 = diagonal down, -2 = vertical down
prevAimAngle = aimAngle;
lastAimAngle = prevAimAngle;
aimUpDelay = 0;

gbaAimAngle = 0;
gbaAimPreAngle = 0;

move = 0;
move2 = 0;
pMove = 0;

dir = 0; //0 = face screen, 1 = face right, -1 = face left
fDir = dir;
oldDir = dir;
lastDir = oldDir;

speedCounter = 0;
speedCounterMax = 80;//120;
speedBoost = false;
speedFXCounter = 0;
speedCatchCounter = 0;

shineCharge = 0;
shineDir = 0;
shineStart = 0;
shineEnd = 0;
shineSparkSpeed = 13;
shineFXCounter = 0;
shineRampFix = 0;

shineDownRot = 0;
shineRestart = false;
shineRestarted = false;

spiderBall = false;
spiderSpeed = 0;
enum Edge
{
	None,
	Bottom,
	Top,
	Left,
	Right
};
spiderEdge = Edge.None; //none, bottom, top, left, right
spiderGlowAlpha = 0;
spiderGlowNum = 1;
spiderMove = 1;
spiderStick = false;

isChargeSomersaulting = false;
isSpeedBoosting = false;
isScrewAttacking = false;

stepSndPlayedAt = 0;

walkState = false;

uncrouching = false;

ledgeFall = false;
ledgeFall2 = false;
justFell = false;
fellVel = 0;

onPlatform = false;

upClimbCounter = 0;

startClimb = false;
climbTarget = 0;
climbIndex = 0;
climbIndexCounter = 0;
climbX = array(0,0,0,0,0,1,2,2,2,2,2,1,1,0,0,0,0,0,0);
climbY = array(0,6,6,5,5,4,4,2,0,0,0,0,0,0,0,0,0,0,0);

quickClimbTarget = 0;
quickClimbHeight = 0;

immuneTime = 0;
//96 default, 60 spikes
hurtTime = 0; //45
hurtSpeedX = 0;
hurtSpeedY = 0;
dmgFlash = 0;

dmgBoost = 0;
dmgBoostJump = false;

liquidState = 0;
outOfLiquid = (liquidState == 0);

liquidLevel = 0;
gunLiquidLevel = 0;

statCharge = 0;
maxCharge = 60;

bombCharge = 0;
bombChargeMax = 30;

hSpeed = 0;
vSpeed = 0;
shootDir = 0;
shootSpeed = 8;
extraSpeed_x = 0;
extraSpeed_y = 0;

shotDelayTime = 0;
bombDelayTime = 0;

waveDir = 1;


cRight = false;
cLeft = false;
cUp = false;
cDown = false;
cJump = false;
cShoot = false;
cDash = false;
cAngleUp = false;
cAngleDown = false;
cAimLock = false;
cMorph = false;

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rJump = !cJump;
rShoot = !cShoot;
rDash = !cDash;
rAngleUp = !cAngleUp;
rAngleDown = !cAngleDown;
rAimLock = !cAimLock;
rMorph = !cMorph;

rMorphJump = false;

surfW = 80;
surfH = 80;
playerSurf = surface_create(surfW,surfH);

water_init(0);
CanSplash = 1;
BreathTimer = 180;
StepSplash = 0;

XRay = noone;
XRayDying = 0;

constantDamageDelay = 0;

grapple = noone;
grappleActive = false;
grappleDist = 0;
grappleOldDist = 0;
grappleMaxDist = 143;

grapBoost = false;

grappleVelX = 0;
grappleVelY = 0;

grapWJCounter = 0;

#endregion
// ----- Physics Vars -----
#region Physics Vars

// Out of water
maxSpeed[0,0] = 2.75;	// Running
maxSpeed[1,0] = 4.75;	// Dashing (no speed boost)
maxSpeed[2,0] = 9.75;	// Speed Boosting
maxSpeed[3,0] = 1.25;	// Jump
maxSpeed[4,0] = 1.375;	// Somersault
maxSpeed[5,0] = 3.25;	// Morph Ball
maxSpeed[6,0] = 5.25;	// Mock Ball
maxSpeed[7,0] = 1;		// Air Morph
maxSpeed[8,0] = 1.25;	// Air Spring Ball
// Underwater
maxSpeed[0,1] = 2.75;	// Running
maxSpeed[1,1] = 4.75;	// Dashing (no speed boost)
maxSpeed[2,1] = 9.75;	// Speed Boosting
maxSpeed[3,1] = 1.25;	// Jump
maxSpeed[4,1] = 1.375;	// Somersault
maxSpeed[5,1] = 2.75;	// Morph Ball
maxSpeed[6,1] = 4.75;	// Mock Ball
maxSpeed[7,1] = 1;		// Air Morph
maxSpeed[8,1] = 1.25;	// Air Spring Ball
// In lava/acid
maxSpeed[0,2] = 1.75;	// Running
maxSpeed[1,2] = 3.75;	// Dashing (no speed boost)
maxSpeed[2,2] = 8.75;	// Speed Boosting
maxSpeed[3,2] = 1.25;	// Jump
maxSpeed[4,2] = 1.375;	// Somersault
maxSpeed[5,2] = 2.75;	// Morph Ball
maxSpeed[6,2] = 4.75;	// Mock Ball
maxSpeed[7,2] = 1;		// Air Morph
maxSpeed[8,2] = 1.25;	// Air Spring Ball

// Out of water
moveSpeed[0,0] = 0.1875;	// Normal
moveSpeed[1,0] = 0.1;		// Morph
// Underwater
moveSpeed[0,1] = 0.015625;	// Normal
moveSpeed[1,1] = 0.02;		// Morph
// In lava/acid
moveSpeed[0,2] = 0.015625;	// Normal
moveSpeed[1,2] = 0.02;		// Morph

frict[0] = 0.5;		// Out of water
frict[1] = 0.5;		// Underwater
frict[2] = 0.25;	// In lava/acid


// Out of water
jumpSpeed[0,0] = 4.875;	// Normal Jump
jumpSpeed[1,0] = 6;		// Hi Jump
jumpSpeed[2,0] = 4.625;	// Wall Jump
jumpSpeed[3,0] = 5.5;	// Hi Wall Jump
// Underwater
jumpSpeed[0,1] = 1.75;			// Normal Jump
jumpSpeed[1,1] = 2.5;			// Hi Jump
jumpSpeed[2,1] = 1.25;//0.25;	// Wall Jump
jumpSpeed[3,1] = 2.25;//0.5;	// Hi Wall Jump
// In lava/acid
jumpSpeed[0,2] = 2.75;	// Normal Jump
jumpSpeed[1,2] = 3.5;	// Hi Jump
jumpSpeed[2,2] = 2.625;	// Wall Jump
jumpSpeed[3,2] = 3.5;	// Hi Wall Jump

// Out of water
jumpHeight[0,0] = 2; // Normal
jumpHeight[1,0] = 2; // Hi Jump
// Underwater
jumpHeight[0,1] = 2; // Normal
jumpHeight[1,1] = 2; // Hi Jump
// In lava/acid
jumpHeight[0,2] = 2; // Normal
jumpHeight[1,2] = 2; // Hi Jump

grav[0] = 0.109375;		// Out of water
grav[1] = 0.03125;		// Underwater
grav[2] = 0.03515625;	// In lava/acid

fallSpeedMax = 5; // Maximum fall speed

fMaxSpeed = maxSpeed[0,0];
fMoveSpeed = moveSpeed[0,0];
fFrict = frict[0];
fGrav = grav[0];
fJumpSpeed = jumpSpeed[0,0];
fJumpHeight = jumpHeight[0,0];

jump = 0;
jumping = false;
jumpStart = false;
jumpStop = !jumpStart;

morphSpinJump = false;

bombJump = 0;
bombJumpMax[0] = 13;
bombJumpMax[1] = 3;
bombJumpMax[2] = 3;
bombJumpSpeed[0] = 2;
bombJumpSpeed[1] = 0.01;
bombJumpSpeed[2] = 0.01;
bombJumpX = 0;


sAngle = 0;

velX = 0;
velY = 0;

fVelX = 0;
fVelY = 0;

cosX = lengthdir_x(abs(velX),sAngle);
sinX = lengthdir_y(abs(velX),sAngle);

#endregion
// ----- Animation -----
#region Animation

stateFrame = State.Stand;
//stand, crouch, walk, run, brake, morph, jump, somersault, grip, spark, grapple, hurt

dirFrame = 0;

//Run Torso Y Offset
rOffset =  array(1,0,0,1,2,2,3,2,1,1,0,0,0,1,2,2,3,2,1,1,0,0);
rOffset2 = array(0,0,0,0,1,1,2,2,1,1,0,0,0,0,1,1,2,2,1,1,0,0);

//Moon Walk Torso Y Offset
mOffset = array(0,0,0,0,1,1,1,0,0,0,1,1,1);

runYOffset = 0;
runAimSequence = array(0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1);

brake = false;
brakeFrame = 0;

frame[12] = 0;
frameCounter[12] = 0;

idleNum = array(32,8,8,8,16,6,6,6);
idleSequence = array(0,1,2,3,4,3,2,1);

wjFrame = 0;
wjSequence = array(3,3,3,2,2,1,1,1,0);
wjAnimDelay = 0;

crouchFrame = 0;

morphFrame = 0;
unmorphing = false;
morphAlpha = 0;
ballFrame = 0;
morphNum = 0;
ballAnimDir = dir;

ballGlowIndex = 1;

aimFrame = 0;

aimSnap = 0;

aimAnimTweak = 0;

transFrame = 0;
runToStandFrame[1] = 0;

walkToStandFrame = 0;

landFrame = 0;
smallLand = false;

jumpStartFrame = 0;

landSequence = array(0,4,4,4,3,3,2,2,1,0);
smallLandSequence = array(0,4,4,4,1,1,0);

crouchSequence = array(0,1,1,2,3,3);

landFinal = 0;
crouchFinal = 0;
morphFinal = 0;

crouchYOffset = array(0,3,7,10);

landYOffset = array(2,5,8,4,1);

gripFrame = 0;
gripGunReady = false;
gripAimFrame = 0;
gripGunCounter = 0;

//gripAimTarget = array(4,6,2,8,0);

climbSequence = array(0,0,1,2,3,4,5,6,7,8,9,9,9,9,10,10,11,11,11);
climbFrame = 0;

grapFrame = 3;
grapWallBounceFrame = 0;

grapAngle = 0;
grapDisVel = 0;

grapPartFrame = 0;
grapPartCounter = 0;

hurtFrame = 0;

torsoR = sprt_StandCenter;
torsoL = torsoR;
legs = -1;

sprtOffsetX = 0;
sprtOffsetY = 0;

bodyFrame = 0;
legFrame = 0;

spaceJump = 0;

recoilCounter = 0;

drawMissileArm = false;
missileArmFrame = 0;
armDir = 1;
finalArmFrame = 0;

shotOffsetX = 0;
shotOffsetY = 0;
armOffsetX = 0;
armOffsetY = 0;

shootPosX = 0;
shootPosY = 0;

gunReady = false;
//gunReady2 = false;
shootFrame = false;
justShot = 0;

chargeSetFrame = 0;
chargeFrame = 0;
chargeFrameCounter = 0;

particleFrame = 0;
particleFrameMax = 4;

chargeEmit = noone;


//downV
turnArmPosX[0,0] = -9;
turnArmPosX[0,1] = -8;
turnArmPosX[0,2] = -7;
turnArmPosX[0,3] = -6;
turnArmPosX[0,4] = -4;
turnArmPosX[0,5] = -1;
turnArmPosX[0,6] = 2;
turnArmPosY[0] = 19;


//down
turnArmPosX[1,0] = -16;
turnArmPosX[1,1] = -13;
turnArmPosX[1,2] = -10;
turnArmPosX[1,3] = -7;
turnArmPosX[1,4] = -4;
turnArmPosX[1,5] = 2;
turnArmPosX[1,6] = 10;
turnArmPosY[1] = 9;


//default
turnArmPosX[2,0] = -14;
turnArmPosX[2,1] = -12;
turnArmPosX[2,2] = -9;
turnArmPosX[2,3] = -4;
turnArmPosX[2,4] = 1;
turnArmPosX[2,5] = 7;
turnArmPosX[2,6] = 12;

turnArmPosY[2,0] = 0;
turnArmPosY[2,1] = -1;
turnArmPosY[2,2] = -3;
turnArmPosY[2,3] = -4;
turnArmPosY[2,4] = -3;
turnArmPosY[2,5] = -1;
turnArmPosY[2,6] = 0;


//up
turnArmPosX[3,0] = -16;
turnArmPosX[3,1] = -13;
turnArmPosX[3,2] = -10;
turnArmPosX[3,3] = -6;
turnArmPosX[3,4] = -1;
turnArmPosX[3,5] = 6;
turnArmPosX[3,6] = 12;
turnArmPosY[3] = -20;


//upV
turnArmPosX[4,0] = -4;
turnArmPosX[4,1] = -5;
turnArmPosX[4,2] = -6;
turnArmPosX[4,3] = -6;
turnArmPosX[4,4] = -4;
turnArmPosX[4,5] = -1;
turnArmPosX[4,6] = 1;
turnArmPosY[4] = -29;

rotation = 0;

hudBOffsetX = 0;
hudIOffsetX = 0;


// underwater gravity suit glow
gravGlowAlpha = 0;
gravGlowNum = 10;

dBoostFrame = 0;
dBoostFrameCounter = 0;

#endregion
// ----- Audio -----
#region Audio

chargeSoundPlayed = false;

somerSoundPlayed = false;
somerUWSndCounter = 0;

speedSoundPlayed = false;

screwFrame = 0;
screwFrameCounter = 0;
screwPal = 0;
screwPalNum = 1;

screwSoundPlayed = false;

#endregion
// ----- Item Vars -----
#region Item Vars

/*energyTanks = 14;
missileTanks = 51;
superMissileTanks = 15;
powerBombTanks = 10;*/

energyMax = 799;//1499;//99 + (100 * energyTanks);
energy = energyMax;

missileMax = 250;//5 * missileTanks;
missileStat = missileMax;

superMissileMax = 50;//2 * superMissileTanks;
superMissileStat = superMissileMax;

powerBombMax = 50;//2 * powerBombTanks;
powerBombStat = powerBombMax;

enum Suit
{
	Varia,
	Gravity
};
// 2 Suits
suit[1] = false;

enum Boots
{
	HiJump,
	SpaceJump,
	SpeedBoost,
	ChainSpark
};
// 4 Boots
boots[3] = false;

enum Misc
{
	PowerGrip,
	Morph,
	Bomb,
	Spring,
	Spider,
	ScrewAttack
};
// 6 Misc
misc[5] = false;

enum Beam
{
	Charge,
	Ice,
	Wave,
	Spazer,
	Plasma
};
// 5 Beams
beam[4] = false;

enum Item
{
	Missile,
	SMissile,
	PBomb,
	Grapple,
	XRay
};
// 5 Items
item[4] = false;

hasSuit[array_length_1d(suit)-1] = false;
hasMisc[array_length_1d(misc)-1] = false;
hasBoots[array_length_1d(boots)-1] = false;
hasBeam[array_length_1d(beam)-1] = false;
hasItem[array_length_1d(item)-1] = false;

//starting items
misc[Misc.PowerGrip] = true;
hasMisc[Misc.PowerGrip] = true;
misc[Misc.Morph] = true;
hasMisc[Misc.Morph] = true;
misc[Misc.Bomb] = true;
hasMisc[Misc.Bomb] = true;
beam[Beam.Charge] = true;
hasBeam[Beam.Charge] = true;
//boots[Boots.SpeedBoost] = true;

/*for(var i = 0; i < array_length_1d(suit); i++)
{
	suit[i] = true;
	hasSuit[i] = suit[i];
}
for(var i = 0; i < array_length_1d(misc); i++)
{
	misc[i] = true;
	hasMisc[i] = misc[i];
}
for(var i = 0; i < array_length_1d(boots); i++)
{
	boots[i] = true;
	hasBoots[i] = boots[i];
}
for(var i = 0; i < array_length_1d(beam); i++)
{
	beam[i] = true;
	hasBeam[i] = beam[i];
}
for(var i = 0; i < array_length_1d(item); i++)
{
	item[i] = true;
	hasItem[i] = item[i];
}*/


//beam variables

chargeMult = 5;
beamDmg = 20;
beamShot = obj_PowerBeamShot;
beamCharge = obj_PowerBeamChargeShot;
beamDelay = 6;
beamChargeDelay = 18;
beamChargeAnim = sprt_PowerBeamChargeAnim;
beamSound = snd_PowerBeam_Shot;
beamChargeSound = snd_PowerBeam_ChargeShot;
beamAmt = 1;
beamChargeAmt = 1;
beamIconIndex = 0;

#endregion
// ----- HUD ------
#region HUD

cHSelect = false;
cHCancel = false;
cHRight = false;
cHLeft = false;
cHUp = false;
cHDown = false;
cHToggle = false;

rHSelect = !cHSelect;
rHCancel = !cHCancel;
rHRight = !cHRight;
rHLeft = !cHLeft;
rHUp = !cHUp;
rHDown = !cHDown;
rHToggle = !cHToggle;

moveH = 0;
moveHPrev = 1;

itemSelected = 0;
itemHighlighted[1] = 0;

pauseSelect = false;

currentMap = global.rmMapSprt;
playerMapX = (scr_floor(x/global.resWidth) + global.rmMapX) * 8;
playerMapY = (scr_floor(y/global.resWidth) + global.rmMapY) * 8;
mapSurf = surface_create(8,8);

hudMapFlashAlpha = 0;
hudMapFlashNum = 1;

beamName[0] = "POWER BEAM";
beamName[1] = "ICE BEAM";
beamName[2] = "WAVE BEAM";
beamName[3] = "SPAZER";
beamName[4] = "PLASMA BEAM";

itemName[0] = "MISSILE";
itemName[1] = "SUPER MISSILE";
itemName[2] = "POWER BOMB";
itemName[3] = "GRAPPLE BEAM";
itemName[4] = "X-RAY VISOR";

#endregion
// ----- Palette -----
#region Palette

chargeReleaseFlash = 0;

shaderFlash = 0;
shaderFlashMax = 4;

palShader = pal_PowerSuit;
palIndex = 1;
palIndex2 = 1;
palDif = 0;
beamPalIndex = 0;

xRayVisorFlash = 0;
xRayVisorNum = 0;

morphPal = 0;

heatPal = 0;
heatPalNum = 1;
heatDmgPal = 0;
heatDmgPalCounter = 0;

#endregion
// ----- After Image -----
#region After Image

afterImageNum = 10;
drawAfterImage = false;
afterImgDelay = 0;
afterImgCounter = 0;
afterImgAlphaMult = 0.625;

#endregion

// ----- Functions -----
#region PlayerGrounded
function PlayerGrounded()
{
	return ((((collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_Tile,true,true) || 
			(collision_line(bbox_left,bbox_bottom+1,bbox_right,bbox_bottom+1,obj_Platform,true,true) && !place_meeting(x,y,obj_Platform)) || 
			(bbox_bottom+1) >= room_height) && velY >= 0 && velY <= fGrav) || (spiderBall && spiderEdge != Edge.None)) && (jump <= 0 || jumpStartFrame > 0));
}
#endregion
#region PlayerOnPlatform
function PlayerOnPlatform()
{
	return (place_meeting(x,y+1,obj_Platform) && !place_meeting(x,y,obj_Platform) && 
			fVelY >= 0 && state != State.Spark && state != State.BallSpark);
}
#endregion
#region AfterImage
function AfterImage(draw, rotation, delay, num, alpha)
{

	if(draw)
	{
		if(!global.gamePaused)
		{
			afterImgCounter += 1;
		}
		if(afterImgCounter > delay)
		{
			var echo = instance_create_layer(scr_round(x),scr_round(y),"Player",obj_PlayerEcho);
			echo.surfW = surfW;
			echo.surfH = surfH;
			echo.mask_index = mask_index;
			echo.fadeRate = (1 / max(num,1));
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
			echo.rotation = rotation;
			echo.alpha2 = alpha;
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
}
#endregion

#region player_water
function player_water()
{
	var xVel = x - xprevious,
		yVel = y - yprevious;

	if(justFell)
	{
		yVel = velY;
	}
    
	WaterBot = bbox_bottom-y;
	if(state == State.Grip && !startClimb)
	{
		WaterBot += 4;
	}

	water_update(2,xVel,yVel);

	//PhysState = ((water_at(x,y-12)) && !oControl.Power[17]);

	/*if (State == "JUMPING" or (State == "DASH" && !get_check("GROUND",1,0)))
	{
		WaterBot = -12;
	}

	if (State == "GRAPPLE")
	{
		WaterBot = 16;
	}

	if (PhysState != 0)
	{
		DashTime = 0;
		Dash = 0;
		DashPhase = 0;
		DashSpeed = 0;
	}*/

	/// -- Extra Splash -- \\\

	CanSplash ++;

	if (CanSplash > 65535)
	{
		CanSplash = 0;
	}

	if (in_water() && !in_water_top() && (CanSplash mod 2 == 0))
	{
		var splashx = x+random_range(4,-4);
		if(state == State.Grip && !startClimb)
		{
		    splashx -= 4*dir;
		}
		Splash = instance_create_layer(splashx,SplashY,"Liquids_fg",obj_SplashFXAnim);
		Splash.Speed = .25;
		Splash.sprite_index = sprt_WaterSplashSmall;
		Splash.image_alpha = 0.4;
		Splash.depth = 65;
		Splash.Splash = 1;
		Splash.image_index = 3;
		Splash.image_xscale = choose(1,-1);
    
		/*if (state == "grapple" && abs(grapAngVel) > 1 && abs(angle_difference(grapAngle,0)) < 90)//(State == "GRAPPLE" && abs(GrappleAngleVel)>1 && abs(angle_difference(GrappleAngle,0))<90 && Sprite != sSCrouch)
		{
		    Splash.sprite_index = sprt_WaterSplashLarge;
		    Splash.image_alpha = .5;
		    Splash.image_yscale = min(max(abs(grapAngVel)/7,.1),.7);
		    Splash.image_index = 0;
		}
		else*/
		if (xVel == 0 && abs(yVel) < 2)
		{
		    /*Splash.image_yscale = .65;
		    Splash.image_index = 5;
		    Splash.image_xscale = .75;*/
		    Splash.image_yscale = choose(.3,.5,.7,1);
		    Splash.image_index = 0;
		    Splash.image_xscale = choose(1.4,1);
		    Splash.sprite_index = sprt_WaterSplashTiny;
		    Splash.x += irandom(4) - 2;
		}
		else if (abs(xVel) > 0 && !StepSplash)
		{
		    Splash.sprite_index = sprt_WaterSkid;
		    Splash.image_alpha = 0.6;
		    Splash.depth = 65;
		    Splash.image_index = 1;
		    Splash.image_xscale = choose(1,-1);
		    Splash.Splash = 0;
		    Splash.x += xVel * 2;
		    Splash.xVel = xVel/4.5;
		    Splash.image_yscale = (.4 + min(.6,abs(xVel)/10)) * (choose(1, .5 + random(.4)));//.8 + random(.2);
		    Splash.y --;
        
		    StepSplash = 2;
        
		    /*if (choose(0,1,1) == 0)
		    {
		        Splash.image_yscale *= .1;
		        StepSplash = 1;
		    }*/
		}
    
		if(((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineEnd <= 0) || speedBoost)// (State == "SUPERJUMP" or DashPhase >= 2)
		{
		    if (CanSplash mod 2 == 0)
		    {
		        Splash.sprite_index = sprt_WaterSkidLarge;
		        Splash.Speed = .5;
		        Splash.image_yscale = 1;
		        Splash.image_index = 0;
		        Splash.image_xscale = 1;
		        Splash.image_index = 0;
		        Splash.image_alpha = .5;
		        Splash.Splash = 0;
		        Splash.x -= xVel;
		        repeat (3)
		        {
		            Drop = instance_create_layer(x,SplashY-4,"Liquids_fg",obj_WaterDrop);
		            Drop.xVel = -2.25+random(4.5);
		            Drop.yVel = -.5-random(2.5);
		            Drop.xVel += (xVel)/2;
		        }
            
		        if (CanSplash mod 4 == 0)
		        {
		            //sound_play_pos(sndSplashTiny,x,y,0);
		            //audio_play_sound(snd_SplashTiny,0,false);
		            audio_play_sound(snd_SplashSkid,0,false);
		        }
		    }
		}

		if ((!audio_is_playing(WaterShuffleSoundID[WaterShuffleCount]) or (abs(xVel > 0) && irandom(7) == 0))) && ((abs(xVel) > 0) or (irandom(23) == 0))
		{
		    audio_play_sound(WaterShuffleSoundID[WaterShuffleCount],0,false);
		    WaterShuffleCount = choose(0,1,2,3);
		}
	}


	/// -- Underwater Bubbles -- \\\ 
	
	var maxDashSpeed = maxSpeed[1,liquidState];
	if ((EnteredWater || (abs(xVel) >= maxDashSpeed && InWater)) && choose(1,1,1,0) == 1)
	{
		Bubble = instance_create_layer(x-8+random(16),bbox_top+random(bbox_bottom-bbox_top),"Liquids_fg",obj_WaterBubble);
    
		if (yVel > 0)
		{
		    Bubble.yVel += yVel/4;
		}
    
		if (EnteredWater < 60 && (state != State.Stand || abs(xVel) < maxDashSpeed))
		{
		    Bubble.Alpha *= (EnteredWater/60);
		    Bubble.AlphaMult *= (EnteredWater/60);
		} 
	}

	/// -- Leaving Drops

	if (LeftWater && choose(1,1,1,0,0) == 1)
	{
		Drop = instance_create_layer(x-8+random(16),y+4,"Liquids_fg",obj_WaterDrop);
 
		if (state == State.Somersault)
		{
			Drop.xVel = -random(7) + 3.5;
			Drop.yVel = -random(5) + 1;
		}
 
		with (Drop)
		{
			if (water_at(x,y))
			{
				Dead = 1;
				instance_destroy();
			}
		}
	}

	if (LeftWaterTop && choose(1,1,1,0,0) == 1)
	{
		Drop = instance_create_layer(x-8+random(16),bbox_bottom+random(bbox_top-y+4),"Liquids_fg",obj_WaterDrop);
 
		if (state == State.Somersault)
		{
			Drop.xVel = -random(6) + 3;
			Drop.yVel = -random(6) + 1;
		}
 
		with (Drop)
		{
			if (water_at(x,y))
			{
				Dead = 1;
				instance_destroy();
			}
		}
	}

	/// -- Breathing Bubbles --
	
	if(!instance_exists(obj_Lava))
	{
		BreathTimer --;
		if (BreathTimer < 16)
		{
			if (BreathTimer < 0)
			{
			    BreathTimer = choose(110,150,160);
			}
			else if (BreathTimer == 15 && InWaterTop)
			{
			    audio_play_sound(choose(snd_Breath_0,snd_Breath_1,snd_Breath_2),0,false);
			}
     
			if (InWaterTop && (BreathTimer mod 8 == 0))
			{
			    Bubble = instance_create_layer(x + 4*dir,bbox_top + 7, "Liquids_fg", obj_WaterBubble);
			    Bubble.xVel = dir/2 -.15 + random(.3);
			    Bubble.yVel = .2+random(.1);
			    Bubble.Breathed = 0.15;
			    Bubble.image_xscale /= choose(1.3,1.5);
			    Bubble.image_yscale = Bubble.image_xscale;
			    Bubble.xVel += (x - xprevious)/2;
			    Bubble.sprite_index = sprt_WaterBubbleSmall;
        
			    if (state == State.Grip)
			    {
			        Bubble.x -= (dir * 6);
			    }
			}
		}

		/// -- Screw Attack boiling nearby water --

		if (state == State.Somersault && misc[Misc.ScrewAttack] && suit[Suit.Gravity])
		{
			if (InWater)
			{
			    repeat (3)
			    {
			        D = instance_create_layer(x + random_range(16,-16), y+2 + random_range(16,-16), "Liquids_fg", obj_WaterBubble);
			        D.Delete = 1;
			        D.CanSpread = 0;
			    }
			}
		}

		if(((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineEnd <= 0) || speedBoost)
		{
			if (InWater)
			{
			    repeat (3)
			    {
			        D = instance_create_layer(random_range(bbox_left,bbox_right), random_range(bbox_top,bbox_bottom), "Liquids_fg", obj_WaterBubble);
			        D.Delete = 1;
			        D.CanSpread = 0;
			    }
			}
		}
	}
}
#endregion

#region ArmPos
function ArmPos(px, py)
{
	armOffsetX = px;
	armOffsetY = py;
}
#endregion
#region SetArmPosStand
function SetArmPosStand()
{
	switch scr_round(aimFrame)
	{
		case -4:
		{
			ArmPos((8+(dir == -1))*dir, 19);
			if(recoilCounter > 0)
			{
				armOffsetY -= 1;
			}
			break;
		}
		case -3:
		{
			ArmPos((13+(3*(dir == -1)))*dir, 14+(2*(dir == -1)));
			break;
		}
		case -2:
		{
			ArmPos(20*dir,10);
			if(recoilCounter > 0)
			{
				armOffsetX -= 1*dir;
				armOffsetY -= 1;
			}
			break;
		}
		case -1:
		{
			ArmPos(19*dir, 4 + (dir == -1));
			break;
		}
		case 1:
		{
			ArmPos((20 - (2*(dir == -1)))*dir, -(15 - (2*(dir == -1))));
			break;
		}
		case 2:
		{
			ArmPos(21*dir, -(21 + (dir == -1)));
			if(recoilCounter > 0)
			{
				armOffsetX -= 1*dir;
				armOffsetY += 1;
			}
			break;
		}
		case 3:
		{
			ArmPos(13*dir,-(26 + (dir == -1)));
			break;
		}
		case 4:
		{
			ArmPos(2*dir, -28);
			if(recoilCounter > 0)
			{
				armOffsetY += 1;
			}
			break;
		}
		default:
		{
			ArmPos(15*dir,1);
			if(recoilCounter > 0)
			{
				armOffsetX -= 1*dir;
			}
			break;
		}
	}
}
#endregion
#region SetArmPosJump
function SetArmPosJump()
{
	switch scr_round(aimFrame)
	{
	    case -4:
	    {
	        ArmPos((7+(dir == -1))*dir, 19);
	        if(recoilCounter > 0)
	        {
	            armOffsetY -= 1;
	        }
	        break;
	    }
	    case -3:
	    {
	        ArmPos((13+(dir == -1))*dir, 14);
	        break;
	    }
	    case -2:
	    {
	        ArmPos(18*dir,8);
	        if(recoilCounter > 0 && stateFrame != State.Walk && stateFrame != State.Run)
	        {
	            armOffsetX -= 1*dir;
	            armOffsetY -= 1;
	        }
	        break;
	    }
	    case -1:
	    {
	        ArmPos(17*dir, 5);
	        break;
	    }
	    case 1:
	    {
	        ArmPos(18*dir, -13);
	        break;
	    }
	    case 2:
	    {
	        ArmPos(17*dir, -20);
	        if(recoilCounter > 0 && stateFrame != State.Walk && stateFrame != State.Run)
	        {
	            armOffsetX -= 1*dir;
	            armOffsetY += 1;
	        }
	        break;
	    }
	    case 3:
	    {
	        ArmPos((11+(2*(dir == -1)))*dir,-(26+(dir == -1)));
	        break;
	    }
	    case 4:
	    {
	        ArmPos(2*dir, -28);
	        if(recoilCounter > 0)
	        {
	            armOffsetY += 1;
	        }
	        break;
	    }
	    default:
	    {
	        ArmPos(15*dir,1);
	        if(recoilCounter > 0)
	        {
	            armOffsetX -= 1*dir;
	        }
	        break;
	    }
	}
}
#endregion
#region SetArmPosTrans
function SetArmPosTrans()
{
	switch scr_round(aimFrame)
	{
	    case -2:
	    {
	        ArmPos(19*dir,8+(dir == -1));
	        break;
	    }
	    case 2:
	    {
	        ArmPos((20 - (dir == -1))*dir, -21);
	        break;
	    }
	    default:
	    {
	        SetArmPosJump();
	        break;
	    }
	}
}
#endregion
#region SetArmPosGrip
function SetArmPosGrip()
{
	switch scr_round(gripAimFrame)
	{
	    case 1:
	    {
	        ArmPos(-(18 + 2*(gripFrame >= 2) + gripFrame)*dir, 13 + (gripFrame >= 3));
	        if(dir == -1)
	        {
	            ArmPos(-(18 + clamp(gripFrame-1,0,1))*dir, 13 + clamp(gripFrame-1,0,2));
	        }
	        break;
	    }
	    case 2:
	    {
	        ArmPos(-(23 + (gripFrame >= 1) + gripFrame)*dir, 9);
	        if(dir == -1)
	        {
	            ArmPos(-(23 + clamp(gripFrame-1,0,2))*dir,9 + (gripFrame >= 3));
	        }
	        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
	        armOffsetY -= (recoilCounter > 0 && gripFrame >= 3);
	        break;
	    }
	    case 3:
	    {
	        ArmPos(-(26 + (gripFrame >= 1) + 3*(gripFrame >= 2))*dir, 1);
	        if(dir == -1)
	        {
	            ArmPos(-(27 + clamp(gripFrame-1,0,2))*dir, 1);
	        }
	        break;
	    }
	    case 4:
	    {
	        ArmPos(-(26 + gripFrame + (gripFrame >= 2))*dir,-(5 + (gripFrame >= 2)));
	        if(dir == -1)
	        {
	            ArmPos(-(28 + 2*clamp(gripFrame-1,0,2))*dir,-(6 + 2*(gripFrame >= 2)));
	        }
	        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
	        break;
	    }
	    case 5:
	    {
	        ArmPos(-(27+ gripFrame)*dir, -(16));
	        if(dir == -1)
	        {
	            ArmPos(-(28 + clamp(gripFrame-1,0,2))*dir, -(17 + (gripFrame >= 3)));
	        }
	        break;
	    }
	    case 6:
	    {
	        ArmPos(-(24+gripFrame)*dir, -21);
	        if(dir == -1)
	        {
	            ArmPos(-(24 + clamp(gripFrame-1,0,2))*dir, -21);
	        }
	        armOffsetX += (recoilCounter > 0 && gripFrame >= 3)*dir;
	        armOffsetY += (recoilCounter > 0 && gripFrame >= 3);
	        break;
	    }
	    case 7:
	    {
	        ArmPos(-(20 + gripFrame)*dir,-(27 + (gripFrame >= 3)));
	        if(dir == -1)
	        {
	            ArmPos(-(21 + clamp(gripFrame-1,0,2))*dir,-(27 + (gripFrame >= 3)));
	        }
	        break;
	    }
	    case 8:
	    {
	        ArmPos(-(10 + (gripFrame >= 1) + (gripFrame >= 3))*dir, -(30 + (gripFrame >= 2)));
	        if(dir == -1)
	        {
	            ArmPos(-(11 + (gripFrame >= 2))*dir, -(30 + (gripFrame >= 3)));
	        }
	        armOffsetY += (recoilCounter > 0 && gripFrame >= 3);
	        break;
	    }
	    default:
	    {
	        ArmPos(-(8+gripFrame)*dir, 15+clamp(gripFrame-1,0,2));
	        if(dir == -1)
	        {
	            ArmPos(-(9 + (gripFrame >= 2))*dir, 15 + gripFrame);
	        }
	        armOffsetY -= (recoilCounter > 0 && gripFrame >= 3);
	        break;
	    }
	}
}
#endregion
#region SetArmPosClimb
function SetArmPosClimb()
{
	switch (climbFrame)
	{
	    case 0:
	    {
	        ArmPos(5*dir,7);
	        break;
	    }
	    case 1:
	    {
	        ArmPos(5*dir,10);
	        break;
	    }
	    case 2:
	    {
	        ArmPos(7*dir,13);
	        break;
	    }
	    case 3:
	    {
	        ArmPos(9*dir,16);
	        break;
	    }
	    case 4:
	    {
	        ArmPos(9*dir,17);
	        break;
	    }
	    case 5:
	    {
	        ArmPos(8*dir,17);
	        break;
	    }
	    case 6:
	    {
	        ArmPos(7*dir,20);
	        break;
	    }
	    case 7:
	    {
	        ArmPos(7*dir,20);
	        break;
	    }
	    case 8:
	    {
	        ArmPos(8*dir,19);
	        break;
	    }
	    case 9:
	    {
	        ArmPos(9*dir,16);
	        break;
	    }
	    case 10:
	    {
	        ArmPos(9*dir,13);
	        break;
	    }
	    case 11:
	    {
	        ArmPos(15*dir,5);
	        break;
	    }
	}
}
#endregion
#region SetArmPosSpark
function SetArmPosSpark(rotation)
{
	armOffsetX = -9 * dsin(22.5 * max(bodyFrame-1,0));
	armOffsetY = 3;
	
	armOffsetX = lengthdir_x(armOffsetX,rotation);
	armOffsetY = lengthdir_y(armOffsetY,rotation);
}
#endregion
#region SetArmPosSomersault
function SetArmPosSomersault(sFrameMax, degNum, frame6)
{
	var rotPos = -((360/(sFrameMax-1)) * max(frame6-2,0) + degNum);
	switch bodyFrame
	{
		case 0:
		{
			ArmPos(2*dir,7);
			break;
		}
		case 1:
		{
			ArmPos(6*dir,10);
			break;
		}
		default:
		{
			ArmPos(lengthdir_x(10*dir,rotPos),lengthdir_y(10,rotPos));
			break;
		}
	}
}
#endregion

#region PreDrawPlayer
function PreDrawPlayer(xx, yy, rot, alpha)
{
	if(stateFrame == State.Morph)
	{
		if(state == State.Morph && morphFrame <= 0 && spiderBall)
		{
			spiderGlowAlpha += 0.02 * spiderGlowNum * (!global.gamePaused);
			if(spiderGlowAlpha <= 0.1)
			{
				spiderGlowNum = max(spiderGlowNum,1);
			}
			if(spiderGlowAlpha >= 0.75)
			{
				spiderGlowNum = -1;
			}
		}
		else
		{
			spiderGlowAlpha = max(spiderGlowAlpha - (0.1*(!global.gamePaused)), 0);
			spiderGlowNum = 2;
		}
		if(spiderGlowAlpha > 0)
		{
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_SpiderBallFX,0,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,min(spiderGlowAlpha,0.5)*alpha);
			gpu_set_blendmode(bm_normal);
		}
	}
	else
	{
		spiderGlowAlpha = 0;
		spiderGlowNum = 2;
	}
}
#endregion
#region DrawPlayer
function DrawPlayer(posX, posY, rotation, alpha)
{
	if(surface_exists(playerSurf))
	{
		surface_set_target(playerSurf);
		draw_clear_alpha(c_black,0);
		if(stateFrame != State.Morph || morphFrame > 0 || morphAlpha < 1)
		{
			var torso = torsoR;
			if(fDir == -1)
			{
				torso = torsoL;
			}
		
			if(legs != -1)
			{
				draw_sprite_ext(legs,legFrame,scr_round(surfW/2),scr_round(surfH/2),fDir,1,0,c_white,1);
			}
			draw_sprite_ext(torso,bodyFrame,scr_round(surfW/2),scr_round(surfH/2 + runYOffset),fDir,1,0,c_white,1);
		}
		if(stateFrame == State.Morph)
		{
			if(!global.gamePaused)
			{
				/*if(unmorphing)
				{
					morphAlpha = max(morphAlpha - 0.175/(1+liquidMovement), 0);
				}
				else if(morphFrame < 6)
				{
					morphAlpha = min(morphAlpha + 0.075/(1+liquidMovement), 1);
				}*/
				if(morphFrame < 4)
				{
					if(unmorphing)
					{
						morphAlpha = 0;
					}
					else
					{
						morphAlpha = 1;
					}
				}
			}
			var ballSprtIndex = sprt_MorphBall;
			if(misc[3])
			{
				ballSprtIndex = sprt_SpringBall;
			}
			draw_sprite_ext(ballSprtIndex,ballFrame,scr_round(surfW/2),scr_round(surfH/2),1,1,0,c_white,morphAlpha);
			if(misc[3])
			{
				draw_sprite_ext(sprt_SpringBall_Shine,0,scr_round(surfW/2),scr_round(surfH/2),1,1,0,c_white,morphAlpha);
			}
		}
	
		if(itemSelected == 1 && (itemHighlighted[1] == 0 || itemHighlighted[1] == 1 || itemHighlighted[1] == 3))
		{
			missileArmFrame = min(missileArmFrame + 1, 4);
		}
		else
		{
			missileArmFrame = max(missileArmFrame - 1, 0);
		}
		
		if(drawMissileArm && missileArmFrame > 0)
		{
			draw_sprite_ext(sprt_MissileArm,finalArmFrame+(9*(missileArmFrame-1)),scr_round((surfW/2)+scr_round(armOffsetX)),scr_round((surfH/2 + runYOffset)+scr_round(armOffsetY)),armDir,1,0,c_white,1);
		}
		if(!drawMissileArm)
		{
			missileArmFrame = 0;
		}
	
		if(stateFrame == State.Grip && climbIndex <= 0 && gripAimFrame == 0 && dir == -1)
		{
			draw_sprite_ext(sprt_ArmGripOverlay,gripFrame,scr_round(surfW/2),scr_round(surfH/2 + runYOffset),fDir,1,0,c_white,1);
		}
	
		surface_reset_target();
	
		if(dmgFlash <= 0 && immuneTime > 0 && (immuneTime&1))
		{
			gpu_set_blendmode(bm_add);
		}
		else
		{
			gpu_set_blendmode(bm_normal);
		}
		var sc = dcos(rotation),
			ss = dsin(rotation),
			sx = (surfW/2),
			sy = (surfH/2);
		var sxx = scr_round(posX)-sc*sx-ss*sy,
			syy = scr_round(posY)-sc*sy+ss*sx;
		draw_surface_ext(playerSurf,sxx+sprtOffsetX,syy+sprtOffsetY,1,1,rotation,c_white,alpha);
		gpu_set_blendmode(bm_normal);
	}
	else
	{
		playerSurf = surface_create(surfW,surfH);
		surface_set_target(playerSurf);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
#endregion
#region PostDrawPlayer
function PostDrawPlayer(posX, posY, rot, alph)
{
	var xx = scr_round(posX),
		yy = scr_round(posY);

	if(misc[3] && stateFrame == State.Morph)
	{
		var glowSpeed = 0.25;
		if(state == State.BallSpark)
		{
			glowSpeed = 0.375;
		}
		else if(shineCharge > 0)
		{
			glowSpeed = -0.45;
		}
		var palSet = pal_BallGlow;
		if(suit[0])
		{
			palSet = pal_BallGlow_Varia;
		}
		if(suit[1])
		{
			palSet = pal_BallGlow_Gravity;
		}
		ballGlowIndex = scr_wrap(ballGlowIndex + glowSpeed*(!global.gamePaused), 1, 10);
		pal_swap_set(palSet,ballGlowIndex,0,0,false);
		draw_sprite_ext(sprt_SpringBall_Glow,ballFrame,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,morphAlpha*alph);
		shader_reset();
	}
	else
	{
		ballGlowIndex = 1;
	}

	if(isScrewAttacking && frame[6] >= 2 && !canWallJump && wjFrame <= 0)
	{
		screwFrameCounter += 1*(!global.gamePaused);
		if(screwFrameCounter >= 2)
		{
			screwFrame = scr_wrap(screwFrame+1,0,3);
			screwFrameCounter = 0;
		}
		var a = 0.9;
		if(screwFrameCounter mod 2 != 0)
		{
			a = 0.5;
		}
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprt_ScrewAttackFX,screwFrame,xx,yy,dir,1,0,make_color_rgb(0,248,112),alph*a);
		gpu_set_blendmode(bm_normal);
	}
	else
	{
		screwFrame = 0;
		screwFrameCounter = 0;
	}
	
	if(itemSelected == 1 && itemHighlighted[1] == 3 && item[Item.Grapple] && state != State.Morph && morphFrame <= 0 && instance_exists(grapple) && state != State.Somersault)
	{
	    var sPosX = xx+sprtOffsetX+armOffsetX,
	        sPosY = yy+sprtOffsetY+runYOffset+armOffsetY;

	    var gx = scr_round(sPosX),
	        gy = scr_round(sPosY);
	    draw_sprite_ext(sprt_GrappleBeamStart,grapPartFrame,gx,gy,1,1,0,c_white,1);
	    //part_particles_create(obj_Particles.partSystemB,gx,gy,obj_Particles.PartBeam[3],1);
	    //part_particles_create(obj_Particles.partSystemB,gx,gy,obj_Particles.PartBeam[2],1);

	    if(grapple.drawGrapDelay <= 0)
	    {
	        var sprt = sprt_GrappleBeamChain,
	            startX = scr_round(sPosX),
	            startY = scr_round(sPosY),
	            endX = scr_round(xx + (grapple.x - obj_Player.x)),
	            endY = scr_round(yy + (grapple.y - obj_Player.y));
    
	        var linklength = sprite_get_width(sprt),
	            chainX = endX - startX,
	            chainY = endY - startY;
    
	        var length = point_distance(startX, startY, endX, endY);
	        if(length >= linklength)
	        {
	            var numlinks = ceil(length/linklength);
	            linksX[numlinks] = 0;
	            linksY[numlinks] = 0;
	            var rotation2 = point_direction(startX, startY, endX, endY);
    
	            for(i = 1; i < numlinks+1; i++)
	            {
	                linksX[i] = startX + chainX/numlinks * i;
	                linksY[i] = startY + chainY/numlinks * i;
                
	                draw_sprite_ext(sprt,random_range(0,3),linksX[i],linksY[i],image_xscale,image_yscale,rotation2,c_white,1);
	            }
	        }
	        /*var rotation2 = point_direction(startX, startY, endX, endY);
	        grappleBeamFrame = scr_Loop(grappleBeamFrame+1,0,5);

	        draw_set_blend_mode(bm_add);
	        draw_sprite_ext(sprt_GrappleBeam,grappleBeamFrame,startX,startY,length/192,0.275,rotation2,c_white,.9);
	        draw_sprite_ext(sprt_GrappleBeamGlow,grappleBeamFrame,startX,startY,length/192,0.3, rotation2, make_color_rgb(32,128,255),.9);
	        draw_set_blend_mode(bm_normal);*/
	    }
	    if(grapPartCounter > 1)
	    {
	        grapPartFrame = scr_wrap(grapPartFrame+1,0,1);
	        grapPartCounter = 0;
	    }
	    grapPartCounter += 1;
	}
	else
	{
		particleFrameMax = floor((maxCharge - statCharge) / 10);
		if(statCharge >= 10)
		{
			if(!global.gamePaused)
			{
				chargeFrameCounter += 1;
				if(chargeFrameCounter == 1 || chargeFrameCounter == 3)
				{
					particleFrame++;
				}
				if(chargeFrameCounter > 1)
				{
					chargeFrame++;
					chargeFrameCounter = 0;
				}
			}
			chargeSetFrame = 0;
			if(statCharge >= maxCharge*0.25 && statCharge < maxCharge*0.5)
			{
				chargeSetFrame = 1;
			}
			if(statCharge >= maxCharge*0.5 && statCharge < maxCharge*0.75)
			{
				chargeSetFrame = 2;
			}
			if(statCharge >= maxCharge*0.75 && statCharge < maxCharge)
			{
				chargeSetFrame = 3;
			}
			if(statCharge >= maxCharge)
			{
				chargeSetFrame = 4;
			}
	
			if(chargeFrame >= 2)
			{
				chargeFrame = 0;
			}
			chargeSetFrame += chargeFrame;
	
			var isIce = (beamChargeAnim == sprt_IceBeamChargeAnim),
				isWave = (beamChargeAnim == sprt_WaveBeamChargeAnim),
				isSpazer = (beamChargeAnim == sprt_SpazerChargeAnim),
				isPlasma = (beamChargeAnim == sprt_PlasmaBeamChargeAnim);
	
			var partSys = obj_Particles.partSystemB;
			if(string_count("Wave",object_get_name(beamShot)) > 0)
			{
				partSys = obj_Particles.partSystemA;
			}
			if(particleFrame >= particleFrameMax && !global.roomTrans && !global.gamePaused)
			{
				var color1 = c_red, color2 = c_yellow;
				var partType = 0;
				if(isIce)
				{
					color1 = c_blue;
					color2 = c_aqua;
					partType = 1;
				}
				else if(isWave)
				{
					color1 = c_purple;
					color2 = c_fuchsia;
					partType = 2;
				}
				else if(isSpazer)
				{
					color1 = c_red;
					color2 = c_yellow;
					partType = 3;
				}
				else if(isPlasma)
				{
					color1 = c_green;
					color2 = c_lime;
					partType = 4;
				}
		
				var partRange = 24;
				var pX = xx+sprtOffsetX+armOffsetX, pY = yy+sprtOffsetY+runYOffset+armOffsetY;
				var part = instance_create_layer(pX+random_range(-partRange,partRange),pY+random_range(-partRange,partRange),"Player",obj_ChargeParticle);
				part.color1 = color1;
				part.color2 = color2;
		
				var x1 = pX-8,
					x2 = pX+8,
					y1 = pY-8,
					y2 = pY+8;
				chargeEmit = part_emitter_create(partSys);
				part_emitter_region(partSys,chargeEmit,x1,x2,y1,y2,ps_shape_ellipse,ps_distr_gaussian);
				part_emitter_burst(partSys,chargeEmit,obj_Particles.bTrails[partType],2+(statCharge >= maxCharge));
		
				particleFrame = 0;
			}
			else if(part_emitter_exists(partSys,chargeEmit))
			{
				part_emitter_destroy(partSys,chargeEmit);
			}
			if(stateFrame != State.Morph)
			{
				draw_sprite_ext(beamChargeAnim,chargeSetFrame,xx+sprtOffsetX+armOffsetX,yy+sprtOffsetY+runYOffset+armOffsetY,image_xscale,image_yscale,0,c_white,alph);
			}
		}
		else
		{
			chargeSetFrame = 0;
			chargeFrame = 0;
			chargeFrameCounter = 0;
			particleFrame = 0;
		}
	}
}
#endregion