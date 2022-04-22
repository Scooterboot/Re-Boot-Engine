///scr_DamagePlayer(damage,knockTime,knockSpeedX,knockSpeedY,immuneTime)
function scr_DamagePlayer() {

	with(obj_Player)
	{
	    var dmg = scr_round(argument[0] * (1-(0.5*suit[0])) * (1-(0.5*suit[1]))),
	    //var dmg = scr_round(argument[0] * (1-(0.25*suit[0] + 0.25*suit[1] + 0.25*suit[2]))),
	        hurtT = argument[1],
	        hurtSX = argument[2],
	        hurtSY = argument[3],
	        immune = argument[4];
    
	    if(!global.gamePaused && !godmode)
	    {
	        if(dmg >= energy)
	        {
	            energy = max(energy - dmg,0);
	            state = State.Death;
	        }
	        else
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
