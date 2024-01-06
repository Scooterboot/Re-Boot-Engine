/// @description 
event_inherited();
lhc_activate();

sizeX = 120;
sizeY = 120;
shape = "rectangle"; // "rectangle", "circle"
lineOfSight = true;
stayClosed = true;//false;

shutterID = 0;

playerDetected = false;

frame = 2;
frameCounter = 0;
image_index = frame;
image_speed = 0;
frameFlicker = false;

init = false;

gates = array_create(0);

function Toggle(_override)
{
	for(var i = 0; i < array_length(gates); i++)
	{
		gates[i].Toggle(_override);
	}
}

blockList = ds_list_create();
function GetPlayer()
{
	var player = collision_rectangle(x-sizeX,y-sizeY,x+sizeX,y+sizeY,obj_Player,false,true);
	if(string_contains(shape,"circle"))
	{
		player = collision_ellipse(x-sizeX,y-sizeY,x+sizeX,y+sizeY,obj_Player,false,true);
	}
	
	if(!lineOfSight)
	{
		return player;
	}
	
	if(instance_exists(player))
	{
		var colFlag = false;
		
		var center = player.Center();
		var num = collision_line_list(center.X,center.Y,x,y,all,true,true,blockList,true);
		for(var i = 0; i < num; i++)
		{
			if(instance_exists(blockList[| i]) && asset_has_any_tag(blockList[| i].object_index,player.solids,asset_object))
			{
				var block = blockList[| i];
				var gflag = false;
				for(var j = 0; j < array_length(gates); j++)
				{
					if(block == gates[j].mBlock)
					{
						gflag = true;
						break;
					}
				}
				if(!gflag)
				{
					colFlag = true;
					break;
				}
			}
		}
		ds_list_clear(blockList);
		
		if(!colFlag)
		{
			return player;
		}
	}
	return noone;
}