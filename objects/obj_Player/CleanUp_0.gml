/// @description 

event_inherited();

if(surface_exists(playerSurf))
{
    surface_free(playerSurf);
}

ds_list_destroy(block_list);

array_fill(mbTrailPosX, noone);
array_fill(mbTrailPosY, noone);
array_fill(mbTrailDir, noone);

if(surface_exists(mbTrailSurface))
{
    surface_free(mbTrailSurface);
}

part_emitter_destroy(obj_Particles.partSystemA,chargeEmitA);
part_emitter_destroy(obj_Particles.partSystemB,chargeEmitB);