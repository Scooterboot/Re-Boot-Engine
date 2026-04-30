/// @description Update Map Surfaces

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;

for(var k = array_length(global.mapArea)-1; k >= 0; k--)
{
	if(!global.mapArea[k].visited) continue;
	
	if(global.mapArea[k].updateSurf || !surface_exists(global.mapArea[k].surf))
	{
		var mapArea = global.mapArea[k],
			mapSprt = mapArea.sprt,
			mapGrid = mapArea.grid,
			gridWidth = ds_grid_width(mapGrid),
			gridHeight = ds_grid_height(mapGrid),
			stationUsed = mapArea.stationUsed;
		
		if(!surface_exists(mapArea.surf))
		{
			mapArea.surf = surface_create(sprite_get_width(mapSprt), sprite_get_height(mapSprt));
		}
		
		if(surface_exists(mapArea.surf))
		{
			surface_set_target(mapArea.surf);
			draw_clear_alpha(c_black,0);
			
			if(ds_exists(mapGrid,ds_type_grid))
			{
				if(stationUsed)
				{
					for(var i = 0; i < gridWidth; i++)
					{
						for(var j = 0; j < gridHeight; j++)
						{
							if(!mapGrid[# i,j])
							{
								draw_sprite_part_ext(mapSprt,1, i*msSizeW,j*msSizeH,msSizeW,msSizeH, i*msSizeW,j*msSizeH, 1,1,c_white,1);
							}
						}
					}
				}
				for(var i = 0; i < gridWidth; i++)
				{
					for(var j = 0; j < gridHeight; j++)
					{
						if(mapGrid[# i,j])
						{
							self.DrawMapTile(mapSprt,0, mapSprt,1, mapGrid,i,j,gridWidth,gridHeight, stationUsed);
						}
					}
				}
			}
			
			surface_reset_target();
		}
		
		mapArea.updateSurf = false;
	}
}