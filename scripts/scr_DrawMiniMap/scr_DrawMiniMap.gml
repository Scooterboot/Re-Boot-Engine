function scr_DrawMiniMap() {
	// HUD Minimap
	var vX = camera_get_view_x(view_camera[0]),
		vY = camera_get_view_y(view_camera[0]),
		vW = global.resWidth;

	var col = c_black, alpha = 0.4;

	var mapX = floor(vX+vW-42),
	    mapY = floor(vY+2);
    
	draw_set_color(col);
	draw_set_alpha(alpha);
	var xx = mapX-1,
	    yy = mapY-1,
	    ww = 41,
	    hh = 25;
	draw_rectangle(xx,yy,ww+xx,hh+yy,false);
	
	draw_set_color(c_white);
	draw_set_alpha(1);
    
	draw_sprite_ext(sprt_HMapBase,0,mapX,mapY,1,1,0,c_white,1);
	if(global.rmMapSprt != noone)
	{
		//if(!instance_exists(obj_Transition) || obj_Transition.transitionComplete)
		//{
		    currentMap = global.rmMapSprt;
			//playerMapX = (scr_floor(x/global.rmMapSize) + global.rmMapX) * 8;
			//playerMapY = (scr_floor(y/global.rmMapSize) + global.rmMapY) * 8;
			playerMapX = obj_Map.playerMapX * 8;
			playerMapY = obj_Map.playerMapY * 8;
			
			if(instance_exists(obj_MainMenu))
			{
				prevPlayerMapX = playerMapX;
				prevPlayerMapY = playerMapY;
			}
			
			if(playerMapX != prevPlayerMapX)
			{
				//pMapOffsetX = -8*sign(playerMapX-prevPlayerMapX);
			}
			if(playerMapY != prevPlayerMapY)
			{
				//pMapOffsetY = -8*sign(playerMapY-prevPlayerMapY);
			}
			
			prevPlayerMapX = playerMapX;
			prevPlayerMapY = playerMapY;
		//}
		obj_Map.DrawMap(currentMap,mapX,mapY,playerMapX-16+pMapOffsetX,playerMapY-8+pMapOffsetY,40,24);
		
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
    
	draw_set_color(c_white);
	draw_set_alpha(hudMapFlashAlpha);
	draw_rectangle(mapX+16-pMapOffsetX,mapY+8-pMapOffsetY,mapX+23-pMapOffsetX,mapY+15-pMapOffsetY,false);
	draw_set_alpha(1);
    
	if(hudMapFlashAlpha <= 0)
	{
	    hudMapFlashNum = 1;
	}
	if(hudMapFlashAlpha >= 1 || (global.gamePaused))// && !instance_exists(obj_Transition)))
	{
	    hudMapFlashNum = -1;
	}
	hudMapFlashAlpha = clamp(hudMapFlashAlpha + (0.1*hudMapFlashNum),0,1);


}
