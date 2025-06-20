event_inherited();
image_speed = 0;
image_index = 1;

visible = true;

event_perform_object(obj_Breakable,ev_create,0);
extSprt = sprt_MagnetTrackBlockExt;

up = true;
down = true;
left = true;
right = true;

glowAlpha = 0;
glowNum = 1;
glowSprt = sprt_MagnetTrackBlockGlow;