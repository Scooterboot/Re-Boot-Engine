/// @description Initialize

image_speed = 0;

back = instance_create_layer(x,y,"NPCs",obj_SaveStation_Back);

beginSave = 0;
saving = 0;
maxSave = 170;//180;
saveCooldown = 0;

gameSavedText = "GAME SAVED";