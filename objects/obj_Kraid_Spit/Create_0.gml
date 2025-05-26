/// @description 
event_inherited();

life = 5;
lifeMax = 5;
damage = 10;
freezeImmune = true;

kill = false;

function PauseAI()
{
	return (global.gamePaused || frozen > 0 || dmgFlash > 0);
}

grav = 0.125;

function OnXCollision(fVX)
{
	for(var i = 0; i < 3; i++)
	{
		var spX = lengthdir_x(2,45+(90*i)),
			spY = lengthdir_y(2,45+(90*i));
		var rock = instance_create_layer(position.X,position.Y,"Projectiles",obj_Kraid_Rock);
		rock.sprite_index = sprt_Kraid_Pebble;
		rock.mask_index = rock.sprite_index;
		rock.velX = spX;
		rock.velY = spY;
	}
	kill = true;
}
function OnYCollision(fVY)
{
	OnXCollision(fVY);
}