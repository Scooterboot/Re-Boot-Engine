/// @description 
event_inherited();

state = 0;
// 0 = idle, 1 = rise, 2 = fly toward player

detectDelay = 0;

detect_Left = -64;
detect_Right = 64;
detect_Top = -64;
detect_Bottom = 0;

shape = "rectangle"; // "rectangle", "circle"
lineOfSight = true;

losCheckOffsetX = 0;
losCheckOffsetY = -10;

player = noone;

blockList = ds_list_create();
function GetPlayer()
{
	var _player = collision_rectangle(x+detect_Left,y+detect_Top,x+detect_Right,y+detect_Bottom,obj_Player,false,true);
	if(string_contains(shape,"circle"))
	{
		_player = collision_ellipse(x+detect_Left,y+detect_Top,x+detect_Right,y+detect_Bottom,obj_Player,false,true);
	}
	
	if(!lineOfSight)
	{
		return _player;
	}
	
	if(instance_exists(_player))
	{
		var colFlag = false;
		
		var center = _player.Center();
		var num = collision_line_list(center.X,center.Y,x+losCheckOffsetX,y+losCheckOffsetY,all,true,true,blockList,true);
		for(var i = 0; i < num; i++)
		{
			if(instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,_player.solids,asset_object))
			{
				colFlag = true;
				break;
			}
		}
		ds_list_clear(blockList);
		
		if(!colFlag)
		{
			return _player;
		}
	}
	return noone;
}