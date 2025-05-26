/// @description 
event_inherited();

life = 5;
lifeMax = 5;
damage = 10;
freezeImmune = true;

dropChance[0] = 0; // nothing
dropChance[1] = 4; // energy
dropChance[2] = 14; // large energy
dropChance[3] = 80; // missile
dropChance[4] = 4; // super missile
dropChance[5] = 0; // power bomb

function PauseAI()
{
	return (global.gamePaused || frozen > 0 || dmgFlash > 0);
}

function OnDamagePlayer()
{
	dead = true;
}

_kill = false;
bounceNum = 5;
function BounceLimit()
{
	bounceNum--;
	if(bounceNum <= 0)
	{
		_kill = true;
	}
}
function OnXCollision(fVX)
{
	velX *= -1;
	BounceLimit();
}
function OnYCollision(fVY)
{
	velY *= -1;
	BounceLimit();
}

palSurface = surface_create(sprite_get_height(pal_Kraid),sprite_get_width(pal_Kraid));