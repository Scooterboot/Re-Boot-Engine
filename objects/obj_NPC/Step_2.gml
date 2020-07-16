/// @description Death Types

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