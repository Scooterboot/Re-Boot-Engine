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
gunReady2 = false;
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

energyMax = 1499;//99 + (100 * energyTanks);
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
	ScrewAttack,
	Spider
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
//misc[Misc.Morph] = true;
//misc[Misc.Bomb] = true;
//beam[Beam.Charge] = true;
//boots[Boots.SpeedBoost] = true;

for(var i = 0; i < array_length_1d(suit); i++)
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
}


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

selectTap = 0;
selectTapMax = 10;

//currentMap = global.mapArea;

//playerMapX = (scr_floor(obj_Player.x/global.resHeight) + global.rmMapPosX) * 8;
//playerMapY = (scr_floor(obj_Player.y/global.resHeight) + global.rmMapPosY) * 8;

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