/// @description 
event_inherited();

if(surface_exists(kraidSurf))
{
	surface_free(kraidSurf);
}
for(var i = 0; i < array_length(Bones); i++)
{
	Bones[i].Clean();
}
for(var i = 0; i < array_length(Limbs); i++)
{
	Limbs[i].Clean();
}