
event_perform_object(obj_Platform,ev_create,0);

function IsValidEntity(entity)
{
	return (entity != tempIgnoredEnt && entity != ignoredEntity && entity.CanPlatformCollide() && array_contains(entity.platforms, object_index));
}
