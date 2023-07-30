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

for(var i = 0; i < ds_list_size(afterImageList); i++)
{
	afterImageList[| i].Clear();
	ds_list_delete(afterImageList,i);
}