/*function scr_DrawMiniMap()
{
	// HUD Minimap
	var vX = camera_get_view_x(view_camera[0]),
		vY = camera_get_view_y(view_camera[0]),
		vW = global.resWidth;
	
	var msSize = global.mapSquareSize;

	var mapX = floor(vX+vW-2-(msSize*5)),
	    mapY = floor(vY+2),
		mapWidth = msSize*5,
		mapHeight = msSize*3,
		mapDifX = msSize*2,
		mapDifY = msSize;
	
	if(global.rmMapArea != noone)
	{
		draw_set_color(c_black);
		draw_set_alpha(0.25);
		var xx = mapX-1,
		    yy = mapY-1,
		    ww = mapWidth + 1,
		    hh = mapHeight + 1;
		draw_rectangle(xx,yy,ww+xx,hh+yy,false);
		draw_set_color(c_white);
		draw_set_alpha(1);
		
		currentMap = global.rmMapArea;
		playerMapX = obj_Map.playerMapX * msSize;
		playerMapY = obj_Map.playerMapY * msSize;
		
		//obj_Map.DrawMap(currentMap, mapX,mapY, playerMapX-mapDifX+pMapOffsetX,playerMapY-mapDifY+pMapOffsetY, mapWidth,mapHeight, true,0.75);
		obj_Map.PrepareMapSurf(currentMap, playerMapX-mapDifX+pMapOffsetX,playerMapY-mapDifY+pMapOffsetY, mapWidth,mapHeight, true,0.75);
		obj_Map.DrawMap(mapX,mapY, playerMapX-mapDifX+pMapOffsetX,playerMapY-mapDifY+pMapOffsetY);
		
		if(pMapOffsetX > 0)
		{
			pMapOffsetX = max((pMapOffsetX - 0.75)*0.9,0);
		}
		if(pMapOffsetX < 0)
		{
			pMapOffsetX = min((pMapOffsetX + 0.75)*0.9,0);
		}
		if(pMapOffsetY > 0)
		{
			pMapOffsetY = max((pMapOffsetY - 0.75)*0.9,0);
		}
		if(pMapOffsetY < 0)
		{
			pMapOffsetY = min((pMapOffsetY + 0.75)*0.9,0);
		}
	}
	else
	{
		pMapOffsetX = 0;
		pMapOffsetY = 0;
		
		draw_sprite_ext(sprt_UI_HMapBase,0,mapX,mapY,1,1,0,c_white,0.5);
	}
    
	draw_set_color(c_white);
	draw_set_alpha(hudMapFlashAlpha);
	var rectX = mapX+mapDifX,//-pMapOffsetX,
		rectY = mapY+mapDifY;//-pMapOffsetY;
	draw_rectangle(rectX,rectY,rectX+msSize-1,rectY+msSize-1,false);
	draw_set_alpha(1);
    
	if(hudMapFlashAlpha <= 0)
	{
	    hudMapFlashNum = 1;
	}
	if(hudMapFlashAlpha >= 1 || (global.gamePaused))
	{
	    hudMapFlashNum = -1;
	}
	hudMapFlashAlpha = clamp(hudMapFlashAlpha + (0.1*hudMapFlashNum),0,1);
}
*/