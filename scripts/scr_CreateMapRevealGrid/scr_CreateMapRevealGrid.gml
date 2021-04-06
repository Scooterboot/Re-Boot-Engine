/// @description scr_CreateMapRevealGrid
/// @param mapSprt
function scr_CreateMapRevealGrid(argument0) {
	var mapSprt = argument0;
	var grid = ds_grid_create(scr_floor(sprite_get_width(mapSprt)/8),scr_floor(sprite_get_height(mapSprt)/8));
	ds_grid_clear(grid,false);
	return grid;


}
