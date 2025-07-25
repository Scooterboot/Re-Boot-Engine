/// @description 
//event_inherited();

rot = 0;

//posX = x;
//posY = y;
for(var i = 0; i < 12; i++)
{
	var type = obj_MovingTile;
	var xscale = 1,
		yscale = 1;
	if(i >= 8)
	{
		type = obj_MovingSlope;
		if(i >= 10)
		{
			xscale = -1;
			yscale = -1;
		}
	}
	
	var offx = 0,
		offy = 0;
	switch(i)
	{
		case 1:
		{
			offx = 16;
			offy = 0;
			break;
		}
		case 2:
		{
			offx = 0;
			offy = 16;
			break;
		}
		case 3:
		{
			offx = 16;
			offy = 16;
			xscale = 2;
			yscale = 2;
			break;
		}
		case 4:
		{
			offx = 32;
			offy = 48;
			break;
		}
		case 5:
		{
			offx = 48;
			offy = 32;
			xscale = 2;
			yscale = 2;
			break;
		}
		case 6:
		{
			offx = 80;
			offy = 32;
			break;
		}
		case 7:
		{
			offx = 80;
			offy = 48;
			break;
		}
		
		case 8:
		{
			offx = 32;
			offy = 0;
			break;
		}
		case 9:
		{
			offx = 48;
			offy = 16;
			break;
		}
		case 10:
		{
			offx = 16;
			offy = 48;
			break;
		}
		case 11:
		{
			offx = 32;
			offy = 64;
			break;
		}
	}
	
	blocks[i] = instance_create_layer(x+offx,y+offy,layer_get_id("Collision"),type);
	blocks[i].image_xscale = xscale;
	blocks[i].image_yscale = yscale;
	blockOffX[i] = offx;
	blockOffY[i] = offy;
}