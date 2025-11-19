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
	return (global.GamePaused() || frozen > 0 || dmgFlash > 0);
}

function Entity_OnDamageDealt(_selfDmgBox, _lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType)
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
function OnXCollision(fVX, isOOB = false)
{
	velX *= -1;
	self.BounceLimit();
}
function OnYCollision(fVY, isOOB = false)
{
	velY *= -1;
	self.BounceLimit();
}

palSurface = surface_create(sprite_get_height(pal_Kraid),sprite_get_width(pal_Kraid));