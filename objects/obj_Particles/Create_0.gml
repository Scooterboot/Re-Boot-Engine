/// @description Particle System

//System
partSystemA = part_system_create();
part_system_layer(partSystemA,layer_get_id("Projectiles_fg"));
part_system_automatic_update(partSystemA,false);

partSystemB = part_system_create();
part_system_layer(partSystemB,layer_get_id("Player"));
part_system_automatic_update(partSystemB,false);

partSystemC = part_system_create();
part_system_layer(partSystemC,layer_get_id("Projectiles"));
part_system_automatic_update(partSystemC,false);


//Basic dust
bDust = part_type_create();
part_type_sprite(bDust,sprt_BasicDust,true,true,false);
part_type_life(bDust,8,16);
part_type_direction(bDust,85,95,0,0);
part_type_speed(bDust,0.5,0.75,0.025,0);

//Muzzle Flare
mFlare[0] = part_type_create();
part_type_sprite(mFlare[0],sprt_PowerBeamStartParticle,true,true,false);
part_type_life(mFlare[0],2,2);

mFlare[1] = part_type_create();
part_type_sprite(mFlare[1],sprt_IceBeamStartParticle,true,true,false);
part_type_life(mFlare[1],2,2);

mFlare[2] = part_type_create();
part_type_sprite(mFlare[2],sprt_WaveBeamStartParticle,true,true,false);
part_type_life(mFlare[2],2,2);

mFlare[3] = part_type_create();
part_type_sprite(mFlare[3],sprt_SpazerStartParticle,true,true,false);
part_type_life(mFlare[3],2,2);

mFlare[4] = part_type_create();
part_type_sprite(mFlare[4],sprt_PlasmaBeamStartParticle,true,true,false);
part_type_life(mFlare[4],2,2);


//Impact (Normal)
impact[0] = part_type_create();
part_type_sprite(impact[0],sprt_PowerBeamImpact,true,true,false);
part_type_life(impact[0],8,8);

impact[1] = part_type_create();
part_type_sprite(impact[1],sprt_IceBeamImpact,true,true,false);
part_type_life(impact[1],8,8);

impact[2] = part_type_create();
part_type_sprite(impact[2],sprt_WaveBeamImpact,true,true,false);
part_type_life(impact[2],8,8);

impact[3] = part_type_create();
part_type_sprite(impact[3],sprt_SpazerImpact,true,true,false);
part_type_life(impact[3],8,8);

impact[4] = part_type_create();
part_type_sprite(impact[4],sprt_PlasmaBeamImpact,true,true,false);
part_type_life(impact[4],8,8);



//Impact (Charge)
cImpact[0] = part_type_create();
part_type_sprite(cImpact[0],sprt_PowerBeamChargeImpact,true,true,false);
part_type_life(cImpact[0],8,8);

cImpact[1] = part_type_create();
part_type_sprite(cImpact[1],sprt_IceBeamChargeImpact,true,true,false);
part_type_life(cImpact[1],8,8);

cImpact[2] = part_type_create();
part_type_sprite(cImpact[2],sprt_WaveBeamChargeImpact,true,true,false);
part_type_life(cImpact[2],8,8);

cImpact[3] = part_type_create();
part_type_sprite(cImpact[3],sprt_SpazerChargeImpact,true,true,false);
part_type_life(cImpact[3],8,8);

cImpact[4] = part_type_create();
part_type_sprite(cImpact[4],sprt_PlasmaBeamChargeImpact,true,true,false);
part_type_life(cImpact[4],8,8);


//Beam Trails

bTrails[0] = part_type_create();
part_type_alpha2(bTrails[0],.8,0);
part_type_blend(bTrails[0],1);
part_type_color2(bTrails[0],c_yellow,c_red);
part_type_direction(bTrails[0],0,360,0,0);
part_type_life(bTrails[0],8,25);
//part_type_life(bTrails[0],8,16);
part_type_sprite(bTrails[0],sprt_ParticlePixel,0,0,0);
part_type_speed(bTrails[0],0.2,0.4,0,0);

bTrails[1] = part_type_create();
part_type_alpha3(bTrails[1],1,.7,0);
part_type_blend(bTrails[1],1);
part_type_color3(bTrails[1],c_white,c_aqua,c_blue);
part_type_direction(bTrails[1],0,360,0,0);
part_type_life(bTrails[1],50/4,100/4);
//part_type_life(bTrails[1],12,16);
part_type_sprite(bTrails[1],sprt_ParticlePixel,0,0,0);
part_type_speed(bTrails[1],.2,.6,0,0);
//part_type_gravity(bTrails[1],.051,270);
part_type_gravity(bTrails[1],.1,270);

bTrails[2] = part_type_create();
part_type_alpha2(bTrails[2],.8,0);
part_type_blend(bTrails[2],1);
part_type_color2(bTrails[2],c_purple,c_fuchsia);
part_type_direction(bTrails[2],0,360,0,0);
part_type_life(bTrails[2],8,25);
//part_type_life(bTrails[2],8,16);
part_type_sprite(bTrails[2],sprt_ParticlePixel,0,0,0);
part_type_speed(bTrails[2],0.2,0.4,0,0);

bTrails[3] = part_type_create();
part_type_alpha2(bTrails[3],.8,0);
part_type_blend(bTrails[3],1);
part_type_color2(bTrails[3],c_yellow,c_red);
part_type_direction(bTrails[3],0,360,0,0);
part_type_life(bTrails[3],8,25);
//part_type_life(bTrails[3],8,16);
part_type_sprite(bTrails[3],sprt_ParticlePixel,0,0,0);
part_type_speed(bTrails[3],0.2,0.4,0,0);

bTrails[4] = part_type_create();
part_type_alpha2(bTrails[4],.8,0);
part_type_blend(bTrails[4],1);
part_type_color3(bTrails[4],c_white,c_lime,c_green);
part_type_direction(bTrails[4],0,360,0,0);
part_type_life(bTrails[4],8,25);
//part_type_life(bTrails[4],8,16);
part_type_sprite(bTrails[4],sprt_ParticlePixel,0,0,0);
part_type_speed(bTrails[4],0.2,0.4,0,0);

bTrails[5] = part_type_create();
part_type_sprite(bTrails[5],sprt_WaveBeamTrail,true,true,false);
part_type_life(bTrails[5],16,16);

bTrails[6] = part_type_create();
part_type_sprite(bTrails[6],sprt_IceBeamTrail,true,true,false);
part_type_life(bTrails[6],8,16);
part_type_direction(bTrails[6],265,275,0,0);
part_type_speed(bTrails[6],0,0.1,0,0);
part_type_gravity(bTrails[6],0.1,270);

#region Hyper Beam trail particles
for(var i = 0; i < 10; i++)
{
	var k = 0,
		k2 = 33;
	switch(i)
	{
		case 1:
		{
			k = 33;
			k2 = 60;
			break;
		}
		case 2:
		{
			k = 60;
			k2 = 90;
			break;
		}
		case 3:
		{
			k = 90;
			k2 = 120;
			break;
		}
		case 4:
		{
			k = 120;
			k2 = 150;
			break;
		}
		case 5:
		{
			k = 150;
			k2 = 200;
			break;
		}
		case 6:
		{
			k = 200;
			k2 = 260;
			break;
		}
		case 7:
		{
			k = 260;
			k2 = 300;
			break;
		}
		case 8:
		{
			k = 300;
			k2 = 330;
			break;
		}
		case 9:
		{
			k = 330;
			k2 = 0;
			break;
		}
	}
	var hue = k / 360,
		hue2 = k2 / 360;
	var c1 = make_color_hsv(255*hue,255,255), c2 = make_color_hsv(255*hue2,255,255);
	var j = i+7;
	bTrails[j] = part_type_create();
	part_type_alpha2(bTrails[j],.8,0);
	part_type_blend(bTrails[j],true);
	part_type_color2(bTrails[j],c1,c2);
	part_type_direction(bTrails[j],0,360,0,0);
	part_type_life(bTrails[j],8,25);
	part_type_sprite(bTrails[j],sprt_ParticlePixel,0,0,0);
	part_type_speed(bTrails[j],0.2,0.4,0,0);
}
#endregion


//Missile Trails
mTrail[0] = part_type_create();
part_type_sprite(mTrail[0],sprt_MissileTrail,true,true,false);
part_type_life(mTrail[0],14,14);
//part_type_blend(mTrail[0],1);

mTrail[1] = part_type_create();
part_type_sprite(mTrail[1],sprt_SuperMissileTrail,true,true,false);
part_type_life(mTrail[1],18,18);
//part_type_blend(mTrail[1],1);



//Explosions
explosion[0] = part_type_create();
part_type_sprite(explosion[0],sprt_MBBombExplosion,true,true,false);
part_type_life(explosion[0],10,10);
//part_type_blend(explosion[0],1);

explosion[1] = part_type_create();
part_type_sprite(explosion[1],sprt_MissileExplosion,true,true,false);
part_type_life(explosion[1],15,15);
//part_type_blend(explosion[1],1);
//part_type_scale(explosion[1],0.6,0.6);

explosion[2] = part_type_create();
part_type_sprite(explosion[2],sprt_SuperMissileExplosion,true,true,false);
part_type_life(explosion[2],15,15);
//part_type_blend(explosion[2],1);


//Deflect
partDeflect = part_type_create();
part_type_alpha3(partDeflect,.9,.7,0);
part_type_blend(partDeflect,1);
part_type_color2(partDeflect,c_ltgray,c_gray);
part_type_direction(partDeflect,0,360,0,3);
part_type_life(partDeflect,8,10);
part_type_orientation(partDeflect,0,360,0,0,1);
part_type_sprite(partDeflect,sprt_ParticlePixel,0,1,0);
part_type_size(partDeflect,.9,1.2,-.039,0);
part_type_speed(partDeflect,.7,1,-.015,0);
part_type_scale(partDeflect,1,1);

partAbsorb = part_type_create();
part_type_sprite(partAbsorb,sprt_ProjAbsorbed,true,true,false);
part_type_life(partAbsorb,12,12);

//Enemy Freeze
partFreeze = part_type_create();
part_type_alpha3(partFreeze,1,.7,0);
part_type_blend(partFreeze,1);
part_type_color3(partFreeze,c_white,c_aqua,c_blue);
part_type_direction(partFreeze,0,360,0,0);
part_type_life(partFreeze,8,10);
part_type_sprite(partFreeze,sprt_ParticlePixel,0,0,0);
part_type_speed(partFreeze,.7,1,-.015,0);
part_type_gravity(partFreeze,.07,270);


//Grapple
gImpact = part_type_create();
part_type_sprite(gImpact,sprt_GrappleBeamImpact,true,true,false);
part_type_life(gImpact,8,8);

gTrail = part_type_create();
part_type_alpha3(gTrail,1,.7,0);
part_type_blend(gTrail,1);
part_type_color3(gTrail,c_white,c_aqua,c_blue);
part_type_direction(gTrail,0,360,0,0);
part_type_life(gTrail,12,25);
part_type_sprite(gTrail,sprt_ParticlePixel,0,0,0);
part_type_speed(gTrail,0.2,0.4,0,0);



//Enemy death explosions
npcDeath[0] = part_type_create();
part_type_sprite(npcDeath[0],sprt_EnemyDeath0,true,true,false);
part_type_life(npcDeath[0],18,18);

npcDeath[1] = part_type_create();
part_type_sprite(npcDeath[1],sprt_EnemyDeath1,true,true,false);
part_type_life(npcDeath[1],24,24);

npcDeath[2] = part_type_create();
part_type_sprite(npcDeath[2],sprt_EnemyDeath2,true,true,false);
part_type_life(npcDeath[2],15,15);



npcDeath[3] = part_type_create();
part_type_sprite(npcDeath[3],sprt_EnemyDeath2,true,true,false);
part_type_life(npcDeath[3],15,15);
part_type_direction(npcDeath[3],135,135,0,0);
part_type_orientation(npcDeath[3],0,0,0,0,0);
part_type_speed(npcDeath[3],4,4,-0.25,0);

npcDeath[4] = part_type_create();
part_type_sprite(npcDeath[4],sprt_EnemyDeath2,true,true,false);
part_type_life(npcDeath[4],15,15);
part_type_direction(npcDeath[4],45,45,0,0);
part_type_orientation(npcDeath[4],270,270,0,0,0);
part_type_speed(npcDeath[4],4,4,-0.25,0);

npcDeath[5] = part_type_create();
part_type_sprite(npcDeath[5],sprt_EnemyDeath2,true,true,false);
part_type_life(npcDeath[5],15,15);
part_type_direction(npcDeath[5],225,225,0,0);
part_type_orientation(npcDeath[5],90,90,0,0,0);
part_type_speed(npcDeath[5],4,4,-0.25,0);

npcDeath[6] = part_type_create();
part_type_sprite(npcDeath[6],sprt_EnemyDeath2,true,true,false);
part_type_life(npcDeath[6],15,15);
part_type_direction(npcDeath[6],315,315,0,0);
part_type_orientation(npcDeath[6],180,180,0,0,0);
part_type_speed(npcDeath[6],4,4,-0.25,0);


npcDeath[7] = part_type_create();
part_type_sprite(npcDeath[7],sprt_EnemyDeath3,true,true,false);
part_type_life(npcDeath[7],16,16);
part_type_direction(npcDeath[7],45,135,0,0);
part_type_speed(npcDeath[7],6,8,-0.25,0);
part_type_gravity(npcDeath[7],.9,270);


partSystemD = part_system_create();
//part_system_depth(partSystemD,95);
part_system_layer(partSystemD,layer_get_id("BTS_Tiles"));
part_system_automatic_update(partSystemD,false);

blockBreak[0] = part_type_create();
part_type_sprite(blockBreak[0],sprt_BlockBreak,true,true,false);
part_type_life(blockBreak[0],9,9);

blockBreak[1] = part_type_create();
part_type_sprite(blockBreak[1],sprt_ChainBlockBreak,true,true,false);
part_type_life(blockBreak[1],9,9);

blockBreak[2] = part_type_create();
part_type_sprite(blockBreak[2],sprt_MissileBlockBreak,true,true,false);
part_type_life(blockBreak[2],9,9);

blockBreak[3] = part_type_create();
part_type_sprite(blockBreak[3],sprt_SuperMissileBlockBreak,true,true,false);
part_type_life(blockBreak[3],9,9);

blockBreak[4] = part_type_create();
part_type_sprite(blockBreak[4],sprt_PowerBombBlockBreak,true,true,false);
part_type_life(blockBreak[4],9,9);

blockBreak[5] = part_type_create();
part_type_sprite(blockBreak[5],sprt_SpeedBlockBreak,true,true,false);
part_type_life(blockBreak[5],9,9);

blockBreak[6] = part_type_create();
part_type_sprite(blockBreak[6],sprt_ScrewBlockBreak,true,true,false);
part_type_life(blockBreak[6],9,9);