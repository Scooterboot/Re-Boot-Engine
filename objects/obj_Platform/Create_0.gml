/// @description 

xRayHide = false;

event_perform_object(obj_MovingTile, ev_create, 0);

function IsValidEntity(entity)
{
	return (entity != tempIgnoredEnt && entity != ignoredEntity && entity.CanPlatformCollide() && array_contains_ext(entity.platforms, ColType_Platform, false));
}

function IsEntity_Top(entity)
{
	var this = id;
	with(entity)
	{
		return (self.bb_bottom() <= this.bbox_top && (place_meeting(x,y+1,this) || place_meeting(position.X,position.Y+1,this)));
	}
	return (entity.bb_bottom() <= bbox_top && place_meeting(x,y-1,entity));
}
function IsEntity_Bottom(entity) { return false; }
function IsEntity_Left(entity) { return false; }
function IsEntity_Right(entity) { return false; }

function EntityPush_X(entity)
{
	return (entity.bb_bottom() <= bbox_top);
}
function EntityPush_Y(entity)
{
	return (entity.bb_bottom() <= bbox_top);
}
avoidClipX = false;
