/// @description Free surface
event_inherited();

if(surface_exists(surf))
{
	surface_free(surf);
}