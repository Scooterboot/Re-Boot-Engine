
alarm[0] = 1;

global.cullRegionLeft = 0;
global.cullRegionTop = 0;
global.cullRegionRight = 0;
global.cullRegionBottom = 0;
function WithinCullRegion(x1,y1,x2,y2)
{
	return rectangle_in_rectangle(x1,y1,x2,y2, global.cullRegionLeft,global.cullRegionTop,global.cullRegionRight,global.cullRegionBottom) > 0;
}
function PerformCull(_obj)
{
	with(_obj)
	{
		if(!obj_Culler.WithinCullRegion(bbox_left,bbox_top,bbox_right,bbox_bottom))
		{
			var cull = true;
			if(variable_instance_exists(id,"canBeCulled"))
			{
				cull = canBeCulled;
			}
			if(cull)
			{
				instance_deactivate_object(id);
			}
		}
	}
}

cullableObjects = [
obj_NPC,
obj_Tile,
obj_NPCTile,
obj_MovingTile,
obj_Platform,
obj_Spikes,
obj_Liquid,
obj_PressurePlate
];

function DisableObjs()
{
	for(var i = 0, len = array_length(cullableObjects); i < len; i++)
	{
		//instance_deactivate_object(cullableObjects[i]);
		self.PerformCull(cullableObjects[i]);
	}
	//instance_activate_object(obj_Player);
}
function EnableObjs()
{
	var cullX = global.cullRegionLeft,
		cullY = global.cullRegionTop,
		cullW = global.cullRegionRight-global.cullRegionLeft,
		cullH = global.cullRegionBottom-global.cullRegionTop;
	instance_activate_region(cullX, cullY, cullW, cullH, true);
}

function EnableSpecialObjs()
{
	with(obj_Entity)
	{
		var _bbL = bbox_left,
			_bbT = bbox_top,
			_bbR = bbox_right,
			_bbB = bbox_bottom;
		var _boxL = min(_bbL, _bbL+velX, _bbL+fVelX),
			_boxT = min(_bbT, _bbT+velY, _bbT+fVelY),
			_boxR = max(_bbR, _bbR+velX, _bbR+fVelY),
			_boxB = max(_bbB, _bbB+velY, _bbB+fVelY);
		
		var hpad = 16;
		var vpad = 16;
		var eX = _boxL - hpad,
			eY = _boxT - vpad,
			eW = (_boxR-_boxL) + hpad*2,
			eH = (_boxB-_boxT) + vpad*2;
		instance_activate_region(eX, eY, eW, eH, true);
	}
	
	with(obj_ShutterGate)
	{
		var pad = 16+sSpeed;
		var shLenX = lengthdir_x(shutterH+pad,image_angle-90),
			shLenY = lengthdir_y(shutterH+pad,image_angle-90);
		var shutL = min(bbox_left, bbox_left+shLenX),
			shutT = min(bbox_top, bbox_top+shLenY),
			shutR = max(bbox_right, bbox_right+shLenX),
			shutB = max(bbox_bottom, bbox_bottom+shLenY);
		
		var hpad = 8;
		var vpad = 8;
		var shX = shutL - hpad,
			shY = shutT - vpad,
			shW = (shutR-shutL) + hpad*2,
			shH = (shutB-shutT) + vpad*2;
		instance_activate_region(shX, shY, shW, shH, true);
	}
}

oldCamX = -1;
oldCamY = -1;