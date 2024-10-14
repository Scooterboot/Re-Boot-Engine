/// @description Initialize
event_inherited();

image_speed = 0;
image_index = 0;

#region Gameplay Tweaks

// enable/disable debug controls - synced with obj_Display's debug variable
debug = false;
// press 0 to refill health & ammo
// press 9 to face toward screen / activate elevator pose
// press 8 to set health to 1
// press 7 to acquire all abilities
// press 6 to acquire a random ability
// press 5 to enable/disable godmode
godmode = false;
// press 4 to toggle hyper beam
//no clip controls: press numpad 8,5,4,6 to move up,down,left,right
// hold shift to reduce fps to 2
// hold ctrl to increase fps up to 600 (may not always reach that high)


// "Arm Pumping" is a classic SM speedrunning tech
//Tapping any aim button will shift the player forward one pixel during grounded movement.
armPumping = true;

// Allows vertical aiming via [Aim Up]+[Aim Down] (L+R) while moving
allowMovingVertAim = true;

// Continue speed boosting/keep momentum after landing (also applies to spider ball)
// 0 = disabled
// 1 = enabled always
// 2 = enabled, but disabled during Gravity-less underwater movement
speedKeep = 0;

// Restricts speed boost activation to require the run state.
// Setting to false allows boost ball and other things to activate it.
restrictSBToRun = true;

// Run animation tweak
// Set to true (default) to use a smooth run anim speed
// Set to false to use an anim speed that is much more closely tied to the speed counter
// The latter is much better at giving feedback for super short charging
smoothRunAnim = true;

// Allows reflecting horizontal speed via wall jump
fastWallJump = true;

// Preserve speed boost/blue suit during fast wall jump (requires fastWallJump = true)
speedBoostWallJump = true;

// Cancel Shine Spark mid-flight by pressing jump
shineSparkCancel = false;//true;

// Low-level Shine Spark flight control / Shine Spark steering
//press directions or angle buttons to slightly change flight direction
shineSparkFlightAdjust = false;

// High-level Shine Spark flight control when Accel Dash is enabled
//activated by holding a direction and pressing Run during flight (consumes Dash charge)
shineSparkRedirect = false;

// Make diagonal sparks slide up/down walls
// To still use Chain Spark, press in the direction of the wall you're sliding on to initiate
diagSparkSlideOnWalls = true;

// Re-charge a new shine spark during chain spark wall jumping
// Press toward wall and down
chainSparkReCharge = false;

// Allows canceling accel dash by shooting
// Can be utilized for easy super short charging
cancelDashShoot = false;

// Prime-like trail effect for Morph Ball
// Disables normal after images for Morph while set to true
drawBallTrail = true;

// Allow Crystal Flash to clip you through tiles
// Can easily get you stuck if you don't know what you're doing
crystalClip = false; // default: false

#endregion

#region Main

enum State
{
	Stand,
	Elevator,
	Recharge,
	Crouch,
	Walk,
	Moon,
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
	Death,
	Dodge,
	CrystalFlash,
	Push
};
state = State.Stand; //stand, crouch, morph, jump, somersault, grip, spark, ballSpark, grapple, hurt
prevState = state;
lastState = prevState;

grounded = true;
prevGrounded = grounded;
slopeGrounded = false;

canWallJump = false;
fastWJCheckVel = 0;

uncrouch = 0;
//uncrouched = true;

canMorphBounce = true;
justBounced = false;

aimAngle = 0; //2 = verticle up, 1 = diagonal up, 0 = forward, -1 = diagonal down, -2 = vertical down
prevAimAngle = aimAngle;
lastAimAngle = prevAimAngle;
aimUpDelay = 0;

extAimAngle = 0;
extAimPreAngle = 0;

move = 0;
move2 = 0;
pMove = 0;

dir = 0; //0 = face screen, 1 = face right, -1 = face left
fDir = dir;
oldDir = dir;
lastDir = oldDir;

speedCounter = 0;
//speedCounterMax = 80;//120;
speedCounterMax = 4;
speedBuffer = 0;
speedBufferMax = 10;
speedBufferCounter = 0;
speedBufferCounterMax = [2.5, 3, 2.5, 2, 1.5, 1];

speedBoost = false;
speedFXCounter = 0;
speedCatchCounter = 0;
speedKill = false;
speedKillCounter = 0;
speedKillMax = 6;

speedBoostWJ = false;
speedBoostWJCounter = 0;
speedBoostWJMax = 8;//12;

shineCharge = 0;
shineChargeMax = 300;

shineDir = 0;
shineDirDiff = 0;
shineStart = 0;
shineEnd = 0;
shineEndMax = 40;//30;
shineSparkStartSpeed = 10;
shineSparkSpeed = shineSparkStartSpeed;
shineSparkSpeedMax = 15;//13;
shineFXCounter = 0;
shineRampFix = 0;

shineDownRot = 0;
shineRestart = false;

shineLauncherStart = 0;

/*
	Shine spark direction was a bit annoying to set up,
	but i needed it so that right is positive and left is negative,
	so i ended up with this:
	
	 0 = Down
	 +45 = Down-Right, -45 = Down-Left
	 +90 = Right, -90 = Left
	 +135 = Up-Right, -135 = Up-Left
	 +/-180 = Up
	
	All values have a +/-22.5 degree variance,
	due to the existence of omni-directional reflec panels.
*/
function GetSparkDir() { return scr_wrap(shineDir+shineDirDiff,-180,180); }
function SparkDir_VertUp() { return abs(GetSparkDir()) > 157.5; }
function SparkDir_DiagUp() { return abs(GetSparkDir()) >= 112.5 && abs(GetSparkDir()) <= 157.5; }
function SparkDir_Hori() { return abs(GetSparkDir()) > 67.5 && abs(GetSparkDir()) < 112.5; }
function SparkDir_DiagDown() { return abs(GetSparkDir()) >= 22.5 && abs(GetSparkDir()) <= 67.5; }
function SparkDir_VertDown() { return abs(GetSparkDir()) < 22.5; }


spiderBall = false;
spiderEdge = Edge.None;
prevSpiderEdge = spiderEdge;
spiderMove = 0;
spiderSpeed = 0;
spiderJump = false;
spiderJumpDir = 0;
spiderJump_SpeedAddX = 0;
spiderJump_SpeedAddY = 0;

spiderGlowAlpha = 0;
spiderGlowNum = 1;

sparkCancelSpiderJumpTweak = false;

boostBallCharge = 0;
boostBallChargeMax = 80;
boostBallChargeMin = 40;
boostBallDmgCounter = 0;
boostBallFX = 0;
boostBallFXFlash = false;
boostBallSnd = noone;


isChargeSomersaulting = false;
isSpeedBoosting = false;
isScrewAttacking = false;

stepSndPlayedAt = 0;

walkState = false;

moonFallState = false;
moonFallCounter = 0;
moonFallCounterMax = 12;//30;
moonFall = false;

//uncrouching = false;

ledgeFall = false;
ledgeFall2 = false;
justFell = false;
fell = false;

onPlatform = false;

upClimbCounter = 0;

startClimb = false;
climbTarget = 0;
climbIndex = 0;
climbIndexCounter = 0;
//climbX = array(0,0,0,0,0,1,2,2,2,2,2,1,1,0,0,0,0,0,0);
//climbY = array(0,6,6,5,5,4,4,2,0,0,0,0,0,0,0,0,0,0,0);
climbX = [0,0,0,0,0,0,3,3,2,2,2,1,1,0,0,0,0,0,0];
climbY = [0,6,6,6,5,5,4,0,0,0,0,0,0,0,0,0,0,0,0];

quickClimbTarget = 0;

invFrames = 0;
//96 default, 60 spikes
hurtTime = 0; //45
hurtSpeedX = 0;
hurtSpeedY = 0;
dmgFlash = 0;

dmgBoost = 0;
dmgBoostJump = false;

dodgePress = 0;
groundedDodge = 0;
dodgeDir = 0;
dodged = false;
dodgeLength = 0;
dodgeLengthMax = 20;//25;
canDodge = true;
dodgeRechargeMax = 20;
dodgeRecharge = dodgeRechargeMax;
dodgeRechargeRate = 0.5;

isPushing = false;
pushBlock = noone;
//pushMove = array(0,0,1,1,1,0,1,0,1,0,1,1,1,1,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,0,1,0,0,0,0,1,0,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,0,1,0,1,0,0,0,0,0,0,0,0,0);
//pushMove = array(2, 2, 3, 4, 2, 1, 0, 3, 4, 1, 1, 3, 4, 3, 4, 3, 2, 0);
pushMove = array(2, 2, 3, 4, 2, 1, 0, 0, 1, 1, 3, 4, 3, 4, 3, 2);

activeStation = noone;

liquidState = 0;
outOfLiquid = (liquidState == 0);

liquidLevel = 0;
//gunLiquidLevel = 0;

statCharge = 0;
maxCharge = 60;

bombCharge = 0;
bombChargeMax = 30;

shootDir = 0;
shootSpeed = 10;//8;

shotDelayTime = 0;
bombDelayTime = 0;

enqueShot = false;

waveDir = 1;


immune = false;


cRight = false;
cLeft = false;
cUp = false;
cDown = false;
cJump = false;
cShoot = false;
cSprint = false;
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
rSprint = !cSprint;
rAngleUp = !cAngleUp;
rAngleDown = !cAngleDown;
rAimLock = !cAimLock;
rMorph = !cMorph;

rMorphJump = false;

XRay = noone;
//XRayDying = 0;

constantDamageDelay = 0;

grapple = noone;
grappleActive = false;
grappleDist = 0;
grappleOldDist = 0;
grappleMaxDist = 160;//143;

grapAngle = 0;
grapDisVel = 0;

grapBoost = false;

grappleVelX = 0;
grappleVelY = 0;

grapWJCounter = 0;

grapWallBounceCounter = 0;
prevGrapVelocity = 0;

cFlashStartCounter = 0;
cFlashStartMove = 0;
cFlashDuration = 0;
cFlashDurationMax = 30;
cFlashStep = 15;
cFlashLastEnergy = 0;
cFlashAmmoUse = 0;

stallCamera = false;

reflecList = ds_list_create();
lastReflec = noone;

#endregion
#region Physics Vars

// -- Horizontal speed values --
// Out of water (or in water with grav suit)
maxSpeed[0,0] = 2.75;	// Running
maxSpeed[1,0] = 4.75;	// Sprinting (no speed boost)
maxSpeed[2,0] = 9.75;	// Speed Boosting
maxSpeed[3,0] = 1.25;	// Jump
maxSpeed[4,0] = 1.375;	// Somersault
maxSpeed[5,0] = 3.25;	// Morph Ball
maxSpeed[6,0] = 5.25;	// Mock Ball
maxSpeed[7,0] = 1;		// Air Morph
maxSpeed[8,0] = 1.25;	// Air Spring Ball
maxSpeed[9,0] = 5.375;	// Damage Boost
maxSpeed[10,0] = 7.25;	// Dodge
maxSpeed[11,0] = 1.25;	// Moonwalk
maxSpeed[12,0] = 2.125;	// Moonwalk (sprint)
maxSpeed[13,0] = 1.75;	// Moonfall
maxSpeed[14,0] = 4.75;	// Boost Ball
// Underwater (no grav suit)
maxSpeed[0,1] = 2.75;	// Running
maxSpeed[1,1] = 3.75;	// Sprinting (no speed boost)
maxSpeed[2,1] = 6.75;	// Speed Boosting
maxSpeed[3,1] = 1.25;	// Jump
maxSpeed[4,1] = 1.375;	// Somersault
maxSpeed[5,1] = 2.75;	// Morph Ball
maxSpeed[6,1] = 4.75;	// Mock Ball
maxSpeed[7,1] = 1;		// Air Morph
maxSpeed[8,1] = 1.25;	// Air Spring Ball
maxSpeed[9,1] = 3.3;	// Damage Boost
maxSpeed[10,1] = 3.25;	// Dodge
maxSpeed[11,1] = 0.75;	// Moonwalk
maxSpeed[12,1] = 1.25;	// Moonwalk (sprint)
maxSpeed[13,1] = 1.5;	// Moonfall
maxSpeed[14,1] = 3.75;	// Boost Ball
// In lava/acid (no grav suit)
maxSpeed[0,2] = 1.75;	// Running
maxSpeed[1,2] = 2.75;	// Sprinting (no speed boost)
maxSpeed[2,2] = 5.75;	// Speed Boosting
maxSpeed[3,2] = 1.25;	// Jump
maxSpeed[4,2] = 1.375;	// Somersault
maxSpeed[5,2] = 2.75;	// Morph Ball
maxSpeed[6,2] = 4.75;	// Mock Ball
maxSpeed[7,2] = 1;		// Air Morph
maxSpeed[8,2] = 1.25;	// Air Spring Ball
maxSpeed[9,2] = 3.3;	// Damage Boost
maxSpeed[10,2] = 3.25;	// Dodge
maxSpeed[11,2] = 0.75;	// Moonwalk
maxSpeed[12,2] = 1.25;	// Moonwalk (sprint)
maxSpeed[13,2] = 1.5;	// Moonfall
maxSpeed[14,2] = 2.75;	// Boost Ball

// Out of water
moveSpeed[0,0] = 0.1875;	// Normal
moveSpeed[1,0] = 0.1;		// Morph
moveSpeed[2,0] = 0.0625;	// Sprint/Speedboost
moveSpeed[3,0] = 0.109375;	// Shine Spark
moveSpeed[4,0] = 0.125;		// Grapple
// Underwater (no grav suit)
moveSpeed[0,1] = 0.015625;	// Normal
moveSpeed[1,1] = 0.02;		// Morph
moveSpeed[2,1] = 0.015625;	// Sprint/Speedboost
moveSpeed[3,1] = 0.03125;	// Shine Spark
moveSpeed[4,1] = 0.0225;	// Grapple
// In lava/acid (no grav suit)
moveSpeed[0,2] = 0.015625;	// Normal
moveSpeed[1,2] = 0.02;		// Morph
moveSpeed[2,2] = 0.015625;	// Sprint/Speedboost
moveSpeed[3,2] = 0.03125;	// Shine Spark
moveSpeed[4,2] = 0.0225;	// Grapple

frict[0] = 0.5;		// Out of water
frict[1] = 0.5;		// Underwater
frict[2] = 0.25;	// In lava/acid

// turn around speed is equal to moveSpeed + frict
// this value gets added on top when holding run
sprintTurnSpeed[0] = 1.575;		// Out of water
sprintTurnSpeed[1] = 1.07125;		// Underwater
sprintTurnSpeed[2] = 0.57125;		// In lava/acid

//bombXSpeedMax[0] = 2.75;		// Out of water
//bombXSpeedMax[1] = 1;		// Underwater
//bombXSpeedMax[2] = 1;		// In lava/acid

//bombXSpeed[0] = 0.1875-0.03125;		// Out of water
//bombXSpeed[1] = 0.0625;		// Underwater
//bombXSpeed[2] = 0.0625;		// In lava/acid

bombXSpeed[0] = 2.75;		// Out of water
bombXSpeed[1] = 1.5;		// Underwater
bombXSpeed[2] = 1.5;		// In lava/acid


// -- Vertical speed values --
// Out of water
jumpSpeed[0,0] = 4.875;	// Normal Jump
jumpSpeed[1,0] = 6;		// Hi Jump
jumpSpeed[2,0] = 4.625;	// Wall Jump
jumpSpeed[3,0] = 5.5;	// Hi Wall Jump
jumpSpeed[4,0] = 5;		// Damage Boost
// Underwater
jumpSpeed[0,1] = 1.75;			// Normal Jump
jumpSpeed[1,1] = 2.5;			// Hi Jump
jumpSpeed[2,1] = 0.375;//1.25;//0.25;	// Wall Jump
jumpSpeed[3,1] = 0.625;//2.25;//0.5;	// Hi Wall Jump
jumpSpeed[4,1] = 2;			// Damage Boost
// In lava/acid
jumpSpeed[0,2] = 2;//2.75;	// Normal Jump
jumpSpeed[1,2] = 2.75;//3.5;	// Hi Jump
jumpSpeed[2,2] = 1.5;//2.625;	// Wall Jump
jumpSpeed[3,2] = 2.5;//3.5;	// Hi Wall Jump
jumpSpeed[4,2] = 2;	// Damage Boost

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

grapGrav[0] = 0.21875;		// Out of water
grapGrav[1] = 0.0546;		// Underwater
grapGrav[2] = 0.0615;	// In lava/acid

fallSpeedMax = 5; // Maximum fall speed - soft cap
moonFallMax = 32;

bombJumpMax[0] = 13;	// air
bombJumpMax[1] = 1;		// underwater
bombJumpMax[2] = 1;//3;		// under lava/acid

bombJumpSpeed[0] = 2;		// air
bombJumpSpeed[1] = 1;		// underwater
bombJumpSpeed[2] = 1;//0.01;	// under lava/acid


// -- (f)inalized variables --
fMaxSpeed = maxSpeed[0,0];
fMoveSpeed = moveSpeed[0,0];
fFrict = frict[0];
fGrav = grav[0];
fJumpSpeed = jumpSpeed[0,0];
fJumpHeight = jumpHeight[0,0];


// -- other variables --
jump = 0;
jumping = false;
jumpStart = false;
jumpStop = !jumpStart;

coyoteJumpMax = 3;
coyoteJump = coyoteJumpMax;
bufferJumpMax = 7;//5;
bufferJump = bufferJumpMax;

morphSpinJump = false;

bombJump = 0;
bombJumpX = 0;


velX = 0;
velY = 0;

prevVelX = velX; // used for stutter step

fVelX = 0;
fVelY = 0;

shiftX = 0;
shiftY = 0;

#endregion
#region Animation

stateFrame = State.Stand;
//stand, crouch, walk, run, brake, morph, jump, somersault, grip, spark, grapple, hurt
prevStateFrame = stateFrame;
lastStateFrame = prevStateFrame;

dirFrame = 0;

//Run Torso Y Offset
rOffset =  array(1,0,0,1,2,2,3,2,1,1,0,0,0,1,2,2,3,2,1,1,0,0);
rOffset2 = array(0,0,0,0,1,1,2,2,1,1,0,0,0,0,1,1,2,2,1,1,0,0);

//Moon Walk Torso Y Offset
mOffset = array(0,0,0,0,1,1,1,0,0,0,1,1,1);

runYOffset = 0;
runAimSequence = array(0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1);

runAnimCounterMax = [3, 2.5, 2, 1.5, 1];

brake = false;
brakeFrame = 0;

enum Frame
{
	Idle = 0,
	Run = 1,
	Morph = 2,
	Ball = 3,
	JAim = 4,
	Jump = 5,
	Somersault = 6,
	Walk = 7,
	Moon = 8,
	SparkV = 9,
	SparkH = 10,
	SparkStart = 11,
	GrappleLeg = 12,
	Dodge = 13,
	GrappleBody = 14,
	CFlash = 15,
	Push = 16
};

frame[16] = 0;
frameCounter[16] = 0;

idleNum = array(32,8,8,8,16,6,6,6);
idleSequence = array(0,1,2,3,4,3,2,1);

idleNum_Low = array(12,4,4,4,10,4,4,4);
idleSequence_Low = array(0,2,4,4,5,3,3,1);

wjFrame = 0;
//wjSequence = array(3,3,3,2,2,1,1,1,0);
wjSequence = array(3,3,3,2,2,1,1,0,0);
wjAnimDelay = 0;
wjGripAnim = false;

crouchFrame = 0;

morphFrame = 0;
unmorphing = false;
morphAlpha = 0;
ballFrame = 0;
morphNum = 0;
ballAnimDir = dir;
morphYOff = 0;

aimFrame = 0;

aimSnap = 0;

aimAnimTweak = 0;

transFrame = 0;
runToStandFrame[1] = 0;

walkToStandFrame = 0;

landFrame = 0;
smallLand = false;

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
grapMoveAnim = 0;

grapPartFrame = 0;
grapPartCounter = 0;

hurtFrame = 0;

pushFrameSequence = array(0,1,2,3,4,5,5,6,7,8,9,9,10,11,12,13,14,15);

torsoR = sprt_Player_StandCenter;
torsoL = torsoR;
legs = -1;
gripOverlay = -1;
gripOverlayFrame = 0;

sprtOffsetX = 0;
sprtOffsetY = 0;

bodyFrame = 0;
legFrame = 0;

spaceJump = 0;

recoil = false;
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
rotReAlignStep = 3;

hudBOffsetX = 0;
hudIOffsetX = 0;

dBoostFrame = 0;
dBoostFrameCounter = 0;
dBoostFrameSeq = [0,1,17,16,15,14,12,11,10,9,8,7,6,5,4,3,2,1,0];

shineFrame = 0;
shineFrameCounter = 0;

screwFrame = 0;
screwFrameCounter = 0;


// underwater gravity suit glow
gravGlowAlpha = 0;
gravGlowNum = 10;

introAnimState = 0;
introAnimCounter = 0;
introAnimFrame = 0;
introAnimFrameCounter = 0;

saveAnimCounter = 0;
saveAnimFrame = 0;
saveAnimFrameCounter = 0;

cBubbleScale = 0;
cFlashFrameSequence = array(0,1,2,1);

/*
memeDance = false;
memeDanceFrame = 0;
memeDanceFrameCounter = 0;
memeDanceSeq = 
[14.4, 3.6, 3.6, 3.6, 7.2, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6,14.4, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6,
  7.2, 3.6, 3.6, 7.2, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 7.2, 3.6, 3.6, 3.6,10.8, 3.6, 3.6, 7.2, 3.6, 3.6,
  3.6, 3.6, 3.6, 3.6,10.8, 3.6, 3.6, 7.2, 3.6, 3.6, 7.2, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6,
  3.6, 3.6, 3.6, 3.6, 3.6,10.8, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6, 3.6,
  3.6, 7.2, 3.6, 3.6, 3.6, 7.2, 3.6, 3.6, 3.6, 7.2, 7.2, 3.6, 3.6, 3.6,14.4];
*/

#endregion
#region Audio

lowEnergySnd = noone;

chargeSoundPlayed = false;

somerSoundPlayed = false;
somerUWSndCounter = 0;

speedSoundPlayed = false;

screwSoundPlayed = false;

heatDmgSnd = noone;

#endregion
#region Item Vars

/*energyTanks = 14;
missileTanks = 51;
superMissileTanks = 15;
powerBombTanks = 10;*/

energyMax = 99;//1499;//99 + (100 * energyTanks);
energy = energyMax;
lowEnergyThresh = 30;

damageReduct = 1;

missileMax = 0;//250;//5 * missileTanks;
missileStat = missileMax;

superMissileMax = 0;//50;//2 * superMissileTanks;
superMissileStat = superMissileMax;

powerBombMax = 0;//50;//2 * powerBombTanks;
powerBombStat = powerBombMax;

enum Suit
{
	Varia,
	Gravity
};
// 2 Suits
suit = array_create(2);

enum Boots
{
	HiJump,
	SpaceJump,
	Dodge,
	SpeedBoost,
	ChainSpark
};
// 5 Boots
boots = array_create(5);

enum Misc
{
	PowerGrip,
	Morph,
	Bomb,
	Spring,
	Boost,
	Spider,
	ScrewAttack
};
// 7 Misc
misc = array_create(7);

enum Beam
{
	Charge,
	Ice,
	Wave,
	Spazer,
	Plasma
};
// 5 Beams
beam = array_create(5);

enum Item
{
	Missile,
	SMissile,
	PBomb,
	Grapple,
	XRay
};
// 5 Items
item = array_create(5);

hasSuit = array_create(array_length(suit));
hasMisc = array_create(array_length(misc));
hasBoots = array_create(array_length(boots));
hasBeam = array_create(array_length(beam));
hasItem = array_create(array_length(item));

//starting items
/*misc[Misc.PowerGrip] = true;
hasMisc[Misc.PowerGrip] = true;
misc[Misc.Morph] = true;
hasMisc[Misc.Morph] = true;
misc[Misc.Bomb] = true;
hasMisc[Misc.Bomb] = true;
beam[Beam.Charge] = true;
hasBeam[Beam.Charge] = true;*/
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

hyperBeam = false;


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

beamIsWave = false;
beamWaveStyleOffset = 1;

beamFlare = sprt_PowerBeamChargeFlare;

#endregion
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

currentMap = global.rmMapArea;
playerMapX = -1;
playerMapY = -1;
if(instance_exists(obj_Map))
{
	playerMapX = obj_Map.GetMapPosX(x);
	playerMapY = obj_Map.GetMapPosY(y);
}
prevPlayerMapX = playerMapX;
prevPlayerMapY = playerMapY;
pMapOffsetX = 0;
pMapOffsetY = 0;

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
#region MB Trail

mbTrailColor_Start = c_lime;
mbTrailColor_End = c_green;

mbTrailLength = 18;
mbTrailPosX = array_create(mbTrailLength, noone);
mbTrailPosY = array_create(mbTrailLength, noone);
mbTrailDir = array_create(mbTrailLength, noone);

mbTrailNum = 0;
mbTrailNumRate = 1;

mbTrailSurface = surface_create(global.resWidth,global.resHeight);
mbTrailAlpha = 0;

#endregion
#region AfterImage

drawAfterImage = false;
afterImageNum = 10;
afterImgAlphaMult = 0.625;

afterImageList = ds_list_create();

function AfterImage(_player, _alpha, _num) constructor
{
	player = _player;
	_x = player.x;
	_y = player.y;
	
	sprtOffsetX = player.sprtOffsetX;
	sprtOffsetY = player.sprtOffsetY;
	
	rotation = player.rotation;
	alpha = 1;
	alpha2 = _alpha;
	
	fadeRate = (1 / max(_num,1));
	
	surfW = player.surfW;
	surfH = player.surfH;
	rotScale = player.rotScale;
	aftImgSurf = surface_create(surfW*rotScale,surfH*rotScale);
	
	function Update()
	{
		if(!global.gamePaused)
		{
			alpha = max(alpha - fadeRate, 0);
		}
		if(alpha <= 0)
		{
			Clear();
		}
	}
	
	_delete = false;
	function Clear()
	{
		surface_free(aftImgSurf);
		_delete = true;
	}
	
	initSurf = false;
	function Draw()
	{
		if(surface_exists(aftImgSurf))
		{
			if(!initSurf)
			{
				surface_set_target(aftImgSurf);
				draw_clear_alpha(c_black,0);
				surface_reset_target();
				
				surface_copy(aftImgSurf,0,0,player.playerSurf2);
				initSurf = true;
			}
			var surfCos = dcos(rotation),
				surfSin = dsin(rotation),
				surfX = (surfW/2),
				surfY = (surfH/2);
			var surfFX = _x - surfCos*surfX - surfSin*surfY,
				surfFY = _y - surfCos*surfY + surfSin*surfX;
			
			draw_surface_ext(aftImgSurf,surfFX+sprtOffsetX,surfFY+sprtOffsetY,1/rotScale,1/rotScale,rotation,c_white,clamp(alpha*alpha2,0,1));
		}
	}
}
#endregion

#region Collision (Normal)

function CanPlatformCollide()
{
	return (grounded || !cDown) && (!spiderBall || spiderEdge == Edge.None || spiderEdge == Edge.Bottom) && !fell;
}

function entity_collision(listNum)
{
	if(listNum > 0)
	{
		for(var i = 0; i < listNum; i++)
		{
			if(instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,solids,asset_object))
			{
				var block = blockList[| i];
				var isSolid = true;
				if(block.object_index == obj_MovingTile || object_is_ancestor(block.object_index,obj_MovingTile))
				{
					isSolid = block.isSolid;
					if(block.ignoredEntity == id)
					{
						isSolid = false;
					}
				}
				var sp = (asset_has_any_tag(block.object_index, "ISpeedBlock", asset_object) && isSpeedBoosting && shineStart <= 0 && shineLauncherStart <= 0),
					sc = (asset_has_any_tag(block.object_index, "IScrewBlock", asset_object) && isScrewAttacking);
				if(isSolid && !sp && !sc)
				{
					ds_list_clear(blockList);
					return true;
				}
			}
		}
		ds_list_clear(blockList);
	}
	return false;
}

function ModifyFinalVelX(fVX)
{
	if(entity_place_collide(move2,0,xprevious,yprevious) && fVX == 0 && !grounded && state != State.Grip && state != State.Spark && state != State.BallSpark && state != State.Dodge)
	{
		fVX += 0.5 * move2;
	}
	return fVX;
}
function ModifyFinalVelY(fVY)
{
	return fVY;
}

function ModifySlopeXSteepness_Up()
{
	if(spiderBall)
	{
		return 2;
	}
	if((speedBoost && grounded) || state == State.Grapple || ((state == State.Spark || state == State.BallSpark) && !SparkDir_Hori()))
	{
		return 4;
	}
	return 2;
}
function ModifySlopeXSteepness_Down()
{
	if(spiderBall)
	{
		return 3;
	}
	return 3;
}
function ModifySlopeYSteepness_Up()
{
	if(spiderBall)
	{
		return 2;
	}
	if(fVelY < 0)
	{
		return 2;
	}
	return 1;
}
function ModifySlopeYSteepness_Down()
{
	if(spiderBall)
	{
		return 3;
	}
	return 2;
}

function OnRightCollision(fVX)
{
	
}
function OnLeftCollision(fVX)
{
	
}
function OnXCollision(fVX)
{
	var pBlock = instance_place(position.X+2*sign(fVX),y,obj_PushBlock);
	if(instance_exists(pBlock) && (state == State.Dodge || state == State.Spark || state == State.BallSpark))
	{
		var vx = 0;
		if(velX > 0)
		{
			vx = max(velX,pBlock.velX);
		}
		if(velX < 0)
		{
			vx = min(velX,pBlock.velX);
		}
		pBlock.velX = vx;
	}
	
	if(speedBoost && speedKillCounter < speedKillMax && !speedBoostWJ)
	{
		speedKill = true;
	}
	else
	{
		if(!speedBoost || speedBoostWJ)
		{
			speedBufferCounter = 0;
			speedBuffer = 0;
			speedCounter = 0;
			speedBoost = false;
		}
		
		if(sign(velX) == sign(fVelX))
		{
			velX = 0;
		}
	}
	fVelX = 0;
	move = 0;
	bombJumpX = 0;
	
	var diagSparkSlide = (diagSparkSlideOnWalls && (SparkDir_DiagUp() || SparkDir_DiagDown()) && (cRight - cLeft) != dir);
	if((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineLauncherStart <= 0 && !diagSparkSlide)
	{
		if(boots[Boots.ChainSpark] && !instance_exists(pBlock) && (abs(GetSparkDir()) == 90 || (!entity_place_collide(0,3) && abs(GetSparkDir()) < 90) || (!entity_place_collide(0,-3) && abs(GetSparkDir()) > 90)))
		{
			shineRestart = true;
			audio_stop_sound(snd_ShineSpark_Charge);
			audio_play_sound(snd_ShineSpark_Charge,0,false);
		}
		else if(shineEnd <= 0)
		{
			audio_play_sound(snd_Hurt,0,false);
		}
		shineEnd = shineEndMax;
	}
}

function CanMoveUpSlope_Bottom()
{
	if((state == State.Spark || state == State.BallSpark) && abs(GetSparkDir()) < 90)
	{
		return false;
	}
	return true;
}
function OnSlopeXCollision_Bottom(fVX, yShift)
{
	if(!grounded && velY == 0 && PlayerGrounded())
	{
		grounded = true;
	}
	if(!onPlatform && velY == 0 && PlayerOnPlatform())
	{
		onPlatform = true;
	}
	
	if((state == State.Spark || state == State.BallSpark) && abs(GetSparkDir()) >= 90 && shineStart <= 0 && shineLauncherStart <= 0 && shineEnd <= 0 && move == dir && yShift < 0)
	{
		shineEnd = 0;
		shineDir = 0;
		if(state == State.BallSpark)
		{
			ChangeState(State.Morph,State.Morph,mask_Player_Morph,true);
		}
		else
		{
			ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
		}
		speedBoost = true;
		speedCounter = speedCounterMax;
		speedFXCounter = 1;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
		
		velY = 0;
	}
	else if(yShift < 0 && (state == State.Stand || state == State.Morph) && abs(fVelX) >= maxSpeed[1,liquidState] && !entity_place_collide(fVX+fVelX,yShift))
	{
		var flag = false;
		
		var bbottom = bb_bottom(),
			bright = bb_right(),
			bleft = bb_left();
		if(fVelX > 0 && !entity_collision_line(bright+fVX+fVelX,y+yShift,bright+fVX+fVelX,bbottom+yShift+1) && !lhc_collision_line(bright+fVX+fVelX,y+yShift,bright+fVX+fVelX,bbottom+yShift+1,"IPlatform",true,true))
		{
			flag = true;
		}
		if(fVelX < 0 && !entity_collision_line(bleft+fVX+fVelX,y+yShift,bleft+fVX+fVelX,bbottom+yShift+1) && !lhc_collision_line(bleft+fVX+fVelX,y+yShift,bleft+fVX+fVelX,bbottom+yShift+1,"IPlatform",true,true))
		{
			flag = true;
		}
		
		if(flag && velY >= 0)
		{
			var sAngle = GetEdgeAngle(Edge.Bottom);
			var vx = velX;
			//velX = lengthdir_x(vx,sAngle);
			velY = lengthdir_y(vx,sAngle);
			ledgeFall = false;
			ledgeFall2 = false;
		}
	}
}
function CanMoveDownSlope_Bottom()
{
	return (state != State.Hurt && state != State.DmgBoost && state != State.Spark && state != State.BallSpark && grounded && velY >= 0 && velY <= fGrav && jump <= 0 && bombJump <= 0);
}

function CanMoveUpSlope_Top()
{
	return (((state == State.Spark || state == State.BallSpark) && abs(GetSparkDir()) <= 90) || state == State.Dodge || state == State.Grapple);
}
function OnSlopeXCollision_Top(fVX, yShift)
{
	
}
function CanMoveDownSlope_Top() { return false; }


function OnBottomCollision(fVY)
{
	grounded = true;
	
	if(entityPlatformCheck(0,fVY))
	{
		onPlatform = true;
	}
}
function OnTopCollision(fVY)
{
	
}
function OnYCollision(fVY)
{
	if((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineLauncherStart <= 0 && shineEnd <= 0)
	{
		if(abs(GetSparkDir()) <= 90 && !SparkDir_VertDown() && !entity_place_collide(3*sign(velX),0))
		{
			shineEnd = 0;
			shineDir = 0;
			if(state == State.BallSpark)
			{
				ChangeState(State.Morph,State.Morph,mask_Player_Morph,true);
			}
			else
			{
				ChangeState(State.Stand,State.Stand,mask_Player_Stand,true);
			}
			speedBoost = true;
			speedCounter = speedCounterMax;
			speedFXCounter = 1;
			speedCatchCounter = 6;
			audio_stop_sound(snd_ShineSpark);
		}
		else
		{
			if(shineEnd <= 0)
			{
				audio_play_sound(snd_Hurt,0,false);
			}
			shineEnd = shineEndMax;
		}
	}
	
	var bFlag = true;
	if(velY > 0 && (entity_place_collide(2,0) ^^ entity_place_collide(-2,0)))
	{
		var sideAng = 0;
		if(entity_place_collide(2,0))
		{
			sideAng = GetEdgeAngle(Edge.Right);
		}
		if(entity_place_collide(-2,0))
		{
			sideAng = GetEdgeAngle(Edge.Left);
		}
		var botAng = GetEdgeAngle(Edge.Bottom);
		if(abs(sideAng) > 45 && abs(sideAng) < 90 && abs(botAng) > 0 && abs(botAng) <= 45)
		{
			velX = lengthdir_y(velY,sideAng);
			slopeGrounded = true;
			
			/*if(sign(velX) != 0)
			{
				dir = sign(velX);
			}*/
			
			bFlag = false;
		}
	}
	
	// Ball Bounce
	if(canMorphBounce && !justBounced && bFlag && velY > (2.5 + fGrav) && state == State.Morph && morphFrame <= 0 && shineRampFix <= 0)
	{
		//audio_stop_sound(snd_Land);
		//audio_play_sound(snd_Land,0,false);
		
		var bounceVelY = -abs(velY)*0.25;
		if(abs(bounceVelY) < fGrav*4)
		{
			bounceVelY = 0;
		}
		velY = min(bounceVelY,0);
		
		justFell = false;
		justBounced = true;
	}
	else if(sign(velY) == sign(fVelY))
	{
		velY = 0;
	}
	fVelY = 0;
}

function CanMoveUpSlope_Right()
{
	return CanMoveUpSlope_LeftRight(-1);
}
function OnSlopeYCollision_Right(fVY, xShift)
{
	
}

function CanMoveDownSlope_Right() { return false; }

function CanMoveUpSlope_Left()
{
	return CanMoveUpSlope_LeftRight(1);
}
function OnSlopeYCollision_Left(fVY, xShift)
{
	
}

function CanMoveDownSlope_Left() { return false; }

function CanMoveUpSlope_LeftRight(dir)
{
	if(!grounded && !onPlatform && state != State.Grapple)
	{
		var yspeed = abs(fVelY);
		var ynum = 0;
		while(!entity_place_collide(0,ynum*sign(fVelY)) && ynum <= yspeed)
		{
			ynum++;
		}
		
		var steepFlag = !entity_place_collide(dir,(ynum+1)*sign(fVelY));
		return ((fVelY >= 0 && steepFlag) || (fVelY < 0 && (sign(fVelX) == dir || steepFlag)));
	}
	return false;
}

function DestroyBlock(bx,by)
{
	if(isSpeedBoosting)
	{
		BreakBlock(bx,by,5);
	}
	if(isScrewAttacking)
	{
		BreakBlock(bx,by,6);
	}
}

#endregion
#region Collision (SpiderBall/Crawler)

function Crawler_ModifyFinalVelX(fVX) { return fVX; }
function Crawler_ModifyFinalVelY(fVY)
{
	justFell = false;
	return fVY;
}

/*function Crawler_SlopeCheck(slope)
{
	return colEdge != Edge.None;
}*/

function Crawler_OnRightCollision(fVX)
{
	if(spiderEdge == Edge.Bottom || spiderEdge == Edge.Top || spiderEdge == Edge.None)
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = -velY;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Right;
	}
}
function Crawler_OnLeftCollision(fVX)
{
	if(spiderEdge == Edge.Bottom || spiderEdge == Edge.Top || spiderEdge == Edge.None)
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = velY;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Left;
	}
}
function Crawler_OnXCollision(fVX)
{
	if(state == State.BallSpark && shineStart <= 0 && shineLauncherStart <= 0)
	{
		if(!SparkDir_Hori() && !entity_place_collide(0,2*sign(velY)) && shineEnd <= 0)
		{
			shineDir = 0;
			state = State.Morph;
			speedFXCounter = 1;
			speedCounter = speedCounterMax;
			speedBoost = true;
			speedCatchCounter = 6;
			audio_stop_sound(snd_ShineSpark);
		}
		else
		{
			if(boots[Boots.ChainSpark])
			{
				shineRestart = true;
				audio_stop_sound(snd_ShineSpark_Charge);
				audio_play_sound(snd_ShineSpark_Charge,0,false);
			}
			else if(shineEnd <= 0)
			{
				audio_play_sound(snd_Hurt,0,false);
			}
			shineEnd = shineEndMax;
		}
	}
	velX = 0;
	fVelX = 0;
	move = 0;
	bombJumpX = 0;
}

function Crawler_CanMoveUpSlope_Bottom()
{
	if(state == State.BallSpark)
	{
		if(shineStart <= 0 && shineLauncherStart <= 0 && abs(GetSparkDir()) >= 90)
		{
			return true;
		}
	}
	else if(colEdge == Edge.Bottom || colEdge == Edge.None)
	{
		return true;
	}
	return false;
}
function Crawler_OnSlopeXCollision_Bottom(fVX, yShift)
{
	if(state == State.BallSpark)
	{
		shineEnd = 0;
		shineDir = 0;
		state = State.Morph;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedBoost = true;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
	}
	if(spiderEdge == Edge.None)
	{
		spiderSpeed = velX;
		spiderMove = sign(spiderSpeed);
		spiderEdge = Edge.Bottom;
	}
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Bottom;
	}
}
function Crawler_CanMoveDownSlope_Bottom()
{
	return (colEdge == Edge.Bottom);
}

function Crawler_CanMoveUpSlope_Top()
{
	if(state == State.BallSpark)
	{
		if(shineStart <= 0 && shineLauncherStart <= 0 && abs(GetSparkDir()) <= 90)
		{
			return true;
		}
	}
	else if(colEdge == Edge.Top || colEdge == Edge.None)
	{
		return true;
	}
	return false;
}
function Crawler_OnSlopeXCollision_Top(fVX, yShift)
{
	if(state == State.BallSpark)
	{
		shineEnd = 0;
		shineDir = 0;
		state = State.Morph;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedBoost = true;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
	}
	if(spiderEdge == Edge.None)
	{
		spiderSpeed = -velX;
		spiderMove = sign(spiderSpeed);
		spiderEdge = Edge.Top;
	}
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Top;
	}
}
function Crawler_CanMoveDownSlope_Top()
{
	return (colEdge == Edge.Top);
}

function Crawler_OnBottomCollision(fVY)
{
	if(spiderEdge == Edge.Left || spiderEdge == Edge.Right || spiderEdge == Edge.None)
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = velX;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Bottom;
	}
}
function Crawler_OnTopCollision(fVY)
{
	if(spiderEdge == Edge.Left || spiderEdge == Edge.Right || spiderEdge == Edge.None)
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = -velX;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Top;
	}
}
function Crawler_OnYCollision(fVY)
{
	if(state == State.BallSpark && shineStart <= 0 && shineLauncherStart <= 0)
	{
		if(!SparkDir_VertUp() && !SparkDir_VertDown() && !entity_place_collide(2*sign(velX),0) && shineEnd <= 0)
		{
			shineDir = 0;
			state = State.Morph;
			speedFXCounter = 1;
			speedCounter = speedCounterMax;
			speedBoost = true;
			speedCatchCounter = 6;
			audio_stop_sound(snd_ShineSpark);
		}
		else
		{
			if(shineEnd <= 0)
			{
				audio_play_sound(snd_Hurt,0,false);
			}
			shineEnd = shineEndMax;
		}
	}
	
	velY = 0;
	fVelY = 0;
}

function Crawler_CanMoveUpSlope_Right()
{
	if(state == State.BallSpark)
	{
		if(shineStart <= 0 && shineLauncherStart <= 0 && (GetSparkDir() <= 0 || abs(GetSparkDir()) == 180))
		{
			return true;
		}
	}
	else if(colEdge == Edge.Right)// || colEdge == Edge.None)
	{
		return true;
	}
	return false;
}
function Crawler_OnSlopeYCollision_Right(fVY, xShift)
{
	if(state == State.BallSpark)
	{
		shineEnd = 0;
		shineDir = 0;
		state = State.Morph;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedBoost = true;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
	}
	if(spiderEdge == Edge.None)
	{
		spiderSpeed = -velY;
		spiderMove = sign(spiderSpeed);
		spiderEdge = Edge.Right;
	}
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Right;
	}
}
function Crawler_CanMoveDownSlope_Right()
{
	return (colEdge == Edge.Right);
}

function Crawler_CanMoveUpSlope_Left()
{
	if(state == State.BallSpark)
	{
		if(shineStart <= 0 && shineLauncherStart <= 0 && (GetSparkDir() >= 0 || abs(GetSparkDir()) == 180))
		{
			return true;
		}
	}
	else if(colEdge == Edge.Left)// || colEdge == Edge.None)
	{
		return true;
	}
	return false;
}
function Crawler_OnSlopeYCollision_Left(fVY, xShift)
{
	if(state == State.BallSpark)
	{
		shineEnd = 0;
		shineDir = 0;
		state = State.Morph;
		speedFXCounter = 1;
		speedCounter = speedCounterMax;
		speedBoost = true;
		speedCatchCounter = 6;
		audio_stop_sound(snd_ShineSpark);
	}
	if(spiderEdge == Edge.None)
	{
		spiderSpeed = velY;
		spiderMove = sign(spiderSpeed);
		spiderEdge = Edge.Left;
	}
	if(colEdge == Edge.None)
	{
		colEdge = Edge.Left;
	}
}
function Crawler_CanMoveDownSlope_Left()
{
	return (colEdge == Edge.Left);
}

/*function Crawler_DestroyBlock(bx,by)
{
	DestroyBlock(bx,by);
}*/

#endregion
#region Moving Tile Collision

passthru = 0;
passthruMax = 2;

function MoveStickBottom_X(movingTile)
{
	return (colEdge == Edge.Bottom || spiderBall);
}
function MoveStickBottom_Y(movingTile)
{
	return (colEdge == Edge.Bottom || spiderBall);
}
function MoveStickTop_X(movingTile)
{
	return (colEdge == Edge.Top || spiderBall);
}
function MoveStickTop_Y(movingTile)
{
	return (colEdge == Edge.Top || spiderBall);
}
function MoveStickRight_X(movingTile)
{
	return (colEdge == Edge.Right || spiderBall || MoveStick_CheckPGrip(1, movingTile) || (isPushing && dir == 1));
}
function MoveStickRight_Y(movingTile)
{
	return (colEdge == Edge.Right || spiderBall || MoveStick_CheckPGrip(1, movingTile));
}
function MoveStickLeft_X(movingTile)
{
	return (colEdge == Edge.Left || spiderBall || MoveStick_CheckPGrip(-1, movingTile) || (isPushing && dir == -1));
}
function MoveStickLeft_Y(movingTile)
{
	return (colEdge == Edge.Left || spiderBall || MoveStick_CheckPGrip(-1, movingTile));
}

function MoveStick_CheckPGrip(_dir, movingTile)
{
	if(state == State.Grip && dir == _dir)
	{
		var rcheck = x+6,// - 1,
			lcheck = x;// - 1;
		if(_dir == -1)
		{
			rcheck = x;
			lcheck = x-6;
		}
		if(startClimb)
		{
			var cX = 0, cY = 0;
			for(var i = 0; i < climbIndex; i++)
			{
				cX -= climbX[floor(i)] * _dir;
				cY += climbY[floor(i)];
			}
			return lhc_collision_line(lcheck+cX, y-17+cY, rcheck+cX, y-17+cY, "IMovingSolid", true, true);
		}
		else
		{
			return lhc_collision_line(lcheck, y-17, rcheck, y-17, "IMovingSolid", true, true);
		}
	}
	return false;
}

function MovingSolid_OnRightCollision(fVX)
{
	if(spiderBall )//&& (spiderEdge == Edge.Bottom || spiderEdge == Edge.Top || spiderEdge == Edge.None))
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = -velY;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Right;
	}
}
function MovingSolid_OnLeftCollision(fVX)
{
	if(spiderBall )//&& (spiderEdge == Edge.Bottom || spiderEdge == Edge.Top || spiderEdge == Edge.None))
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = velY;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Left;
	}
}
function MovingSolid_OnXCollision(fVX) {}

function MovingSolid_OnBottomCollision(fVY)
{
	if(spiderBall )//&& (spiderEdge == Edge.Left || spiderEdge == Edge.Right || spiderEdge == Edge.None))
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = velX;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Bottom;
	}
}
function MovingSolid_OnTopCollision(fVY)
{
	if(spiderBall )//&& (spiderEdge == Edge.Left || spiderEdge == Edge.Right || spiderEdge == Edge.None))
	{
		if(spiderEdge == Edge.None)
		{
			spiderSpeed = -velX;
			spiderMove = sign(spiderSpeed);
		}
		spiderEdge = Edge.Top;
	}
}
function MovingSolid_OnYCollision(fVY) {}

#endregion

#region CanChangeState
function CanChangeState(newMask)
{
	if(mask_index != newMask)
	{
		var bright = scr_round(bb_right()),
			bleft = scr_round(bb_left());
		
		var curMask = mask_index,
			curTop = scr_round(bb_top()),
			curBottom = scr_round(bb_bottom());
		
		mask_index = newMask;
		var newTop = scr_round(bb_top()),
			newBottom = scr_round(bb_bottom());
		
		var checkYTop = 0,
			checkYBottom = 0;
		for(var i = 0; i < newBottom-curBottom; i++)
		{
			if((entity_place_collide(0,checkYBottom) || (onPlatform && lhc_place_meeting(position.X,position.Y+checkYBottom,"IPlatform"))) && !entity_collision_line(bleft,newTop+checkYBottom,bright,newTop+checkYBottom))
			{
				checkYBottom--;
			}
		}
		for(var i = 0; i < curTop-newTop; i++)
		{
			if(entity_place_collide(0,checkYTop) && !entity_collision_line(bleft,newBottom+checkYTop,bright,newBottom+checkYTop))
			{
				checkYTop++;
			}
		}
		
		var flag = false;
		if(!entity_place_collide(0,checkYBottom))
		{
			flag = true;
		}
		if(!entity_place_collide(0,checkYTop) && (!onPlatform || !lhc_place_meeting(position.X,position.Y+checkYTop,"IPlatform")))
		{
			flag = true;
		}
		
		mask_index = curMask;
		
		return flag;
	}
	
	return true;
}
#endregion
#region ChangeState
function ChangeState(newState,newStateFrame,newMask,isGrounded,stallCam = true)
{
	stateFrame = newStateFrame;
	
	if(mask_index != newMask)
	{
		var bright = scr_round(bb_right()),
			bleft = scr_round(bb_left());
		
		var curMask = mask_index,
			curTop = scr_round(bb_top()),
			curBottom = scr_round(bb_bottom());
		
		mask_index = newMask;
		var newTop = scr_round(bb_top()),
			newBottom = scr_round(bb_bottom());
		
		var checkYTop = 0,
			checkYBottom = 0;
		
		for(var i = 0; i < abs(newBottom-curBottom); i++)
		{
			if(newBottom-curBottom > 0)
			{
				if((entity_place_collide(0,checkYBottom) || (onPlatform && lhc_place_meeting(position.X,position.Y+checkYBottom,"IPlatform"))) && !entity_collision_line(bleft,newTop+checkYBottom,bright,newTop+checkYBottom))
				{
					checkYBottom--;
				}
			}
			else if(isGrounded)
			{
				if(!entity_place_collide(0,checkYBottom+1))
				{
					checkYBottom++;
				}
			}
		}
		
		for(var i = 0; i < curTop-newTop; i++)
		{
			if(entity_place_collide(0,checkYTop) && !entity_collision_line(bleft,newBottom+checkYTop,bright,newBottom+checkYTop))
			{
				checkYTop++;
			}
		}
		
		if(!entity_place_collide(0,checkYBottom))
		{
			position.Y += checkYBottom;
		}
		if(!entity_place_collide(0,checkYTop))
		{
			position.Y += checkYTop;
		}
		var oldY = y;
		y = scr_round(position.Y);
		
		if(stallCam && y != oldY)
		{
			stallCamera = true;
		}
	}
	state = newState;
}
#endregion

#region Shoot
function Shoot(ShotIndex, Damage, Speed, CoolDown, ShotAmount, SoundIndex, IsWave = false, WaveStyleOffset = 0)
{
	var spawnX = scr_round(shootPosX - 2*sign(lengthdir_x(2,shootDir))),
		spawnY = scr_round(shootPosY - 2*sign(lengthdir_y(2,shootDir)));

	if(SoundIndex != noone)
	{
		if(audio_is_playing(global.prevShotSndIndex))
		{
			var gain = 0;
			if(asset_get_index(audio_get_name(global.prevShotSndIndex)) != SoundIndex)
			{
				gain = audio_sound_get_gain(global.prevShotSndIndex);
			}
			audio_sound_gain(global.prevShotSndIndex,gain,25);
		}
		var snd = audio_play_sound(SoundIndex,1,false);
		audio_sound_gain(snd,1,0);
		global.prevShotSndIndex = snd;
	}

	if(ShotIndex != noone)
	{
		var shot = noone;
		for(var i = 0; i < ShotAmount; i++)
		{
			shot = instance_create_layer(spawnX,spawnY,layer_get_id("Projectiles"),ShotIndex);
			shot.damage = Damage;
			shot.velX = lengthdir_x(Speed,shootDir);
			shot.velY = lengthdir_y(Speed,shootDir);
			shot.direction = shootDir;
			shot.waveStyle = i + WaveStyleOffset;
			shot.dir = dir2;
			shot.waveDir = waveDir;
			shot.creator = id;
		}
		if(instance_exists(shot))
		{
			shotDelayTime = CoolDown;
			if(shot.particleType >= 0 && !shot.isGrapple)
			{
				var partSys = obj_Particles.partSystemB;
				if(IsWave)
				{
					partSys = obj_Particles.partSystemA;
				}
		
				part_particles_create(partSys,shootPosX,shootPosY,obj_Particles.bTrails[shot.particleType],7+(5*(statCharge >= maxCharge)));
		        part_particles_create(partSys,shootPosX,shootPosY,obj_Particles.mFlare[shot.particleType],1);
			}
			waveDir *= -1;
			return shot;
		}
	}
	return noone;
}
#endregion

#region PlayerGrounded
function PlayerGrounded(ydiff = 1)
{
	if(spiderBall && spiderEdge != Edge.None && jump <= 0)
	{
		return true;
	}
	
	var downSlopeFlag = (abs(GetEdgeAngle(Edge.Bottom,0,0)) >= 60);
	var bottomCollision = false;
	var colB = entity_collision_line(bb_left(),bb_bottom()+ydiff,bb_right(),bb_bottom()+ydiff);
	if(entity_place_collide(0,ydiff) && (!entity_place_collide(0,0) || colB))
	{
		bottomCollision = true;
	}
	
	if(velY >= 0 && velY <= fGrav && jump <= 0)
	{
		return (bottomCollision && (!downSlopeFlag || speedBoost));
	}
	return false;
}
#endregion
#region PlayerOnPlatform
function PlayerOnPlatform(ydiff = 1)
{
	return (entityPlatformCheck(0,ydiff) && fVelY >= 0 && state != State.Spark && state != State.BallSpark);
}
#endregion

#region SpiderEnable
function SpiderEnable(flag)
{
	if(spiderBall != flag)
	{
		spiderBall = flag;
		audio_play_sound(snd_SpiderStart,0,false);
		if(flag)
		{
			if(!audio_is_playing(snd_SpiderLoop))
			{
				audio_play_sound(snd_SpiderLoop,0,true);
			}
			if(grounded)
			{
				spiderEdge = Edge.Bottom;
				spiderSpeed = velX;
			}
		}
		else
		{
			audio_stop_sound(snd_SpiderLoop);
			if(spiderEdge == Edge.Top && spiderSpeed != 0)
			{
				dir *= -1;
				dirFrame = 4*dir;
			}
			spiderEdge = Edge.None;
		}
	}
}
#endregion
#region SpiderActive
function SpiderActive()
{
	if(argument_count > 0)
	{
		return (spiderBall && spiderEdge == argument[0]);
	}
	return (spiderBall && spiderEdge != Edge.None);
}
#endregion

#region EntityLiquid_Large

function EntityLiquid_Large(_velX, _velY)
{
	EntityLiquid(2,_velX,_velY, true, false, false);
	
	canSplash++;
	if(canSplash > 10)
	{
		canSplash = 0;
	}
	
	if(liquid && !liquidTop && (canSplash%4) == 0)
	{
		var _skidSnd = false,
			_size = 0;
		if((((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineLauncherStart <= 0 && shineEnd <= 0) || speedBoost || state == State.Dodge) && _velX != 0)
		{
			//if((canSplash%4) == 0)
			//{
				_skidSnd = true;
			//}
			_size = 1;
		}
		var _velX2 = _velX;
		if(liquid.liquidType == LiquidType.Acid)
		{
			_velX2 += choose(1,-1) * random_range(0.1,1);
			
			repeat(3)
			{
				var splX = irandom_range(bb_left()+1,bb_right()-1),
					splY = liquid.bb_top();
				var spl = instance_create_layer(splX - 1 + irandom(2), splY, "Liquids_fg", obj_SplashFXFade);
				spl.liquid = liquid;
				spl.image_index = irandom(2);
				spl.image_alpha = 1;
				spl.velX = choose(-0.5,-0.3,-0.15,0.15,0.3,0.5) * random_range(1.5,2.5);
				spl.velY = -0.5 * random_range(1.5,2.5);
				spl.animSpeed = 0.1;
			}
		}
		liquid.CreateSplash_Extra(id,_size,_velX2,_velY,true,_skidSnd);
	}
	
	if (liquid && (enteredLiquid > 0 || speedBoost) && choose(1,1,1,0) == 1)
	{
		var bub = liquid.CreateBubble(random_range(bb_left()-3,bb_right()+3),random_range(bb_top()-3,bb_bottom()+3),0,0);
		bub.spriteIndex = sprt_WaterBubble;

		if (_velY > 0)
		{
			bub.velY += _velY/4;
		}

		if (enteredLiquid < 60)
		{
			bub.alpha *= (enteredLiquid/60);
			bub.alphaMult *= (enteredLiquid/60);
		}
	}
	
	if (leftLiquid && choose(1,1,1,0,0) == 1)
	{
		var drop = instance_create_depth(x-8+random(16),y+4,depth-1,obj_WaterDrop);
		drop.liquidType = leftLiquidType;
		if (state == State.Somersault)
		{
			drop.velX = -random(7) + 3.5;
			drop.velY = -random(5) + 1;
		}
		with (drop)
		{
			if(position_meeting(x,y,obj_Liquid))
			{
				kill = true;
				instance_destroy();
			}
		}
	}
	if (leftLiquidTop && choose(1,1,1,0,0) == 1)
	{
		var drop = instance_create_depth(x-8+random(16),bb_bottom()+random(bb_top()-y+4),depth-1,obj_WaterDrop);
		drop.liquidType = leftLiquidTopType;
		if (state == State.Somersault)
		{
			drop.velX = -random(6) + 3;
			drop.velY = -random(6) + 1;
		}
		with (drop)
		{
			if(position_meeting(x,y,obj_Liquid))
			{
				kill = true;
				instance_destroy();
			}
		}
	}
	
	if(liquid && liquid.liquidType != LiquidType.Lava)
	{
		breathTimer --;
		if (breathTimer < 16)
		{
			if (breathTimer < 0)
			{
			    breathTimer = choose(110,150,160);
			}
			else if (breathTimer == 15 && liquidTop)
			{
			    //audio_play_sound(choose(snd_Breath_0,snd_Breath_1,snd_Breath_2),0,false);
			    audio_play_sound(choose(snd_Bubble_0,snd_Bubble_1),0,false);
			}
     
			if (liquidTop && (breathTimer mod 8 == 0))
			{
				var bub = liquid.CreateBubble(x + 4*dir, bb_top() + 7, dir/2 -0.15 + random(0.3), 0.2+random(0.1));
				bub.spriteIndex = sprt_WaterBubbleSmall;
				bub.breathed = 0.15;
				bub.velX += _velX/2;
				if (state == State.Grip)
			    {
			        bub.posX -= (dir * 6);
			    }
			}
		}

		if(state == State.Somersault && misc[Misc.ScrewAttack] && suit[Suit.Gravity])
		{
			repeat(3)
			{
				var bub = liquid.CreateBubble(x + random_range(16,-16), y+2 + random_range(16,-16), 0, 0);
				bub.kill = true;
				bub.canSpread = false;
			}
		}
		else if(((state == State.Spark || state == State.BallSpark) && shineStart <= 0 && shineLauncherStart <= 0 && shineEnd <= 0) || speedBoost || state == State.Dodge)
		{
			repeat(3)
			{
				var bub = liquid.CreateBubble(random_range(bb_left()-3,bb_right()+3),random_range(bb_top()-3,bb_bottom()+3),0,0);
				bub.kill = true;
				bub.canSpread = false;
			}
		}
		else if(liquid.liquidType == LiquidType.Acid)
		{
			var bub = liquid.CreateBubble(random_range(bb_left()-3,bb_right()+3),random_range(bb_top()-3,bb_bottom()+3),0,0);
			bub.kill = true;
			bub.canSpread = false;
		}
		
		if(stateFrame == State.Brake && brakeFrame >= 9)
		{
			var bub = liquid.CreateBubble(x-random(12)*dir,bb_bottom()+4-random(8),0,0);
			bub.kill = true;
			bub.canSpread = false;
		}
	}
	
	stepSplash = max(stepSplash-1,0);
}

#endregion

#region Set Beams
function Set_Beams()
{
	beamShot = obj_PowerBeamShot;
	beamCharge = obj_PowerBeamChargeShot;
	beamChargeAnim = sprt_PowerBeamChargeAnim;
	beamSound = snd_PowerBeam_Shot;
	beamChargeSound = snd_PowerBeam_ChargeShot;
	beamAmt = 1;
	beamChargeAmt = 1;
	beamIconIndex = 0;
	beamFlare = sprt_PowerBeamChargeFlare;
	
	beamIsWave = false;
	beamWaveStyleOffset = 1;
	
	var noBeamsActive = ((beam[Beam.Ice]+beam[Beam.Wave]+beam[Beam.Spazer]+beam[Beam.Plasma]) <= 0);
	
	var beamSelected = array_create(5);
	for(var i = 1; i < 5; i++)
	{
		beamSelected[i] = (beam[i] || (noBeamsActive && itemHighlighted[0] == i));
	}
	
	if(beamSelected[Beam.Wave])
	{
		beamIsWave = true;
	}
	if(beamSelected[Beam.Spazer])
	{
		beamWaveStyleOffset = 0;
	}
	
	#region Shot Type & FX
	
	if(beamSelected[Beam.Ice]) // Ice
	{
		beamShot = obj_IceBeamShot;
		beamCharge = obj_IceBeamChargeShot;
		beamChargeAnim = sprt_IceBeamChargeAnim;
		beamSound = snd_IceBeam_Shot;
		beamChargeSound = snd_IceBeam_ChargeShot;
		beamIconIndex = 1;
		beamFlare = sprt_IceBeamChargeFlare;
		
		if(beam[Beam.Plasma]) // Ice Plasma
		{
			beamShot = obj_IcePlasmaBeamShot;
			beamCharge = obj_IcePlasmaBeamChargeShot;
			beamSound = snd_IceComboShot;
			beamIconIndex = 9;
			
			if(beam[Beam.Wave]) // Ice Wave Plasma
			{
				beamShot = obj_IceWavePlasmaBeamShot;
				beamCharge = obj_IceWavePlasmaBeamChargeShot;
				beamIconIndex = 11;
				
				if(beam[Beam.Spazer]) // Ice Wave Spazer Plasma
				{
					beamShot = obj_IceWaveSpazerPlasmaBeamShot;
					beamCharge = obj_IceWaveSpazerPlasmaBeamChargeShot;
					beamIconIndex = 15;
				}
			}
			else if(beam[Beam.Spazer]) // Ice Spazer Plasma
			{
				beamShot = obj_IceSpazerPlasmaBeamShot;
				beamCharge = obj_IceSpazerPlasmaBeamChargeShot;
				beamIconIndex = 13;
			}
		}
		else if(beam[Beam.Spazer]) // Ice Spazer
		{
			beamShot = obj_IceSpazerBeamShot;
			beamCharge = obj_IceSpazerBeamChargeShot;
			beamSound = snd_IceComboShot;
			beamIconIndex = 5;
			
			if(beam[Beam.Wave]) // Ice Wave Spazer
			{
				beamShot = obj_IceWaveSpazerBeamShot;
				beamCharge = obj_IceWaveSpazerBeamChargeShot;
				beamIconIndex = 7;
			}
		}
		else if(beam[Beam.Wave]) // Ice Wave
		{
			beamShot = obj_IceWaveBeamShot;
			beamCharge = obj_IceWaveBeamChargeShot;
			beamIconIndex = 3;
		}
	}
	else if(beamSelected[Beam.Plasma]) // Plasma
	{
		beamShot = obj_PlasmaBeamShot;
		beamCharge = obj_PlasmaBeamChargeShot;
		beamChargeAnim = sprt_PlasmaBeamChargeAnim;
		beamSound = snd_PlasmaBeam_Shot;
		beamChargeSound = snd_PlasmaBeam_ChargeShot;
		beamIconIndex = 8;
		beamFlare = sprt_PlasmaBeamChargeFlare;
		
		if(beam[Beam.Wave]) // Wave Plasma
		{
			beamShot = obj_WavePlasmaBeamShot;
			beamCharge = obj_WavePlasmaBeamChargeShot;
			beamIconIndex = 10;
			
			if(beam[Beam.Spazer]) // Wave Spazer Plasma
			{
				beamShot = obj_WaveSpazerPlasmaBeamShot;
				beamCharge = obj_WaveSpazerPlasmaBeamChargeShot;
				beamIconIndex = 14;
			}
		}
		else if(beam[Beam.Spazer]) // Spazer Plasma
		{
			beamShot = obj_SpazerPlasmaBeamShot;
			beamCharge = obj_SpazerPlasmaBeamChargeShot;
			beamIconIndex = 12;
		}
	}
	else if(beamSelected[Beam.Wave]) // Wave
	{
		beamShot = obj_WaveBeamShot;
		beamCharge = obj_WaveBeamChargeShot;
		beamChargeAnim = sprt_WaveBeamChargeAnim;
		beamSound = snd_WaveBeam_Shot;
		beamChargeSound = snd_WaveBeam_ChargeShot;
		beamIconIndex = 2;
		beamFlare = sprt_WaveBeamChargeFlare;
		
		if(beam[Beam.Spazer]) // Wave Spazer
		{
			beamShot = obj_WaveSpazerBeamShot;
			beamCharge = obj_WaveSpazerBeamChargeShot;
			beamSound = snd_Spazer_Shot;
			beamChargeSound = snd_Spazer_ChargeShot;
			beamIconIndex = 6;
		}
	}
	else if(beamSelected[Beam.Spazer]) // Spazer
	{
		beamShot = obj_SpazerBeamShot;
		beamCharge = obj_SpazerBeamChargeShot;
		beamChargeAnim = sprt_SpazerChargeAnim;
		beamSound = snd_Spazer_Shot;
		beamChargeSound = snd_Spazer_ChargeShot;
		beamIconIndex = 4;
		beamFlare = sprt_SpazerChargeFlare;
	}
	
	#endregion
	#region Shot Amount
	
	if(beamSelected[Beam.Spazer])
	{
		beamAmt = 3;
		beamChargeAmt = 3;
	}
	else if(beamSelected[Beam.Wave])
	{
		beamChargeAmt = 2;
		if(beam[Beam.Plasma])
		{
			//beamAmt = 2; // <- uncomment to make wave plasma shoot dual shots
		}
	}
	
	#endregion
	#region Damage & Firerate
	
	beamDmg = 20;
	beamDelay = 8;
	beamChargeDelay = 20;
	var iceDelay = 4,
		waveDelay = 0,//2,
		spazerDelay = 0,//-2,
		plasmaDelay = 3;
	if(beamSelected[Beam.Ice])
	{
		beamDmg = 30;
		beamDelay += iceDelay;
		beamChargeDelay += iceDelay;
	}
	if(beamSelected[Beam.Wave])
	{
		beamDmg = 50;
		beamDelay += waveDelay;
		beamChargeDelay += waveDelay;
	}
	if(beamSelected[Beam.Spazer])
	{
		beamDmg = 40;
		beamDelay += spazerDelay;
		beamChargeDelay += spazerDelay;
	}
	if(beamSelected[Beam.Plasma])
	{
		beamDmg = 150;
		beamDelay += plasmaDelay;
		beamChargeDelay += plasmaDelay;
	}
	
	// ice, wave, spazer
	if(beam[Beam.Ice] && beam[Beam.Wave])
	{
		beamDmg = 60;
	}
	if(beam[Beam.Ice] && beam[Beam.Spazer])
	{
		beamDmg = 60;
	}
	if(beam[Beam.Wave] && beam[Beam.Spazer])
	{
		beamDmg = 70;
	}
	if(beam[Beam.Ice] && beam[Beam.Wave] && beam[Beam.Spazer])
	{
		beamDmg = 100;
	}
	
	// ice, wave, plasma
	if(beam[Beam.Ice] && beam[Beam.Plasma])
	{
		beamDmg = 200;
	}
	if(beam[Beam.Wave] && beam[Beam.Plasma])
	{
		beamDmg = 250;
	}
	if(beam[Beam.Ice] && beam[Beam.Wave] && beam[Beam.Plasma])
	{
		beamDmg = 300;
	}
	
	// ice, wave, spazer+plasma
	if(beam[Beam.Ice] && beam[Beam.Spazer] && beam[Beam.Plasma])
	{
		beamDmg = 300;
	}
	if(beam[Beam.Wave] && beam[Beam.Spazer] && beam[Beam.Plasma])
	{
		beamDmg = 350;
	}
	if(beam[Beam.Ice] && beam[Beam.Wave] && beam[Beam.Spazer] && beam[Beam.Plasma])
	{
		beamDmg = 400;
	}
	
	#endregion
}
#endregion

#region StrikePlayer
function StrikePlayer(damage,knockTime,knockSpeedX,knockSpeedY,iframes,ignoreImmunity = false)
{
	//var dmg = scr_round(damage * (1-(0.5*suit[0])) * (1-(0.5*suit[1]))),
	var dmg = scr_round(damage * damageReduct);
    
	if(!global.gamePaused && !godmode && invFrames <= 0 && (!immune || ignoreImmunity))
	{
		energy = max(energy - dmg,0);
		if(energy <= 0)
		{
			state = State.Death;
		}
		else
		{
			if(knockTime > 0 && dir != 0 && state != State.Hurt && state != State.Grapple)
			{
				lastState = state;
				state = State.Hurt;
				hurtTime = knockTime;
				hurtSpeedX = knockSpeedX;
				hurtSpeedY = knockSpeedY;
				jump = 0;
				jumping = false;
			}
			
			if(!audio_is_playing(snd_Hurt))
			{
				audio_play_sound(snd_Hurt,0,false);
			}
			dmgFlash = 2;
			
			if(iframes > 0)
			{
				invFrames = iframes;
			}
		}
	}
}
#endregion
#region ConstantDamage
function ConstantDamage(damage,delay)
{
	if(!godmode)
	{
		if(constantDamageDelay <= 0)
		{
			if(damage >= energy)
			{
				state = State.Death;
			}
			energy = max(energy - damage, 0);
			constantDamageDelay = delay;
		}
		constantDamageDelay = max(constantDamageDelay - 1,0);
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
#region SetArmPosGrip (old)
/*function SetArmPosGrip()
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
}*/
#endregion
#region SetArmPosGrip
function SetArmPosGrip()
{
	if(gripFrame < 3)
	{
		switch scr_round(gripFrame)
		{
			case 0:
			{
				ArmPos(-1*dir,9);
				break;
			}
			case 1:
			{
				ArmPos(-5*dir,12);
				break;
			}
			case 2:
			{
				ArmPos(-6*dir,12);
				break;
			}
		}
	}
	else
	{
		switch scr_round(gripAimFrame)
		{
		    default:
		    {
		        ArmPos(-11, 17);
		        if(dir == -1)
		        {
		            ArmPos(10, 18);
		        }
		        armOffsetY -= (recoilCounter > 0);
		        break;
		    }
		    case 1:
		    {
		        ArmPos(-21, 14);
		        if(dir == -1)
		        {
		            ArmPos(18, 15);
		        }
		        break;
		    }
		    case 2:
		    {
		        ArmPos(-27, 9);
		        if(dir == -1)
		        {
		            ArmPos(25,10);
		        }
		        armOffsetX += (recoilCounter > 0)*dir;
		        armOffsetY -= (recoilCounter > 0);
		        break;
		    }
		    case 3:
		    {
		        ArmPos(-30, 1);
		        if(dir == -1)
		        {
		            ArmPos(29, 1);
		        }
		        break;
		    }
		    case 4:
		    {
		        ArmPos(-30,-6);
		        if(dir == -1)
		        {
		            ArmPos(32,-8);
		        }
		        armOffsetX += (recoilCounter > 0)*dir;
		        break;
		    }
		    case 5:
		    {
		        ArmPos(-30, -16);
		        if(dir == -1)
		        {
		            ArmPos(30, -18);
		        }
		        break;
		    }
		    case 6:
		    {
		        ArmPos(-27, -21);
		        if(dir == -1)
		        {
		            ArmPos(26, -21);
		        }
		        armOffsetX += (recoilCounter > 0)*dir;
		        armOffsetY += (recoilCounter > 0);
		        break;
		    }
		    case 7:
		    {
		        ArmPos(-23,-28);
		        if(dir == -1)
		        {
		            ArmPos(23,-28);
		        }
		        break;
		    }
		    case 8:
		    {
		        ArmPos(-12, -31);
		        if(dir == -1)
		        {
		            ArmPos(12, -31);
		        }
		        armOffsetY += (recoilCounter > 0);
		        break;
		    }
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
	var rotPos = -((360/(sFrameMax-2)) * max(frame6-2,0) + degNum);
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

#region Palette

chargeReleaseFlash = 0;

shaderFlash = 0;
shaderFlashMax = 4;

palSurface = surface_create(sprite_get_width(pal_Player_PowerSuit),sprite_get_height(pal_Player_PowerSuit));

enum PlayerPal
{
	Default = 0,
	Heat = 1,
	Speed = 2,
	Spark = 3,
	Screw = 4,
	Morph = 5
}
enum PlayerPal2
{
	White = 0,
	Black = 1,
	Beam_Power = 2,
	Beam_Ice = 3,
	Beam_Wave = 4,
	Beam_Spazer = 5,
	Beam_Plasma = 6,
	HyperStart = 7,
	HyperEnd = 17
}

darkRoomVisorFlash = 0;
darkRoomVisorNum = 1;

xRayVisorFlash = 0;
xRayVisorNum = 1;

morphPal = 0;
ballGlowIndex = 0;

heatPal = 0;
heatPalNum = 1;
heatDmgPal = 0;
heatDmgPalCounter = 0;

screwPal = 0;
screwPalNum = 1;

hyperFired = 0;
hyperPal = 0;

cFlashPalSurf = surface_create(sprite_get_width(pal_Player_CrystalFlash),sprite_get_height(pal_Player_CrystalFlash));
cFlashPal = 0;
cFlashPal2 = 0;
cFlashPalDiff = 0;
cFlashPalNum = 1;
cBubblePal = 0;

fastWJFlash = 0;

function PaletteSurface()
{
	if(surface_exists(palSurface))
	{
		surface_set_target(palSurface);
		
		var liquidMovement = (liquidState > 0);
		
		var palSprite = pal_Player_PowerSuit,
			palSprite2 = pal_Player_MiscSuit;
		if(suit[Suit.Varia])
		{
			palSprite = pal_Player_VariaSuit;
		}
		if(suit[Suit.Gravity])
		{
			palSprite = pal_Player_GravitySuit;
		}
		DrawPalSprite(palSprite,PlayerPal.Default,1);
		
		if(shineFXCounter > 0 || statCharge >= maxCharge || (state == State.Dodge && statCharge < maxCharge) || (shineCharge > 0 && state != State.Spark) || boostBallCharge > 0)
		{
			shaderFlash++;
		}
		else
		{
			shaderFlash = 0;
		}
		
		gpu_set_colorwriteenable(1,1,1,0);
		
		#region -- Heated room glow --
		if(global.rmHeated)
		{
			heatPal += 0.015 * heatPalNum;
			if(heatPal > 1)
			{
				heatPalNum = -1;
			}
			else if(heatPal < 0)
			{
				heatPalNum = 1;
			}
			DrawPalSprite(palSprite,PlayerPal.Heat,heatPal);
		}
		else
		{
			heatPal = 0;
			heatPalNum = 1;
		}
		#endregion
		#region -- Visor flashing --
		/*if(false) // if(room is dark and activates visor flashing)
		{
			if(darkRoomVisorFlash >= 1)
            {
                darkRoomVisorNum = -1;
            }
            if(darkRoomVisorFlash <= 0)
            {
                darkRoomVisorNum = 1;
            }
            darkRoomVisorFlash = clamp(darkRoomVisorFlash + 0.125*darkRoomVisorNum,0,1);
			
			DrawPalSprite(pal_Visor_Flash,0,1);
			DrawPalSprite(pal_Visor_Flash,1,darkRoomVisorFlash);
		}*/
		if(instance_exists(XRay))
		{
			if(xRayVisorFlash >= 1)
            {
                xRayVisorNum = -1;
            }
            if(xRayVisorFlash <= 0)
            {
                xRayVisorNum = 1;
            }
            xRayVisorFlash = clamp(xRayVisorFlash + 0.125*xRayVisorNum,0,1);
			
			DrawPalSprite(pal_Player_Visor_XRay,0,XRay.alpha);
			DrawPalSprite(pal_Player_Visor_XRay,1,XRay.alpha*xRayVisorFlash);
		}
		#endregion
		#region -- Intro fanfare / saving --
		if(introAnimState != -1)
		{
			if(introAnimCounter < 245)
			{
				var introPal = lerp(1,0.5, clamp((introAnimCounter-200)/35,0,1));
				var alph = introPal * power(abs(scr_wrap(introAnimCounter,-4,4) / 4), 2);
				DrawPalSprite(palSprite,PlayerPal.Speed,alph);
			}
		}
		if(saveAnimCounter > 0)
		{
			var alph = power(abs(scr_wrap(saveAnimCounter,-4,4) / 4), 2);
			DrawPalSprite(palSprite,PlayerPal.Speed,alph);
		}
		#endregion
		#region -- Speed Booster & Shine Spark --
		if(speedFXCounter > 0)
		{
			DrawPalSprite(palSprite,PlayerPal.Speed,speedFXCounter);
		}
		
		if(shineFXCounter > 0)
		{
			var alph = shineFXCounter*0.875;
			if(shaderFlash > (shaderFlashMax/2) || shineFXCounter < 1)
			{
				alph = shineFXCounter*0.625;
			}
			DrawPalSprite(palSprite,PlayerPal.Spark,alph);
		}
		#endregion
		#region -- Boost Ball --
		if(boostBallFX > 0)
		{
			var alph = boostBallFX*0.875;
			if(shaderFlash > (shaderFlashMax/2))
			{
				alph = boostBallFX*0.625;
			}
			DrawPalSprite(palSprite,PlayerPal.Spark,alph);
		}
		#endregion
		#region -- Screw Attack --
		if(isScrewAttacking && frame[6] >= 1 && spaceJump <= 6 && wjFrame <= 0)
		{
			screwPal = clamp(screwPal + 0.25*screwPalNum, 0, 1);
			if(screwPal >= 1)
			{
				screwPalNum = -1;
			}
			if(screwPal <= 0.25)
			{
				screwPalNum = 1;
			}
			DrawPalSprite(palSprite,PlayerPal.Screw,screwPal);
		}
		else
		{
			screwPal = 0;
			screwPalNum = 1;
		}
		#endregion
		#region -- Beam charge, Shine Spark charge, and Accel dash flash --
		var beamPalInd = PlayerPal2.Beam_Power;
		if(beamChargeAnim == sprt_IceBeamChargeAnim)
		{
			beamPalInd = PlayerPal2.Beam_Ice;
		}
		else if(beamChargeAnim == sprt_PlasmaBeamChargeAnim)
		{
			beamPalInd = PlayerPal2.Beam_Plasma;
		}
		else if(beamChargeAnim == sprt_WaveBeamChargeAnim)
		{
			beamPalInd = PlayerPal2.Beam_Wave;
		}
		else if(beamChargeAnim == sprt_SpazerChargeAnim)
		{
			beamPalInd = PlayerPal2.Beam_Spazer;
		}
		
		if(statCharge >= maxCharge || (state == State.Dodge && statCharge < maxCharge) || (shineCharge > 0 && state != State.Spark))
		{
			if(shaderFlash > (shaderFlashMax/2))
			{
				if(statCharge >= maxCharge)
				{
					//if(state == State.Somersault || state == State.Dodge)
					if(isChargeSomersaulting)
					{
						DrawPalSprite(palSprite2,beamPalInd,1);
					}
					else
					{
						DrawPalSprite(palSprite2,PlayerPal2.White,0.125);
					}
				}
				else if(state == State.Dodge)
				{
					DrawPalSprite(palSprite,PlayerPal.Screw,0.375);
				}
				else if(shineCharge > 0)
				{
					DrawPalSprite(palSprite,PlayerPal.Spark,0.35);
				}
			}
			//else if((state == State.Somersault || state == State.Dodge) && statCharge >= maxCharge)
			else if(isChargeSomersaulting)
			{
				DrawPalSprite(palSprite2,beamPalInd,0.375);
			}
		}
		if(fastWJFlash > 0)
		{
			DrawPalSprite(palSprite2,PlayerPal2.White,fastWJFlash);
			if(!global.gamePaused)
			{
				fastWJFlash = max(fastWJFlash-0.2,0);
			}
		}
		#endregion
		#region -- Beam charge shot flash & Hyper beam --
		if(hyperFired > 0)
		{
			hyperPal = min(hyperPal+0.25,1);
		}
		else
		{
			hyperPal = max(hyperPal-0.1,0);
		}
		if(hyperPal > 0)
		{
			var hyperInd = PlayerPal2.HyperStart + obj_Display.hyperRainbowCycle;
			DrawPalSprite(palSprite2,scr_wrap(scr_floor(hyperInd), PlayerPal2.HyperStart, PlayerPal2.HyperEnd), hyperPal);
			DrawPalSprite(palSprite2,scr_wrap(scr_ceil(hyperInd), PlayerPal2.HyperStart, PlayerPal2.HyperEnd), hyperPal*frac(hyperInd));
		}
		else if(chargeReleaseFlash > 0)
		{
			DrawPalSprite(palSprite2,beamPalInd,1);
		}
		#endregion
		#region -- Morphing into ball --
		if(morphFrame > 0)
		{
			morphPal = min(morphPal + 0.25/(1+liquidMovement),1);
		}
		else
		{
			morphPal = max(morphPal - 0.15/(1+liquidMovement),0);
		}
		if(morphPal > 0)
		{
			DrawPalSprite(palSprite,PlayerPal.Morph,morphPal);
		}
		#endregion
		#region -- Damage flicker & Heated room damage flash --
		if(heatDmgPalCounter > 30)
		{
			heatDmgPal = min(heatDmgPal + 0.25, 1);
		}
		else
		{
			heatDmgPal = max(heatDmgPal - 0.25, 0);
		}
		if(heatDmgPalCounter > 34)
		{
			heatDmgPalCounter = 0;
		}
		if(heatDmgPal > 0)
		{
			DrawPalSprite(palSprite2,PlayerPal2.White,heatDmgPal * 0.8);
		}
		
		if(dmgFlash > 0)
		{
			DrawPalSprite(palSprite2,PlayerPal2.White,0.8);
		}
		else if(invFrames > 0 && (invFrames&1) && !global.roomTrans)
		{
			DrawPalSprite(palSprite2,PlayerPal2.Black,1);
		}
		#endregion
		#region -- Crystal Flash --
		if(cFlashPal > 0)
		{
			DrawPalSprite(palSprite2,PlayerPal2.White,cFlashPal);
		}
		#endregion
		
		gpu_set_colorwriteenable(1,1,1,1);
		
		if(shaderFlash >= shaderFlashMax)
		{
			shaderFlash = 0;
		}
		
		surface_reset_target();
	}
	else
	{
		palSurface = surface_create(sprite_get_width(pal_Player_PowerSuit),sprite_get_height(pal_Player_PowerSuit));
	}
	
	if(surface_exists(cFlashPalSurf))
	{
		surface_set_target(cFlashPalSurf);
		
		DrawPalSprite(pal_Player_CrystalFlash,0,1);
		
		gpu_set_colorwriteenable(1,1,1,0);
		
		if(cFlashPal2 > 0)
		{
			DrawPalSprite(pal_Player_CrystalFlash,1,cFlashPal2);
		}
		if(cFlashPalDiff > 0)
		{
			DrawPalSprite(pal_Player_CrystalFlash,2,cFlashPalDiff);
		}
		
		gpu_set_colorwriteenable(1,1,1,1);
		
		surface_reset_target();
	}
	else
	{
		cFlashPalSurf = surface_create(sprite_get_width(pal_Player_CrystalFlash),sprite_get_height(pal_Player_CrystalFlash));
	}
}
function DrawPalSprite(_sprt,_index,_alpha)
{
	draw_sprite_ext(_sprt,_index,0,0,1,1,0,c_white,clamp(_alpha,0,1));
}

#endregion

#region PreDrawPlayer
function PreDrawPlayer(xx, yy, rot, alpha)
{
	if(drawBallTrail)
	{
		var camX = camera_get_view_x(view_camera[0]),
			camY = camera_get_view_y(view_camera[0]),
			camW = camera_get_view_width(view_camera[0]),
			camH = camera_get_view_height(view_camera[0]);
		
		if(stateFrame == State.Morph || mbTrailAlpha > 0)
		{
			if(surface_exists(mbTrailSurface) && mbTrailSurface != -1)
			{
				surface_resize(mbTrailSurface,camW,camH);
				surface_set_target(mbTrailSurface);
				draw_clear_alpha(c_black,1);
				
				var tex = sprite_get_texture(sprt_MorphTrail,0);
				draw_primitive_begin_texture(pr_trianglestrip,tex);
				
				for(var i = 0; i < mbTrailLength; i++)
				{
					var tRatio = i/mbTrailLength;
					var tAlpha = tRatio,
						tColor = mbTrailColor_Start;
    
					if(tRatio < 0.5)
					{
						tColor = merge_colour(c_black,mbTrailColor_End,tRatio*2);
					}
					else
					{
						tColor = merge_colour(mbTrailColor_End,mbTrailColor_Start,tRatio*2-1);
					}

					var dist = min(i+2,8);
					if(mbTrailDir[i] == noone || (i >= mbTrailLength-1 && stateFrame != State.Morph))
					{
						dist = 0;
						tColor = c_black;
					}
						
					if(mbTrailPosX[i] != noone && mbTrailPosY[i] != noone)
					{
						var trailX1 = mbTrailPosX[i]-camX + lengthdir_x(dist,mbTrailDir[i]-90),
							trailY1 = mbTrailPosY[i]-camY + lengthdir_y(dist,mbTrailDir[i]-90),
							trailX2 = mbTrailPosX[i]-camX + lengthdir_x(dist,mbTrailDir[i]+90),
							trailY2 = mbTrailPosY[i]-camY + lengthdir_y(dist,mbTrailDir[i]+90);
						
						var ytex = scr_wrap(mbTrailNum + i*mbTrailNumRate, 0, mbTrailLength) / mbTrailLength;
						
						draw_vertex_texture_color(trailX1, trailY1, 0, ytex, tColor, tAlpha*mbTrailAlpha);
						draw_vertex_texture_color(trailX2, trailY2, 1, ytex, tColor, tAlpha*mbTrailAlpha);
						
						if(ytex >= 1 - mbTrailNumRate / mbTrailLength)
						{
							draw_vertex_texture_color(trailX1, trailY1, 0, 0, tColor, tAlpha*mbTrailAlpha);
							draw_vertex_texture_color(trailX2, trailY2, 1, 0, tColor, tAlpha*mbTrailAlpha);
						}
					}
				}
				
				draw_primitive_end();
				
				surface_reset_target();
   
				gpu_set_blendmode(bm_add);
				for(var i = 1; i <= 2; i++)
				{
					draw_surface_ext(mbTrailSurface, camX, camY, 1, 1, 0, c_white, alpha/i);
				}
				gpu_set_blendmode(bm_normal);
			}
			else
			{
				mbTrailSurface = surface_create(camW,camH);
			}
		}
		else
		{
			array_fill(mbTrailPosX, noone);
			array_fill(mbTrailPosY, noone);
			array_fill(mbTrailDir, noone);
		}
	}
	
	if(cBubbleScale > 0)
	{
		if(!global.gamePaused)
		{
			cBubblePal = scr_wrap(cBubblePal-0.1,0,7);
		}
		
		chameleon_set(pal_Player_CrystalBubble,cBubblePal,0,0,7);
		draw_sprite_ext(sprt_Player_CrystalBubble,0,scr_round(xx),scr_round(yy),cBubbleScale,cBubbleScale,0,c_white,alpha);
		shader_reset();
	}
	else
	{
		cBubblePal = 0;
	}
}
#endregion
#region UpdatePlayerSurface

surfW = 128;
surfH = 128;
playerSurf = surface_create(surfW,surfH);

rotScale = 5;//8;
playerSurf2 = surface_create(surfW*rotScale,surfH*rotScale);

function UpdatePlayerSurface(_palSurface)
{
	if(surface_exists(playerSurf))
	{
		surface_set_target(playerSurf);
		draw_clear_alpha(c_black,0);
		
		chameleon_set_surface(_palSurface);
		
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
			/*if(!global.gamePaused)
			{
				if(unmorphing)
				{
					morphAlpha = max(morphAlpha - 0.175/(1+liquidMovement), 0);
				}
				else if(morphFrame < 6)
				{
					morphAlpha = min(morphAlpha + 0.075/(1+liquidMovement), 1);
				}
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
			var ballSprtIndex = sprt_Player_MorphBall;
			//if(misc[Misc.Spring])
			if(misc[Misc.Spider])
			{
				ballSprtIndex = sprt_Player_SpringBall;
			}
			draw_sprite_ext(ballSprtIndex,ballFrame,scr_round(surfW/2),scr_round(surfH/2),1,1,0,c_white,morphAlpha);
			//if(misc[Misc.Spring])
			if(misc[Misc.Spider])
			{
				draw_sprite_ext(sprt_Player_SpringBall_Shine,0,scr_round(surfW/2),scr_round(surfH/2),1,1,0,c_white,morphAlpha);
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
			draw_sprite_ext(sprt_Player_MissileArm,finalArmFrame+(9*(missileArmFrame-1)),scr_round((surfW/2)+scr_round(armOffsetX)),scr_round((surfH/2 + runYOffset)+scr_round(armOffsetY)),armDir,1,0,c_white,1);
		}
		if(!drawMissileArm)
		{
			missileArmFrame = 0;
		}
	
		//if(stateFrame == State.Grip && climbIndex <= 0 && gripAimFrame == 0 && dir == -1 && dirFrame == -4)
		if(gripOverlay != -1)
		{
			draw_sprite_ext(gripOverlay,gripOverlayFrame,scr_round(surfW/2),scr_round(surfH/2 + runYOffset),fDir,1,0,c_white,1);
		}
		
		shader_reset();
	
		surface_reset_target();
	}
	else
	{
		playerSurf = surface_create(surfW,surfH);
		surface_set_target(playerSurf);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
	
	if(surface_exists(playerSurf2))
	{
		surface_set_target(playerSurf2);
		draw_clear_alpha(c_black,0);
		
		var shd = sh_better_scaling_5xbrc;
		shader_set(shd);
	    shader_set_uniform_f(shader_get_uniform(shd, "texel_size"), 1 / surface_get_width(playerSurf), 1 / surface_get_height(playerSurf));
	    shader_set_uniform_f(shader_get_uniform(shd, "texture_size"), surface_get_width(playerSurf), surface_get_height(playerSurf));
	    shader_set_uniform_f(shader_get_uniform(shd, "color"), 1, 1, 1, 1);
	    shader_set_uniform_f(shader_get_uniform(shd, "color_to_make_transparent"), 0, 0, 0);
		
		draw_surface_ext(playerSurf,0,0,rotScale,rotScale,0,c_white,1);
		shader_reset();
		
		surface_reset_target();
	}
	else
	{
		playerSurf2 = surface_create(surfW*rotScale,surfH*rotScale);
		surface_set_target(playerSurf2);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
	}
}
#endregion
#region DrawPlayer
function DrawPlayer(posX, posY, rotation, alpha)
{
	if(surface_exists(playerSurf2))
	{
		var surfCos = dcos(rotation),
			surfSin = dsin(rotation),
			surfX = (surfW/2),
			surfY = (surfH/2);
		var surfFX = posX - surfCos*surfX - surfSin*surfY,
			surfFY = posY - surfCos*surfY + surfSin*surfX;
		
		draw_surface_ext(playerSurf2,surfFX+sprtOffsetX,surfFY+sprtOffsetY,1/rotScale,1/rotScale,rotation,c_white,alpha);
	}
}
#endregion
#region PostDrawPlayer
function PostDrawPlayer(posX, posY, rot, alph)
{
	var xx = scr_round(posX),
		yy = scr_round(posY);
	
	if(introAnimState != -1)
	{
		introAnimFrameCounter++;
		if(introAnimFrameCounter > 3+(introAnimCounter >= 220))
		{
			if(introAnimCounter < 220)
			{
				introAnimFrame = scr_wrap(introAnimFrame+1,0,3);
				introAnimFrameCounter = 0;
			}
			else if(introAnimCounter < 286)
			{
				if(introAnimFrame < 8)
				{
					introAnimFrame = clamp(introAnimFrame+1,3,8);
					introAnimFrameCounter = 0;
				}
			}
			else if(introAnimFrame < 10)
			{
				introAnimFrame = clamp(introAnimFrame+1,9,10);
				introAnimFrameCounter = 0;
			}
		}
		
		if(introAnimFrameCounter < 2)
		{
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_Player_IntroFX,introAnimFrame,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,0,make_color_rgb(0,255,114),alph);
			gpu_set_blendmode(bm_normal);
		}
	}
	else
	{
		introAnimFrame = 0;
		introAnimFrameCounter = 0;
	}
	
	if(saveAnimCounter > 0)
	{
		saveAnimFrameCounter++;
		if(saveAnimFrameCounter > 3+(saveAnimCounter <= 45))
		{
			if(saveAnimCounter > 45)
			{
				saveAnimFrame = scr_wrap(saveAnimFrame+1,0,3);
			}
			else
			{
				saveAnimFrame = clamp(saveAnimFrame+1,3,10);
			}
			saveAnimFrameCounter = 0;
		}
		
		if(saveAnimFrameCounter < 2)
		{
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_Player_IntroFX,saveAnimFrame,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,0,make_color_rgb(0,255,114),alph);
			gpu_set_blendmode(bm_normal);
		}
	}

	//if(misc[Misc.Spring] && stateFrame == State.Morph)
	if(misc[Misc.Spider] && stateFrame == State.Morph)
	{
		var glowSpeed = 0.25;
		if(state == State.BallSpark || speedBoost)
		{
			glowSpeed = 0.375;
		}
		//else if(shineCharge > 0)
		//{
		//	glowSpeed = -0.45;
		//}
		var palSet = pal_Player_BallGlow;
		if(suit[0])
		{
			palSet = pal_Player_BallGlow_Varia;
		}
		if(suit[1])
		{
			palSet = pal_Player_BallGlow_Gravity;
		}
		if(global.roomTrans)
		{
			glowSpeed *= 0.5;
		}
		else if(global.gamePaused)
		{
			glowSpeed = 0;
		}
		ballGlowIndex = scr_wrap(ballGlowIndex + glowSpeed, 0, 9);
		
		var spiderPal = 9+ballGlowIndex;
		var spiderPalDiff = 0;
		if(spiderBall)
		{
			spiderPalDiff = 1;//1-clamp(spiderGlowAlpha,0,1);
		}
		
		chameleon_set(palSet,ballGlowIndex,spiderPal,spiderPalDiff,20);
		draw_sprite_ext(sprt_Player_SpringBall_Glow,ballFrame,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,morphAlpha*alph);
		shader_reset();
	}
	else
	{
		ballGlowIndex = 0;
	}
	
	if(stateFrame == State.Morph)
	{
		if((state == State.Morph || state == State.BallSpark) && morphFrame <= 0 && spiderBall)
		{
			var minGlow = 0.1,
				maxGlow = 0.75;
			if(speedBoost)
			{
				minGlow = 0.35;
				maxGlow = 1;
			}
			spiderGlowAlpha += 0.02 * spiderGlowNum * (!global.gamePaused);
			if(spiderGlowAlpha <= minGlow)
			{
				spiderGlowNum = max(spiderGlowNum,1);
			}
			if(spiderGlowAlpha >= maxGlow)
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
			var maxGlow2 = 0.5;
			if(speedBoost)
			{
				maxGlow2 = 0.75;
			}
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_Player_SpiderBallFX,0,scr_round(xx+sprtOffsetX),scr_round(yy+sprtOffsetY),1,1,rot,c_white,min(spiderGlowAlpha,maxGlow2)*alph);
			gpu_set_blendmode(bm_normal);
		}
	}
	else
	{
		spiderGlowAlpha = 0;
		spiderGlowNum = 2;
	}
	
	if(cBubbleScale > 0)
	{
		chameleon_set(pal_Player_CrystalBubble,cBubblePal,0,0,7);
		
		gpu_set_colorwriteenable(1,1,1,0);
		draw_sprite_ext(sprt_Player_CrystalBubble,0,scr_round(xx),scr_round(yy),cBubbleScale,cBubbleScale,0,c_white,alph*0.375);
		gpu_set_colorwriteenable(1,1,1,1);
		
		shader_reset();
	}
	
	if(state == State.Dodge)
	{
		if(shineFrame < 4)
		{
			var offset = 6*dodgeDir;
			if(dodgeDir == -dir)
			{
				offset = 0;
			}
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_Player_ShineSparkFX,shineFrame,xx+offset+sprtOffsetX,yy+sprtOffsetY,dodgeDir,1,0,c_lime,alph*0.75);
			gpu_set_blendmode(bm_normal);
			shineFrameCounter += 1*(!global.gamePaused);
			if(shineFrameCounter >= 2)
			{
				shineFrame++;
				shineFrameCounter = 0;
			}
		}
	}
	else if(state == State.Morph && boostBallFXFlash)
	{
		if(shineFrame < 4)
		{
			var sFrame = shineFrame;
			var shineRot = point_direction(oldPosition.X,oldPosition.Y,position.X,position.Y);
			var len = 3;
			var shineX = scr_round(xx + lengthdir_x(len,shineRot)),
				shineY = scr_round(yy + lengthdir_y(len,shineRot));
			var _wrp = scr_wrap(shineRot,0,90);
			if(_wrp >= 22.5 && _wrp <= 67.5)
			{
				sFrame += 4;
				shineRot -= 45*dir;
			}
			//if(dir == -1 && shineRot != 0)
			if(dir == -1 && point_distance(oldPosition.X,oldPosition.Y,position.X,position.Y) != 0)
			{
				shineRot -= 180;
			}
			gpu_set_blendmode(bm_add);
			draw_sprite_ext(sprt_Player_ShineSparkFX,sFrame,shineX+sprtOffsetX,shineY+sprtOffsetY,dir*0.75,0.75,shineRot,c_white,alph*0.9);
			gpu_set_blendmode(bm_normal);
			
			shineFrameCounter += 1*(!global.gamePaused);
			if(shineFrameCounter >= 2)
			{
				shineFrame++;
				shineFrameCounter = 0;
			}
		}
		else
		{
			boostBallFXFlash = false;
		}
	}
	else if(state == State.Spark && shineStart <= 0 && shineEnd <= 0)
	{
		shineFrameCounter += 1*(!global.gamePaused);
		if(shineFrameCounter >= 2+(shineFrame == 0))
		{
			shineFrame = scr_wrap(shineFrame+1,0,4);
			shineFrameCounter = 0;
		}
		var sFrame = shineFrame;
		//var shineRot = 90 - 45*shineDir;
		var shineRot = shineDir - 90;
		var len = 6;
		var shineX = scr_round(xx + lengthdir_x(len,shineRot)),
			shineY = scr_round(yy + lengthdir_y(len,shineRot));
		//if(abs(shineDir) == 1 || abs(shineDir) == 3)
		if(SparkDir_DiagUp() || SparkDir_DiagDown())
		{
			sFrame += 4;
			shineRot -= 45*dir;
		}
		if(dir == -1)
		{
			shineRot -= 180;
		}
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprt_Player_ShineSparkFX,sFrame,shineX+sprtOffsetX,shineY+sprtOffsetY,dir,1,shineRot,c_white,alph*0.9);
		gpu_set_blendmode(bm_normal);
	}
	else
	{
		shineFrame = 0;
		shineFrameCounter = 0;
	}

	if(isScrewAttacking && frame[Frame.Somersault] >= 2 && !canWallJump && wjFrame <= 0)
	{
		screwFrameCounter += 1*(!global.gamePaused);
		if(screwFrameCounter >= 2)
		{
			screwFrame = scr_wrap(screwFrame+1,0,4);
			screwFrameCounter = 0;
		}
		var a = 0.9;
		if(screwFrameCounter mod 2 != 0)
		{
			a = 0.5;
		}
		gpu_set_blendmode(bm_add);
		draw_sprite_ext(sprt_Player_ScrewAttackFX,screwFrame,xx,yy,dir,1,0,make_color_rgb(0,255,114),alph*a);
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
				rotation2 = scr_round(rotation2/2.8125)*2.8125;
    
	            for(var i = 1; i < numlinks+1; i++)
	            {
	                linksX[i] = startX + chainX/numlinks * i;
	                linksY[i] = startY + chainY/numlinks * i;
                
	                draw_sprite_ext(sprt,random_range(0,3),linksX[i],linksY[i],image_xscale,image_yscale,rotation2,c_white,1);
	            }
	        }
	    }
	    if(grapPartCounter > 1)
	    {
	        grapPartFrame = scr_wrap(grapPartFrame+1,0,2);
	        grapPartCounter = 0;
	    }
	    grapPartCounter += 1;
	}
	/*else if(hyperBeam && hyperFired > 0)
	{
		var hyperFFrame = (hyperFired-11) / 11;
		var hyperFiredFrame = 5 - (5 * hyperFFrame*hyperFFrame);
		
		if(hyperFiredFrame >= 0)
		{
			pal_swap_set(sprt_HyperBeamPalette,1+obj_Display.hyperRainbowCycle,0,0,false);
			draw_sprite_ext(sprt_HyperBeamStartParticle,hyperFiredFrame,scr_round(xx+sprtOffsetX+armOffsetX),scr_round(yy+sprtOffsetY+runYOffset+armOffsetY),image_xscale,image_yscale,0,c_white,alph);
			shader_reset();
		}*/
		/*hyperFiredFrameCounter++;
		if(hyperFiredFrameCounter > 1)
		{
			hyperFiredFrame++;
			hyperFiredFrameCounter = 0;
		}
		
		if(hyperFiredFrame <= 5)
		{
			pal_swap_set(sprt_HyperBeamPalette,1+obj_Display.hyperRainbowCycle,0,0,false);
			draw_sprite_ext(sprt_HyperBeamStartParticle,hyperFiredFrame,scr_round(xx+sprtOffsetX+armOffsetX),scr_round(yy+sprtOffsetY+runYOffset+armOffsetY),image_xscale,image_yscale,0,c_white,alph);
			shader_reset();
		}
		
		if(hyperFired >= 21)
		{
			hyperFiredFrame = 0;
			hyperFiredFrameCounter = 0;
		}
	}*/
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
				
				part_emitter_region(obj_Particles.partSystemA,obj_Particles.partEmitA,x1,x2,y1,y2,ps_shape_ellipse,ps_distr_gaussian);
				part_emitter_burst(obj_Particles.partSystemA,obj_Particles.partEmitA,obj_Particles.bTrails[partType],2+(statCharge >= maxCharge));
		
				particleFrame = 0;
			}
			if(stateFrame != State.Morph)
			{
				draw_sprite_ext(beamChargeAnim,chargeSetFrame,xx+sprtOffsetX+armOffsetX,yy+sprtOffsetY+runYOffset+armOffsetY,image_xscale,image_yscale,0,c_white,alph);
				var blend = make_color_rgb(230,120,32);
	            if(isIce)
	            {
	                blend = make_color_rgb(16,148,255);
	            }
	            else if(isWave)
	            {
	                blend = make_color_rgb(210,32,180);
	            }
	            else if(isPlasma)
	            {
	                blend = make_color_rgb(32,176,16);
	            }
	            gpu_set_blendmode(bm_add);
	            draw_sprite_ext(sprt_ChargeAnimGlow,chargeSetFrame,scr_round(xx+sprtOffsetX+armOffsetX),scr_round(yy+sprtOffsetY+runYOffset+armOffsetY),image_xscale,image_yscale,0,blend,alph*0.5);
	            gpu_set_blendmode(bm_normal);
			}
		}
		else
		{
			chargeSetFrame = 0;
			chargeFrame = 0;
			chargeFrameCounter = 0;
			particleFrame = 0;
		}
		
		//hyperFiredFrame = 0;
		//hyperFiredFrameCounter = 0;
	}
}
#endregion