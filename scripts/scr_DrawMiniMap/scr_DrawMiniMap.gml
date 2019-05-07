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
/*if(global.mapArea != noone)
{
    if(!instance_exists(obj_Transition) || obj_Transition.transitionComplete)
    {
        currentMap = global.mapArea;
        samusMapX = (scr_floor(obj_Samus.x/320) + global.rmMapPosX) * 8;
        samusMapY = (scr_floor(obj_Samus.y/320) + global.rmMapPosY) * 8;
    }
        
    draw_sprite_part_ext(currentMap,0,samusMapX-16,samusMapY-8,40,24,mapX,mapY,1,1,c_white,1);
}*/
    
draw_set_color(c_white);
draw_set_alpha(hudMapFlashAlpha);
draw_rectangle(mapX+16,mapY+8,mapX+23,mapY+15,false);
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