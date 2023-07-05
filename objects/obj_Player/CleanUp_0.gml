/// @description 

event_inherited();

if(surface_exists(playerSurf))
{
    surface_free(playerSurf);
}
if(surface_exists(playerSurf2))
{
    surface_free(playerSurf2);
}

array_fill(mbTrailPosX, noone);
array_fill(mbTrailPosY, noone);
array_fill(mbTrailDir, noone);

if(surface_exists(mbTrailSurface))
{
    surface_free(mbTrailSurface);
}

part_emitter_destroy(obj_Particles.partSystemA,chargeEmit);