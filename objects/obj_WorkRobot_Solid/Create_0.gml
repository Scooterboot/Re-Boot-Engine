/// @description 
event_inherited();

creator = noone;

for(var i = 0; i < 9; i++)
{
	var type = obj_MovingTile;
	var xscale = 0.5,
		yscale = 0.5;
	if(i >= 3)
	{
		xscale = 1.5;
	}
	if(i == 8)
	{
		yscale = 15/16;
	}
	if(i == 0 || i == 2)
	{
		type = obj_MovingSlope_4th;
		xscale = 1;
		yscale = 1;
		if(i == 0 || i == 7)
		{
			xscale = -1;
		}
	}
	
	var offx = -sprite_xoffset,
		offy = -sprite_yoffset;
	switch(i)
	{
		case 0:
		{
			offx += 8;
			break;
		}
		case 1:
		{
			offx += 8;
			break;
		}
		case 2:
		{
			offx += 16;
			break;
		}
		case 3:
		{
			offy += 8;
			break;
		}
		case 4:
		{
			offy += 16;
			break;
		}
		case 5:
		{
			offy += 24;
			break;
		}
		case 6:
		{
			offy += 32;
			break;
		}
		
		case 7:
		{
			offy += 40;
			break;
		}
		case 8:
		{
			offy += 48;
			break;
		}
	}
	
	mBlocks[i] = instance_create_layer(x+offx,y+offy,layer_get_id("Collision"),type);
	mBlocks[i].image_xscale = xscale;
	mBlocks[i].image_yscale = yscale;
	mBlocks[i].canGrip = false;
	mBlockOffX[i] = offx;
	mBlockOffY[i] = offy;
	
	mBlockOffX_default[i] = offx;
}