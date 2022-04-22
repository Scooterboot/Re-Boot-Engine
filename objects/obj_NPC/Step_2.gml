/// @description 

#region General Behavior
if(justHit)
{
	//insert stuff here...?
	justHit = false;
}

if(frozen > 0 && !dead)
{
	if(!instance_exists(freezePlatform))
	{
	    freezePlatform = instance_create_layer(bbox_left,bbox_top,layer_get_id("Collision"),obj_Platform);
	    freezePlatform.image_xscale = (bbox_right-bbox_left)/16;
	    freezePlatform.image_yscale = (bbox_bottom-bbox_top)/16;
	}
}
else if(instance_exists(freezePlatform))
{
	instance_destroy(freezePlatform);
}

frozenImmuneTime = max(frozenImmuneTime-1,0);
frozen = max(frozen - 1, 0);
#endregion

#region Damage to Player
if(!friendly && damage > 0 && !frozen && !dead)
{
    var player = instance_place(x,y,obj_Player);
    if(instance_exists(player))
    {
        if (player.immuneTime <= 0 && !player.immune)//!player.isChargeSomersaulting && !player.isScrewAttacking && !player.isSpeedBoosting)
        {
            //var ang = point_direction(x,y,obj_Samus.x,obj_Samus.y);
            var ang = 45;
            if(player.bbox_bottom > bbox_bottom)
            {
                ang = 315;
            }
            if(player.x < x)
            {
                ang = 135;
                if(player.bbox_bottom > bbox_bottom)
                {
                    ang = 225;
                }
            }
            var knockX = lengthdir_x(knockBackSpeed,ang),
                knockY = lengthdir_y(knockBackSpeed,ang);
            scr_DamagePlayer(damage,knockBack,knockX,knockY,damageImmuneTime);
        }
    }
}
#endregion

if(setOldPoses > 0)
{
	for(var i = array_length(oldPosX)-1; i > 0; i--)
	{
		oldPosX[i] = oldPosX[i-1];
		oldPosY[i] = oldPosY[i-1];
	}
	oldPosX[0] = x;
	oldPosY[0] = y;
	setOldPoses = 2;
}

if(dead && !deathPersistant)
{
    if(deathType == 0) // default death
    {
        part_particles_create(obj_Particles.partSystemA,x,y,obj_Particles.npcDeath[0],1);
        audio_stop_sound(snd_KillNPC);
        audio_play_sound(snd_KillNPC,0,false);
    }
    if(deathType == 1) // large enemy death (e.g. space pirate)
    {
        var d = instance_create_layer(x,y,layer_get_id("NPCs"),obj_NPC_DeathAnim);
        d.dethType = 1;
        d.width = abs(bbox_right-bbox_left);
        d.height = abs(bbox_bottom-bbox_top);
    }
    if(deathType == 2) // screw attack/speed booster death
    {
        var d = instance_create_layer(x,y,layer_get_id("NPCs"),obj_NPC_DeathAnim);
        d.dethType = 2;
        audio_stop_sound(snd_InstaKillNPC);
        audio_play_sound(snd_InstaKillNPC,0,false);
    }

    if(part_emitter_exists(obj_Particles.partSystemA,death1Emit))
    {
        part_emitter_destroy(obj_Particles.partSystemA,death1Emit);
    }
    instance_destroy();
}