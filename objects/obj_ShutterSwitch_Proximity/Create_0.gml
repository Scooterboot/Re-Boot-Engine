/// @description 
event_inherited();
lhc_activate();

sizeX = 112;
sizeY = 112;
shape = "rectangle"; // "rectangle", "circle"
lineOfSight = true;
stayClosed = true;//false;

shutterID = 0;

playerDetected = false;

image_index = 0;
image_speed = 0;

function GetGates()
{
	var gates = array_create(0),
		gnum = 0;
	
	var num = instance_number(obj_ShutterGate);
	for(var i = 0; i < num; i++)
	{
		var sGate = instance_find(obj_ShutterGate,i);
		if(instance_exists(sGate) && sGate.shutterID == shutterID)
		{
			gates[gnum] = sGate;
			gnum++;
		}
	}
	return gates;
}
function Toggle(_override)
{
	var sGates = GetGates();
	for(var i = 0; i < array_length(sGates); i++)
	{
		sGates[i].Toggle(_override);
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
				var sGates = GetGates();
				var gflag = false;
				for(var j = 0; j < array_length(sGates); j++)
				{
					if(block == sGates[j].mBlock)
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