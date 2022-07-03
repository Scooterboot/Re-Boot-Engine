///scr_DamagePlayer(damage,knockTime,knockSpeedX,knockSpeedY,immuneTime)
function scr_DamagePlayer(damage,knockTime,knockSpeedX,knockSpeedY,immune_time)
{
	with(obj_Player)
	{
	    var dmg = scr_round(damage * (1-(0.5*suit[0])) * (1-(0.5*suit[1]))),
	        hurtT = knockTime,
	        hurtSX = knockSpeedX,
	        hurtSY = knockSpeedY,
	        immune = immune_time;
    
	    if(!global.gamePaused && !godmode)
	    {
	        if(dmg >= energy)
	        {
	            energy = max(energy - dmg,0);
	            state = State.Death;
	        }
	        else if(dmg > 0)
	        {
	            energy = max(energy - dmg,0);
	            if(hurtT > 0 && dir != 0 && state != State.Hurt && state != State.Grapple)
	            {
	                lastState = state;
	                state = State.Hurt;
	                hurtTime = hurtT;
	                hurtSpeedX = hurtSX;
	                hurtSpeedY = hurtSY;
	                jump = 0;
	                jumping = false;
	            }
	            if(immune > 0)
	            {
	                immuneTime = immune;
	                if(!audio_is_playing(snd_Hurt))
	                {
	                    audio_play_sound(snd_Hurt,0,false);
	                }
	                dmgFlash = 2;
	            }
	        }
	    }
	}
}
