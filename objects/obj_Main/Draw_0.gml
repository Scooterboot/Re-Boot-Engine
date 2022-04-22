/// @description Draw black outside room & Debug (when enabled)

#region Draw black outside room
var camX = camera_get_view_x(view_camera[0]),
	camY = camera_get_view_y(view_camera[0]),
	camW = global.resWidth,
	camH = global.resHeight;

if (camX < 0 || camX+camW > room_width ||
	camY < 0 || camY+camH > room_height)
{
	draw_set_alpha(1)
	draw_set_color(c_black);
	
	var x1 = room_width,
		x2 = camX+camW;
	if(camX < 0)
	{
		x1 = camX;
		x2 = 0;
	}
	draw_rectangle(x1,camY-2,x2-1,camY+camH+2,false);
	
	var y1 = room_height,
		y2 = camY+camH;
	if(camY < 0)
	{
		y1 = camY;
		y2 = 0;
	}
	draw_rectangle(camX-2,y1,camX+camW+2,y2-1,false);
	
	draw_set_color(c_white);
}
#endregion

#region Debug
var debug = false;//true;
if(debug)
{
    if(instance_exists(obj_Tile))
    {
        obj_Tile.visible = true;
    }
    if(instance_exists(obj_Slope))
    {
        obj_Slope.visible = true;
    }
    if(instance_exists(obj_Platform))
    {
        obj_Platform.visible = true;
    }
    if(instance_exists(obj_Door))
    {
        obj_Door.visible = true;
    }
    with(obj_Player)
    {
        draw_set_color(c_red);
        draw_set_alpha(0.75);
        
        //draw_rectangle(x+6*dir,y+11,x+19*dir,y+24,0);
        //draw_rectangle(x+6*dir,y-5,x+19*dir,y+8,0);
        //draw_rectangle(x+6*dir,y-21,x+19*dir,y-8,0);
        //draw_rectangle(x+6*dir,y-37,x+19*dir,y-24,0);
        
        //draw_rectangle(scr_round(bbox_left),scr_round(bbox_top),scr_round(bbox_right),scr_round(bbox_bottom),0);
		draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,0);
		
		draw_set_color(c_fuchsia);
		if(instance_exists(obj_Projectile))
		{
			for(var i = 0; i < instance_number(obj_Projectile); i++)
			{
				with(instance_find(obj_Projectile,i))
				{
					if(sprite_width > sprite_height)
			        {
			            var numw = abs(bbox_right - bbox_left),
			                numd = clamp(abs(point_distance(x,y,xstart,ystart))/sprite_width,0,1);
			            for(var j = 0; j < max((sprite_width/numw)*numd,1); j++)
			            {
			                if(j > 0)
			                {
			                    var xw = x-lengthdir_x(numw*j,direction),
			                        yw = y-lengthdir_y(numw*j,direction);
			                    var bleft = bbox_left-x+xw,
									btop = bbox_top-y+yw,
									bright = bbox_right-x+xw,
									bbottom = bbox_bottom-y+yw;
								draw_rectangle(scr_round(bleft),scr_round(btop),scr_round(bright),scr_round(bbottom),0);
			                }
			            }
			        }
					draw_rectangle(scr_round(bbox_left),scr_round(bbox_top),scr_round(bbox_right),scr_round(bbox_bottom),0);
				}
			}
		}
        
        draw_set_color(c_white);
        draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
        //draw_set_font(fnt_Menu2);
		draw_set_font(fnt_GUI);
		
		var xx = camera_get_view_x(view_camera[0]),
			yy = camera_get_view_y(view_camera[0]),
			marginX = 10,
			marginY = 10;
        draw_text(xx+marginX,yy+30+marginY,"state: "+string(state));
        draw_text(xx+marginX,yy+30+marginY*2,"stateFrame: "+string(stateFrame));
        draw_text(xx+marginX,yy+30+marginY*3,"lastState: "+string(lastState));
        draw_text(xx+marginX,yy+30+marginY*4,"velX: "+string(velX));
        draw_text(xx+marginX,yy+30+marginY*5,"velY: "+string(velY));
        draw_text(xx+marginX,yy+30+marginY*6,"fVelX: "+string(fVelX));
        draw_text(xx+marginX,yy+30+marginY*7,"fVelY: "+string(fVelY));
        draw_text(xx+marginX,yy+30+marginY*8,"X pos: "+string(x));
        draw_text(xx+marginX,yy+30+marginY*9,"Y pos: "+string(y));
		
       /* draw_text(xx+10,yy+130,"obj_Camera.y: "+string(obj_Camera.y));
        draw_text(xx+10,yy+140,"camera[0] y: "+string(camera_get_view_y(view_camera[0])));
		
		draw_text(xx+10,yy+150,"speedBoost: "+string(speedBoost));
        draw_text(xx+10,yy+160,"speedCounter: "+string(speedCounter));
        draw_text(xx+10,yy+170,"speedBoostWJCounter: "+string(speedBoostWJCounter));*/
		
		/*for(var i = 0; i < ds_list_size(global.openHatchList); i++)
		{
			draw_text(xx+10,yy+40+10*i,global.openHatchList[| i]);
		}*/
    }
	
	with(obj_NPC)
	{
		draw_set_color(c_red);
        draw_set_alpha(0.75);
        
        //draw_rectangle(scr_round(bbox_left),scr_round(bbox_top),scr_round(bbox_right),scr_round(bbox_bottom),0);
		draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,0);
		
		draw_set_color(c_white);
        draw_set_alpha(1);
	}

	show_debug_message("delta_time: "+string(delta_time));
}

if(instance_exists(obj_Player) && obj_Player.godmode)
{
	draw_set_color(c_white);
    draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fnt_GUI);
	draw_text(camera_get_view_x(view_camera[0])+7,camera_get_view_y(view_camera[0])+30,"godmode enabled");
}

#endregion