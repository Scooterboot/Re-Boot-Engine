/// @decription scr_SaveGame
/// @param savefile
/// @param overwriteX=x
/// @param overwriteY=y
function scr_SaveGame() {

	var file = argument[0];

	var xx = -1,
		yy = -1;

	if(argument_count > 1)
	{
		xx = argument[1];
	}
	if(argument_count > 2)
	{
		yy = argument[2];
	}

	var _root_list = ds_list_create();

	with (obj_Player)
	{
		var _map = ds_map_create();
		ds_list_add(_root_list,_map);
		ds_list_mark_as_map(_root_list,ds_list_size(_root_list)-1);
	
		if(xx == -1)
		{
			xx = x;
		}
		if(yy == -1)
		{
			yy = y;
		}
		ds_map_add(_map, "x", xx);
		ds_map_add(_map, "y", yy);
		ds_map_add(_map, "room", room_get_name(room));
	
		ds_map_add(_map, "energyMax", energyMax);
		ds_map_add(_map, "energy", energy);
		ds_map_add(_map, "missileMax", missileMax);
		ds_map_add(_map, "missileStat", missileStat);
		ds_map_add(_map, "superMissileMax", superMissileMax);
		ds_map_add(_map, "superMissileStat", superMissileStat);
		ds_map_add(_map, "powerBombMax", powerBombMax);
		ds_map_add(_map, "powerBombStat", powerBombStat);

		for(var i = 0; i < array_length(suit); i++)
		{
			ds_map_add(_map, "suit"+string(i), suit[i]);
		}
		for(var i = 0; i < array_length(hasSuit); i++)
		{
			ds_map_add(_map, "hasSuit"+string(i), hasSuit[i]);
		}
	
		for(var i = 0; i < array_length(boots); i++)
		{
			ds_map_add(_map, "boots"+string(i), boots[i]);
		}
		for(var i = 0; i < array_length(hasBoots); i++)
		{
			ds_map_add(_map, "hasBoots"+string(i), hasBoots[i]);
		}
	
		for(var i = 0; i < array_length(misc); i++)
		{
			ds_map_add(_map, "misc"+string(i), misc[i]);
		}
		for(var i = 0; i < array_length(hasMisc); i++)
		{
			ds_map_add(_map, "hasMisc"+string(i), hasMisc[i]);
		}
	
		for(var i = 0; i < array_length(beam); i++)
		{
			ds_map_add(_map, "beam"+string(i), beam[i]);
		}
		for(var i = 0; i < array_length(hasBeam); i++)
		{
			ds_map_add(_map, "hasBeam"+string(i), hasBeam[i]);
		}
	
		for(var i = 0; i < array_length(item); i++)
		{
			ds_map_add(_map, "item"+string(i), item[i]);
		}
		for(var i = 0; i < array_length(hasItem); i++)
		{
			ds_map_add(_map, "hasItem"+string(i), hasItem[i]);
		}
	}

	var _map_map = ds_map_create();
	ds_list_add(_root_list,_map_map);
	ds_list_mark_as_map(_root_list,ds_list_size(_root_list)-1);

	ds_map_add(_map_map,"mapReveal_Debug", ds_grid_write(global.mapReveal_Debug));

	var _worldFlags_map = ds_map_create();
	ds_list_add(_root_list,_worldFlags_map);
	ds_list_mark_as_map(_root_list,ds_list_size(_root_list)-1);

	ds_map_add(_worldFlags_map,"currentPlayTime",global.currentPlayTime);
	
	ds_map_add(_worldFlags_map,"openHatchList",ds_list_write(global.openHatchList));
	ds_map_add(_worldFlags_map,"collectedItemList",ds_list_write(global.collectedItemList));


	var _wrapper = ds_map_create();
	ds_map_add_list(_wrapper, "ROOT", _root_list);

	var _string = json_encode(_wrapper);

	scr_SaveStringToFile(scr_GetFileName(file), _string);

	ds_map_destroy(_wrapper);

	show_debug_message("Game file "+string(file)+" saved");


}
