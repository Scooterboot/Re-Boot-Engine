/// @description 
event_inherited();

if(surface_exists(kraidSurf))
{
	surface_free(kraidSurf);
}
if(surface_exists(palSurface))
{
	surface_free(palSurface);
}
for(var i = 0; i < array_length(Bones); i++)
{
	Bones[i].Clean();
}
for(var i = 0; i < array_length(Limbs); i++)
{
	Limbs[i].Clean();
}