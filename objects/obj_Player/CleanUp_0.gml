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

if(surface_exists(palSurface))
{
    surface_free(palSurface);
}
if(surface_exists(ballGlowSurf))
{
    surface_free(ballGlowSurf);
}
if(surface_exists(cFlashPalSurf))
{
    surface_free(cFlashPalSurf);
}

if(surface_exists(mbTrailSprtSurf))
{
    surface_free(mbTrailSprtSurf);
}
if(surface_exists(mbTrailSurface))
{
    surface_free(mbTrailSurface);
}

for(var i = ds_list_size(afterImageList)-1; i >= 0; i--)
{
	afterImageList[| i].Clear();
	ds_list_delete(afterImageList,i);
}
ds_list_destroy(afterImageList);

ds_list_destroy(reflecList);
