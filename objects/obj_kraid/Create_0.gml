/// @description Initialize
event_inherited();

spawnPos = new Vector2(224,688);
p1Height = 152;
p2Height = 160;
p2LeftBound = 308;
p2RightBound = 392;

//position = new Vector2(x,y);
position = new Vector2(spawnPos.X,spawnPos.Y);

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
dmgMult[DmgType.Misc][5] = 0; // boost ball

dropChance[0] = 0; // nothing
dropChance[1] = 20; // energy
dropChance[2] = 20; // large energy
dropChance[3] = 20; // missile
dropChance[4] = 20; // super missile
dropChance[5] = 20; // power bomb

//dmgAbsorb = true;

damage = 20;
spitDamage = 5;
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

bellySpikePos[0] = new Vector2(41,24);
bellySpikePos[1] = new Vector2(42,-41);
bellySpikePos[2] = new Vector2(16,-99);

fingerFlung = false;

haltArmMove = 0;
haltArmMax = 90;
armAnimSpeed = 0.1;

function ModifyDamageTaken(damage,object,isProjectile)
{
	//dmgAbsorb = false;
	if(isProjectile && (phase == 1 || phase == 3))
	{
		//dmgAbsorb = object.y <= y-140;
		
		//if(headFrame >= 3 && point_distance(object.x,object.y,HeadBone.position.X,HeadBone.position.Y) <= 32)
		var col = collision_ellipse(HeadBone.position.X-16*dir,HeadBone.position.Y-16,HeadBone.position.X+32*dir,HeadBone.position.Y+32,object,true,true)
		if(headFrame > 3 && col)
		{
			return damage;
		}
	}
	return 0;
}
function OnDamageAbsorbed(damage, object, isProjectile)
{
	if(mouthCounter < 0 && ((phase == 1 && ai[0] != 2) || phase == 3) && object.y <= y-140)
	{
		mouthCounter = 0;
		//eyeGlowNum = 1;
		//blinkCounter = blinkCounterMax;
		if(isProjectile && object.damageType = DmgType.Charge)
		{
			haltArmMove = haltArmMax;
		}
	}
}

function PauseAI()
{
	return (global.gamePaused || dmgFlash > 0);
}

function CameraLogic()
{
	//var this = id;
	with(obj_Camera)
	{
		camLimitMax_Left = 16;
		camLimitMax_Right = 32;
		//camLimitMax_Top = camLimitDefault_Top;
		//camLimitMax_Bottom = camLimitDefault_Bottom;
	}
}

dir = sign(image_xscale);
image_xscale = dir;
image_yscale = 1;
scale = new Vector2(1,1);

moveDir = 0;

blinkCounter = 0;
blinkCounterMax = 180;

headFrame = 2;
headFrameCounter = 0;
headFrameNum = 0;
headBoxRotSeq = array(45, 45, 45, 32.5, 20, 7.5, -5, -17.5, -30, -30, -17.5, -5, 7.5, 20, 32.5);

rHandFrame = 0;
lHandFrame = 0;

kraidSurf = surface_create(room_width, room_height);

#region Palette

eyeGlow = 0;
eyeGlowNum = -1;

palSurface = surface_create(sprite_get_height(pal_Kraid),sprite_get_width(pal_Kraid));

function Palette()
{
	if(surface_exists(palSurface))
	{
		surface_set_target(palSurface);
		
		var palIndex = 0;
		if(life <= lifeMax*0.875)
		{
			palIndex = 1;
		}
		if(life <= lifeMax*0.75)
		{
			palIndex = 2;
		}
		if(life <= lifeMax*0.625)
		{
			palIndex = 3;
		}
		if(life <= lifeMax*0.5)
		{
			palIndex = 4;
		}
		if(life <= lifeMax*0.375)
		{
			palIndex = 5;
		}
		if(life <= lifeMax*0.25)
		{
			palIndex = 6;
		}
		if(life <= lifeMax*0.125)
		{
			palIndex = 7;
		}
		DrawPalSprite(pal_Kraid,palIndex,1);
		
		gpu_set_colorwriteenable(1,1,1,0);
		
		if(eyeGlow > 0)
		{
			DrawPalSprite(pal_Kraid,9,eyeGlow);
		}
		
		if(dmgFlash > 4)
		{
			DrawPalSprite(pal_Kraid,8,1);
		}
		
		gpu_set_colorwriteenable(1,1,1,1);
		
		surface_reset_target();
	}
	else
	{
		palSurface = surface_create(sprite_get_height(pal_Kraid),sprite_get_width(pal_Kraid));
	}
}
function DrawPalSprite(_sprt,_index,_alpha)
{
	draw_sprite_ext(_sprt,_index,0,0,1,1,0,c_white,clamp(_alpha,0,1));
}

#endregion

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

Bones[0] = BodyBone;
Bones[1] = HeadBone;
Bones[2] = TailBone;
Bones[3] = RArmBone[0];
Bones[4] = RArmBone[1];
Bones[5] = RArmBone[2];
Bones[6] = LArmBone[0];
Bones[7] = LArmBone[1];
Bones[8] = LArmBone[2];
Bones[9] = RLegBone[0];
Bones[10] = RLegBone[1];
Bones[11] = LLegBone[0];
Bones[12] = LLegBone[1];

Limbs[0] = new DrawLimb("Bicep_Back", sprt_Kraid_Bicep_Back, LArmBone[0]);
Limbs[1] = new DrawLimb("Arm_Back", sprt_Kraid_Forearm_Back, LArmBone[1]);
Limbs[2] = new DrawLimb("Hand_Back", sprt_Kraid_Hand_Back, LArmBone[2]);

Limbs[3] = new DrawLimb("Leg_Back", sprt_Kraid_Leg_Back, LLegBone[0]);
Limbs[4] = new DrawLimb("Foot_Back", sprt_Kraid_Foot_Back, LLegBone[1]);

Limbs[5] = new DrawLimb("Tail", sprt_Kraid_Tail, TailBone);
Limbs[6] = new DrawLimb("Body", sprt_Kraid_Body, BodyBone);
Limbs[7] = new DrawLimb("Head", sprt_Kraid_Head, HeadBone);

Limbs[8] = new DrawLimb("Leg_Front", sprt_Kraid_Leg, RLegBone[0]);
Limbs[9] = new DrawLimb("Foot_Front", sprt_Kraid_Foot, RLegBone[1]);

Limbs[10] = new DrawLimb("Bicep_Front", sprt_Kraid_Bicep, RArmBone[0]);
Limbs[11] = new DrawLimb("Arm_Front", sprt_Kraid_Forearm, RArmBone[1]);
Limbs[12] = new DrawLimb("Hand_Front", sprt_Kraid_Hand, RArmBone[2]);

Limbs[13] = new DrawLimb("Ear", sprt_Kraid_Ear, HeadBone);

for(var i = 0; i < array_length(Limbs); i++)
{
	Limbs[i].Shader = function()
	{
		chameleon_set_surface(palSurface);
	}
}

#endregion

#region Animation Sequences

// Arm Idle Anim
RArm_Idle = 
[
	[-30, -28, -20,  -10,  0,   10,  15,  18,   20, 18, 15,   10,  0,  -10, -20, -28],
	[ 15,  14,   8,  0.5, -7,-14.5, -17, -19,  -20,-19,-17,-14.5, -7,  0.5,   8,  14],
	[ 15,  16,  20,   25, 30,   35,  40,  42,   45, 42, 40,   35, 30,   25,  20,  16]
];
LArm_Idle = 
[
	[ 20, 18, 15,   10,  0,  -10, -20, -28,   -30, -28, -20,  -10,  0,   10,  15,  18],
	[-20,-19,-17,-14.5, -7,  0.5,   8,  14,    15,  14,   8,  0.5, -7,-14.5, -17, -19],
	[ 45, 42, 40,   35, 30,   25,  20,  16,    15,  16,  20,   25, 30,   35,  40,  42]
];
RHandAnimSeq_Idle = array(0,1,2,3,4,5,6,7,8,7,6,5,4,3,2,1,0);
LHandAnimSeq_Idle = array(8,7,6,5,4,3,2,1,0,1,2,3,4,5,6,7,8);

ArmIdleFrame = 0;
ArmIdleTransition = 1;

function ArmIdleAnim(frame, transition)
{
	for(var i = 0; i < 3; i++)
	{
		RArmBone[i].AnimateRotation(RArm_Idle[i],frame,transition,true);
		LArmBone[i].AnimateRotation(LArm_Idle[i],frame,transition,true);
	}
	rHandFrame = RHandAnimSeq_Idle[scr_round(frame)];
	lHandFrame = LHandAnimSeq_Idle[scr_round(frame)];
}


// Arm Anim Poke
RArm_Poke = 
[
	[-30, 5,  40, 5, -30],
	[ 25, 0, -50, 0,  25],
	[ 20, 0,  10, 0,  20]
];
LArm_Poke = 
[
	[ 30,    5, -20, -5,  10],
	[-30, -2.5,  25,  5, -15],
	[ 45,   20,  -5,  10, 35]
];

ArmPokeFrame = 0;
ArmPokeTransition = 0;

function ArmPokeAnim(frame, transition)
{
	for(var i = 0; i < 3; i++)
	{
		RArmBone[i].AnimateRotation(RArm_Poke[i],frame,transition,true);
		LArmBone[i].AnimateRotation(LArm_Poke[i],frame,transition,true);
	}
	var rhnd = clamp(lerp(0,8,frame), 0, 8),
		lhnd = clamp(lerp(8,0,frame/2), 0, 8);
	
	rHandFrame = lerp(rHandFrame,rhnd,transition);
	lHandFrame = lerp(lHandFrame,lhnd,transition);
}


// Arm Anim Fling
Arm_Fling = 
[
	[-30, -16, -3,  9, 20,  18,  15,  11, -9.5],
	[ 15,  18, 20, 10,  0, -15, -27, -37,  -11],
	[ 15,  25, 40, 45, 43,  25,  10,   0,  7.5]
];
Arm_Fling_Offhand = [-15,0,15];
HandAnimSeq_Fling = array(0,3,6,8,8,7,6,5,3,0);

ArmFlingFrame = 0;
ArmFlingTransition = 0;
ArmFlingUseLeft = false;

function ArmFlingAnim(frame, transition)
{
	if(ArmFlingUseLeft)
	{
		for(var i = 0; i < 3; i++)
		{
			RArmBone[i].offsetRotation = lerp(RArmBone[i].offsetRotation,Arm_Fling_Offhand[i],transition);
			LArmBone[i].AnimateRotation(Arm_Fling[i],frame,transition,true);
		}
		rHandFrame = lerp(rHandFrame,0,transition);
		lHandFrame = lerp(lHandFrame,HandAnimSeq_Fling[scr_round(frame)],transition);
	}
	else
	{
		for(var i = 0; i < 3; i++)
		{
			RArmBone[i].AnimateRotation(Arm_Fling[i],frame,transition,true);
			LArmBone[i].offsetRotation = lerp(LArmBone[i].offsetRotation,Arm_Fling_Offhand[i],transition);
		}
		rHandFrame = lerp(rHandFrame,HandAnimSeq_Fling[scr_round(frame)],transition);
		lHandFrame = lerp(lHandFrame,0,transition);
	}
}


// Arm Anim Dying
ArmDyingFrame = 0;
ArmDyingTransition = 0;

function ArmDyingAnim(frame, transition)
{
	var len = array_length(Arm_Fling[0]);
	var frame2 = scr_wrap(frame + (len / 2), 0, len);
	
	for(var i = 0; i < 3; i++)
	{
		RArmBone[i].AnimateRotation(Arm_Fling[i],frame,transition,true);
		LArmBone[i].AnimateRotation(Arm_Fling[i],frame2,transition,true);
	}
	rHandFrame = lerp(rHandFrame,HandAnimSeq_Fling[scr_round(frame)],transition);
	lHandFrame = lerp(lHandFrame,HandAnimSeq_Fling[scr_round(frame2)],transition);
}

// Walk Anim
RLeg_Walk = 
[
	[-45, -26.25, -7.5, 11.25,   30, 11.25, -7.5, -26.25],
	[ 45,  26.25,  7.5,-11.25,  -30,-11.25,  7.5,  26.25]
];
LLeg_Walk = 
[
	[ 30, 11.25, -7.5, -26.25,  -45, -26.25, -7.5, 11.25],
	[-30,-11.25,  7.5,  26.25,   45,  26.25,  7.5,-11.25]
];

RLeg_Walk_Pos = [ new Vector2(0,0),   new Vector2(0,-9),  new Vector2(0,-13),   new Vector2(0,-13), 
				 new Vector2(0,-9), new Vector2(0,-6.75), new Vector2(0,-4.5), new Vector2(0,-2.25)];
LLeg_Walk_Pos = [new Vector2(0,-9), new Vector2(0,-6.75), new Vector2(0,-4.5), new Vector2(0,-2.25), 
				  new Vector2(0,0),   new Vector2(0,-9),  new Vector2(0,-13),   new Vector2(0,-13)];

WalkFrame = 4;
WalkFrame2 = 0;
WalkTransition = 1;

function WalkAnim(frame, transition)
{
	for(var i = 0; i < 2; i++)
	{
		RLegBone[i].AnimateRotation(RLeg_Walk[i],frame,transition,true);
		LLegBone[i].AnimateRotation(LLeg_Walk[i],frame,transition,true);
	}
	
	RLegBone[0].AnimatePosition(RLeg_Walk_Pos,frame,transition,true);
	LLegBone[0].AnimatePosition(LLeg_Walk_Pos,frame,transition,true);
}

WalkMoveSpeed = [7, 14, 14, 7,  7, 14, 14, 7,];

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