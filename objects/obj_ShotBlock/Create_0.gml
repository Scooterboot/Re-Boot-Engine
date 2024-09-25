/// @description Initialize
event_inherited();

extSprt = sprt_ShotBlockExt;
/*function DrawBreakable(_x,_y,_index)
{
	for(var i = min(image_xscale,0); i < max(image_xscale,0); i++)
	{
	    for(var j = min(image_yscale,0); j < max(image_yscale,0); j++)
	    {
			var k = i,
				l = j;
			if(image_xscale < 0)
			{
				k = i+1;
			}
			if(image_yscale < 0)
			{
				l = j+1;
			}
			var bx = _x+lengthdir_x(16*k,image_angle)+lengthdir_y(-16*l,image_angle),
				by = _y+lengthdir_x(16*l,image_angle)+lengthdir_y(16*k,image_angle);
			
			var ind = _index;
			if(_index == image_index)
			{
				ind = 1;
				var xindex = (k != 0) + (abs(k) >= abs(image_xscale)-1),
					yindex = (l != 0) + (abs(l) >= abs(image_yscale)-1);
				if(abs(image_yscale) == 1)
				{
					if(abs(image_xscale) > 1)
					{
						ind = 2 + xindex;
					}
				}
				else if(abs(image_xscale) == 1)
				{
					ind = 5 + yindex;
				}
				else
				{
					ind = 8 + xindex + (3 * yindex);
				}
			}
			draw_sprite_ext(sprite_index,ind,bx,by,sign(image_xscale),sign(image_yscale),image_angle,c_white,1);
	    }
	}
}*/