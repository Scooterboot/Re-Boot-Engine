event_inherited();
image_speed = 0;
image_index = 1;

visible = true;
/*depth = 92;

tileLayer1 = 90;
tileLayer2 = 91;
if(tile_exists(tile_layer_find(tileLayer1,x,y)) || tile_exists(tile_layer_find(tileLayer2,x,y)))
{
    visible = false;
}*/

event_perform_object(obj_Breakable,ev_create,0);
extSprt = sprt_GrappleBlockExt;