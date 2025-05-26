/// @description Initialize

event_inherited();

/*var colLayer = layer_get_id(layer_get_name("Collision"));
var tile = instance_create_layer(x,y-8,colLayer,obj_Tile);
tile.image_yscale = 2.5;
tile = instance_create_layer(x-8,y+1,colLayer,obj_Tile);
tile.image_xscale = 0.5;
tile.image_yscale = 0.5;
tile = instance_create_layer(x+16,y+1,colLayer,obj_Tile);
tile.image_xscale = 0.5;
tile.image_yscale = 0.5;

var slope = instance_create_layer(x,y-7,colLayer,obj_Slope_4th);
slope.image_xscale = -1;
slope = instance_create_layer(x+16,y-7,colLayer,obj_Slope_4th);
slope = instance_create_layer(x,y+15,colLayer,obj_Slope_4th);
slope.image_xscale = -1;
slope.image_yscale = -1;
slope = instance_create_layer(x+16,y+15,colLayer,obj_Slope_4th);
slope.image_yscale = -1;*/

activeDir = 0;
activeTime = 0;
activeTimeMax = 90;
soundPlayed = false;

frame = 0;
frameCounter = 0;

stationMessage = "";

Condition = function() {}
Interact = function() {}