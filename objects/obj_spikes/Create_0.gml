/// @description Initialize
event_perform_object(obj_Breakable,ev_create,0);

snd = noone;
respawnTime = 0;
asset_remove_tags(object_get_name(object_index),"ISolid",asset_object);

damage = 16;
knockBack = 10;//5;
knockBackSpeed = 5;//7;
damageInvFrames = 60;

frame = 0;
frameCounter = 0;
frameSeq = array(2,3,4,3);

image_speed = 0;