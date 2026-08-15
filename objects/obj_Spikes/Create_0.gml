/// @description Initialize
event_perform_object(obj_Breakable,ev_create,0);
event_perform_object(obj_Entity,ev_create,0);

snd = noone;
respawnTime = 0;

damage = 16;
playerKnockBackDur = 10;
playerKnockBackSpd = 5;
playerInvFrames = 60;

bypassPlayerImmune[PlayerImmuneType.Dodge] = true;
bypassPlayerImmune[PlayerImmuneType.Boost] = true;
bypassPlayerImmune[PlayerImmuneType.Speed] = true;
bypassPlayerImmune[PlayerImmuneType.Spark] = false;
bypassPlayerImmune[PlayerImmuneType.Pseudo] = true;
bypassPlayerImmune[PlayerImmuneType.Screw] = true;
bypassPlayerImmune[PlayerImmuneType.Crystal] = false;

frame = 0;
frameCounter = 0;
frameSeq = [2,3,4,3];

image_speed = 0;
