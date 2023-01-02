/// @description Initialize
event_inherited();

npcID = "Kraid";

life = 2000;
lifeMax = 2000;

freezeImmune = true;

dmgMult[DmgType.Beam][0] = 0; // all

dmgMult[DmgType.Explosive][3] = 0; // bomb
dmgMult[DmgType.Explosive][4] = 0; // power bomb
dmgMult[DmgType.Explosive][5] = 0; // splash 

dmgMult[DmgType.Misc][2] = 0; // speed booster / shine spark
dmgMult[DmgType.Misc][3] = 0; // screw attack

//dmgAbsorb = true;

damage = 20;
spikeDamage = 10;
fingerDamage = 10;

ignorePlayerImmunity = true;

enviroHandler = instance_create_depth(0,0,0,obj_Kraid_EnviroHandler);

phase = 0;
// 0 = spawn anim
// 1 = first phase
// 2 = phase transition
// 3 = second phase
// 4 = death anim

ai = array_create(4,0);

mouthCounter = -1;
mouthOpen = false;

function ModifyDamageTaken(damage,object,isProjectile)
{
	//dmgAbsorb = false;
	if(isProjectile && (phase == 1 || phase == 3))
	{
		//dmgAbsorb = object.y <= y-140;
		
		//if(headFrame >= 3 && point_distance(object.x,object.y,HeadBone.position.X,HeadBone.position.Y) <= 32)
		var col = collision_ellipse(HeadBone.position.X-16*dir,HeadBone.position.Y-16,HeadBone.position.X+32*dir,HeadBone.position.Y+32,object,true,true)
		if(headFrame >= 3 && col)
		{
			return damage;
		}
	}
	return 0;
}
function OnDamageAbsorbed(damage, object, isProjectile)
{
	if(mouthCounter < 0 && (phase == 1 || phase == 3) && object.y <= y-140)
	{
		mouthCounter = 0;
		eyeGlowNum = 1;
		blinkCounter = blinkCounterMax;
	}
}

function PauseAI()
{
	return (global.gamePaused || dmgFlash > 0);
}

function CameraLogic()
{
	var this = id;
	with(obj_Camera)
	{
		targetX = this.camPosX;
		targetY = this.camPosY;
		
		xDir = sign(targetX - playerX);
		//yDir = -1;//sign(targetY - playerY);
		
		//camKey = true;
	}
}

position = new Vector2(x,y);

dir = sign(image_xscale);
image_xscale = dir;
image_yscale = 1;
scale = new Vector2(1,1);

palIndex = 0;
palIndex2 = 0;
palDif = 0;

palIndex_Eyes = 1;
palIndex2_Eyes = 0;
palDif_Eyes = 0;

eyeGlow = 0;
eyeGlowNum = -1;

blinkCounter = 0;
blinkCounterMax = 180;

headFrame = 2;
headFrameCounter = 0;
headFrameNum = 0;

rHandFrame = 0;
lHandFrame = 0;

kraidSurf = surface_create(room_width, room_height);

#region Define Bones/Limbs

BodyBone = new AnimBone(0,0);
HeadBone = new AnimBone(-23,-178,BodyBone);
TailBone = new AnimBone(-88,16,BodyBone);

RArmBone[0] = new AnimBone(-55,-160,BodyBone);
RArmBone[1] = new AnimBone(11,54,RArmBone[0]);
RArmBone[2] = new AnimBone(60,-15,RArmBone[1]);

LArmBone[0] = new AnimBone(-55,-160,BodyBone);
LArmBone[1] = new AnimBone(11,54,LArmBone[0]);
LArmBone[2] = new AnimBone(60,-15,LArmBone[1]);

RLegBone[0] = new AnimBone(-9,27,BodyBone);
RLegBone[1] = new AnimBone(-2,40,RLegBone[0]);

LLegBone[0] = new AnimBone(-9,27,BodyBone);
LLegBone[1] = new AnimBone(-2,40,LLegBone[0]);

Limbs[0] = new DrawLimb("Bicep_Back", sprt_Kraid_Bicep_Back, LArmBone[0]);
Limbs[1] = new DrawLimb("Arm_Back", sprt_Kraid_Forearm_Back, LArmBone[1]);
Limbs[2] = new DrawLimb("Hand_Back", sprt_Kraid_Hand_Back, LArmBone[2]);

Limbs[3] = new DrawLimb("Leg_Back", sprt_Kraid_Leg_Back, LLegBone[0]);
Limbs[4] = new DrawLimb("Foot_Back", sprt_Kraid_Foot_Back, LLegBone[1]);

Limbs[5] = new DrawLimb("Tail", sprt_Kraid_Tail, TailBone);
Limbs[6] = new DrawLimb("Body", sprt_Kraid_Body, BodyBone);
Limbs[7] = new DrawLimb("Head", sprt_Kraid_Head, HeadBone);
Limbs[8] = new DrawLimb("Eyes", sprt_Kraid_Head, HeadBone);

Limbs[9] = new DrawLimb("Leg_Front", sprt_Kraid_Leg, RLegBone[0]);
Limbs[10] = new DrawLimb("Foot_Front", sprt_Kraid_Foot, RLegBone[1]);

Limbs[11] = new DrawLimb("Bicep_Front", sprt_Kraid_Bicep, RArmBone[0]);
Limbs[12] = new DrawLimb("Arm_Front", sprt_Kraid_Forearm, RArmBone[1]);
Limbs[13] = new DrawLimb("Hand_Front", sprt_Kraid_Hand, RArmBone[2]);

Limbs[14] = new DrawLimb("Ear", sprt_Kraid_Ear, HeadBone);

#endregion

#region Animation Sequences

// Arm Idle Anim
RArm_Idle = 
[
	[-30, -28, -20,  -10,  0,   10,  15,  18,   20, 18, 15,   10,  0,  -10, -20, -28],
	[-15, -14, -12, -9.5, -7, -4.5,  -2,  -1,    0, -1, -2, -4.5, -7, -9.5, -12, -14],
	[  0,   2,   8, 15.5, 23, 30.5,  38,  41,   45, 41, 38, 30.5, 23, 15.5,   8,   2]
];
LArm_Idle = 
[
	[20, 18, 15,   10,  0,  -10, -20, -28,   -30, -28, -20,  -10,  0,   10,  15,  18],
	[ 0, -1, -2, -4.5, -7, -9.5, -12, -14,   -15, -14, -12, -9.5, -7, -4.5,  -2,  -1],
	[45, 41, 38, 30.5, 23, 15.5,   8,   2,     0,   2,   8, 15.5, 23, 30.5,  38,  41]
];
RHandAnimSeq = array(0,1,2,3,4,5,6,7,8,7,6,5,4,3,2,1,0);
LHandAnimSeq = array(8,7,6,5,4,3,2,1,0,1,2,3,4,5,6,7,8);

ArmIdleFrame = 0;
ArmIdleTransition = 1;

function ArmIdleAnim(frame, transition)
{
	for(var i = 0; i < 3; i++)
	{
		RArmBone[i].AnimateRotation(RArm_Idle[i],frame,transition,true);
		LArmBone[i].AnimateRotation(LArm_Idle[i],frame,transition,true);
	}
	rHandFrame = RHandAnimSeq[scr_round(frame)];
	lHandFrame = LHandAnimSeq[scr_round(frame)];
}

#endregion

head = instance_create_layer(x,y,layer,obj_Kraid_Head);
head.realLife = id;
head.image_xscale = image_xscale;
head.image_yscale = image_yscale;
head.image_angle = 45;

rHand = instance_create_layer(x,y,layer,obj_Kraid_Hand);
rHand.realLife = id;
rHand.image_xscale = image_xscale;
rHand.image_yscale = image_yscale;