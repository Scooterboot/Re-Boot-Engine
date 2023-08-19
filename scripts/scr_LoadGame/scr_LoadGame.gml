/// @decription scr_LoadGame
/// @param savefile
function scr_LoadGame()
{
	var file = argument[0];

	global.currentPlayFile = file;

	// destroy these just in case
	instance_destroy(obj_Player);
	instance_destroy(obj_Camera);
	if(instance_exists(obj_ScreenShaker))
	{
		obj_ScreenShaker.active = false;
	}

	if(file_exists(scr_GetFileName(file)))
	{
		try
		{
			var _wrapper = scr_LoadJSONFromFile(scr_GetFileName(file));
			var _list = _wrapper[? "ROOT"];
	
			var _map = _list[| 0];
		
			var rm = _map[? "room"];
			room_goto(asset_get_index(rm));
		
			with(instance_create_layer(_map[? "x"],_map[? "y"],"Player",obj_Player))
			{
				lhc_activate();
			
				energyMax = _map[? "energyMax"];
				energy = _map[? "energy"];
				missileMax = _map[? "missileMax"];
				missileStat = _map[? "missileStat"];
				superMissileMax = _map[? "superMissileMax"];
				superMissileStat = _map[? "superMissileStat"];
				powerBombMax = _map[? "powerBombMax"];
				powerBombStat = _map[? "powerBombStat"];

				for(var i = 0; i < array_length(suit); i++)
				{
					suit[i] = _map[? "suit"+string(i)];
				}
				for(var i = 0; i < array_length(hasSuit); i++)
				{
					hasSuit[i] = _map[? "hasSuit"+string(i)];
				}
	
				for(var i = 0; i < array_length(boots); i++)
				{
					boots[i] = _map[? "boots"+string(i)];
				}
				for(var i = 0; i < array_length(hasBoots); i++)
				{
					hasBoots[i] = _map[? "hasBoots"+string(i)];
				}
	
				for(var i = 0; i < array_length(misc); i++)
				{
					misc[i] = _map[? "misc"+string(i)];
				}
				for(var i = 0; i < array_length(hasMisc); i++)
				{
					hasMisc[i] = _map[? "hasMisc"+string(i)];
				}
	
				for(var i = 0; i < array_length(beam); i++)
				{
					beam[i] = _map[? "beam"+string(i)];
				}
				for(var i = 0; i < array_length(hasBeam); i++)
				{
					hasBeam[i] = _map[? "hasBeam"+string(i)];
				}
	
				for(var i = 0; i < array_length(item); i++)
				{
					item[i] = _map[? "item"+string(i)];
				}
				for(var i = 0; i < array_length(hasItem); i++)
				{
					//ds_map_add(_map, "hasItem"+string(i), hasItem[i]);
					hasItem[i] = _map[? "hasItem"+string(i)];
				}
			
				instance_create_layer(x-(global.resWidth/2),y-(global.resHeight/2),"Camera",obj_Camera);
			}
	
			var _map_map = _list[| 1];
			var dsWidth = ds_grid_width(global.mapReveal_Debug),
				dsHeight = ds_grid_height(global.mapReveal_Debug);
			ds_grid_clear(global.mapReveal_Debug,false);
			ds_grid_read(global.mapReveal_Debug, _map_map[? "mapReveal_Debug"]);
			ds_grid_resize(global.mapReveal_Debug,dsWidth,dsHeight);
	
			var _worldFlags_map = _list[| 2];
			global.currentPlayTime = _worldFlags_map[? "currentPlayTime"];
			ds_list_clear(global.openHatchList);
			ds_list_read(global.openHatchList, _worldFlags_map[? "openHatchList"]);
			ds_list_clear(global.collectedItemList);
			ds_list_read(global.collectedItemList, _worldFlags_map[? "collectedItemList"]);
			ds_list_clear(global.npcKillList);
			ds_list_read(global.npcKillList, _worldFlags_map[? "npcKillList"]);
	
	
			ds_map_destroy(_wrapper);
	
			show_debug_message("Game file "+string(file)+" loaded");
		}
		catch(_exception)
		{
			show_debug_message(_exception.message);
			show_debug_message(_exception.longMessage);
			show_debug_message(_exception.script);
			show_debug_message(_exception.stacktrace);
		}
		/*finally
		{
			room_goto(rm_debug01_Start);
			var sx = 80,
				sy = 694;
			instance_create_layer(sx,sy,"Player",obj_Player);
			instance_create_layer(sx-(global.resWidth/2),sy-(global.resHeight/2),"Camera",obj_Camera);
		}*/
	}
	else
	{
		room_goto(rm_debug01_Start);
		var sx = 80,
			sy = 694;
		//instance_create_layer(sx,sy,"Player",obj_Player);
		with(instance_create_layer(sx,sy,"Player",obj_Player))
		{
			lhc_activate();
		}
		instance_create_layer(sx-(global.resWidth/2),sy-(global.resHeight/2),"Camera",obj_Camera);
		
		//ds_grid_clear(global.mapReveal_Debug,false);
		ds_grid_destroy(global.mapReveal_Debug);
		global.mapReveal_Debug = obj_Map.CreateMapRevealGrid(sprt_Map_DebugRooms);
		global.currentPlayTime = 0;
		ds_list_clear(global.openHatchList);
		ds_list_clear(global.collectedItemList);
		ds_list_clear(global.npcKillList);
	}
}