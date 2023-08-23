/// @description 
event_inherited();

life = 5;
lifeMax = 5;
damage = 10;
freezeImmune = true;

function PauseAI()
{
	return (global.gamePaused || frozen > 0 || dmgFlash > 0);
}

function OnXCollision(fVX)
{
	velX *= -1;
}
function OnYCollision(fVY)
{
	velY *= -1;
}

palSurface = surface_create(sprite_get_height(pal_Kraid),sprite_get_width(pal_Kraid));