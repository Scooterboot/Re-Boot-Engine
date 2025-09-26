/// @description Initialize
event_inherited();

life = 1000;
lifeMax = 1000;
damage = 10;

freezeImmune = true;

dmgMult[DmgType.Beam][0] = 0;
dmgMult[DmgType.Charge][0] = 0;
dmgMult[DmgType.Explosive][0] = 0;
dmgMult[DmgType.Misc][0] = 0;

dir = sign(image_xscale);
posType = 0;

ai[0] = 0;
ai[1] = 0;

moveSpeed = 3;

tileCollide = false;

function PauseAI()
{
	return (global.GamePaused() || /*!scr_WithinCamRange() ||*/ frozen > 0 || dmgFlash > 0);
}
function NPCDeath(_x,_y)
{
	instance_destroy();
}

palSurface = surface_create(sprite_get_height(pal_Kraid),sprite_get_width(pal_Kraid));