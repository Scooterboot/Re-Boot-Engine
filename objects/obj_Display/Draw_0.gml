/// @description Debug (when enabled) & black outside room

var camX = camera_get_view_x(view_camera[0]),
	camY = camera_get_view_y(view_camera[0]),
	camW = camera_get_view_width(view_camera[0]),
	camH = camera_get_view_height(view_camera[0]);

#region Draw black outside room

if (camX < 0 || camY < 0)
{
	draw_set_alpha(1);
	draw_set_color(c_black);
	
	var x1 = camX,
		x2 = 0;
	draw_rectangle(x1,camY-2,x2,camY+camH+2,false);
	
	var y1 = camY,
		y2 = 0;
	draw_rectangle(camX-2,y1,camX+camW+2,y2,false);
	
	draw_set_color(c_white);
}
if (camX+camW > room_width || camY+camH > room_height)
{
	draw_set_alpha(1);
	draw_set_color(c_black);
	
	var x1 = room_width,
		x2 = camX+camW;
	draw_rectangle(x1,camY-2,x2,camY+camH+2,false);
	
	var y1 = room_height,
		y2 = camY+camH;
	draw_rectangle(camX-2,y1,camX+camW+2,y2,false);
	
	draw_set_color(c_white);
}

#endregion

#region Debug

if(keyboard_check_pressed(vk_divide) || keyboard_check_pressed(vk_f1) || keyboard_check_pressed(vk_backtick))
{
	//debug = !debug;
	debug = scr_wrap(debug+1,0,3);
}

if(debug == 1)
{
	for(var i = 0; i < room_width; i += global.rmMapSizeW)
	{
		for(var j = 0; j < room_height; j += global.rmMapSizeH)
		{
			if(i+global.rmMapPixX+global.rmMapSizeW <= room_width && j+global.rmMapPixY+global.rmMapSizeH <= room_height)
			{
				draw_set_color(c_white);
				draw_set_alpha(0.33);
				
				//draw_rectangle(i+global.rmMapPixX, j+global.rmMapPixY, i+global.rmMapPixX+global.rmMapSizeW-1, j+global.rmMapPixY+global.rmMapSizeH-1, true);
				draw_rectangle_betterOutline(i+global.rmMapPixX, j+global.rmMapPixY, i+global.rmMapPixX+global.rmMapSizeW, j+global.rmMapPixY+global.rmMapSizeH);
				
				draw_set_alpha(1);
			}
		}
	}
	
	/*with(obj_Distort)
	{
		var surfX = (right < left) ? right : left,
			surfY = (bottom < top) ? bottom : top;
		draw_surface_ext(surf2, surfX, surfY, 1,1,0,c_white,image_alpha);
	}*/
	
	with(obj_Liquid)
	{
		if(_SurfWidth() > 0 && _SurfHeight() > 0)
		{
			draw_set_color(c_white);
	        draw_set_alpha(0.5);
		
			var pos = SurfPos();
			//draw_rectangle(pos.X+1,pos.Y+1,pos.X+SurfWidth()-2,pos.Y+SurfHeight()-2,true);
			draw_rectangle_betterOutline(pos.X,pos.Y,pos.X+SurfWidth(),pos.Y+SurfHeight());
        
	        draw_set_color(c_white);
	        draw_set_alpha(1);
		}
	}
	
    with(obj_Tile)
	{
		//if(!visible)
		//{
			if(object_is_ancestor(object_index,obj_Breakable))
			{
				//DrawBreakable(x,y,0);
				draw_sprite_ext(sprite_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,1);
			}
			else if(mask_index != sprite_index && sprite_exists(mask_index))
			{
				//gpu_set_fog(true,c_red,0,0);
				draw_sprite_ext(mask_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,0.75);
				//gpu_set_fog(false,0,0,0);
			}
			else if(!visible)
			{
				draw_self();
			}
		//}
	}
	with(obj_NPCTile)
	{
		if(!visible)
		{
			draw_self();
		}
	}
	with(obj_MovingTile)
	{
		if(!visible)
		{
			draw_self();
		}
	}
	with(obj_Platform)
	{
		if(!visible)
		{
			draw_self();
		}
	}
	with(obj_Door)
	{
		if(!visible)
		{
			draw_self();
		}
	}
	with(obj_Reflec)
	{
		var p1 = GetPoint1(),
			p2 = GetPoint2();
		draw_line(p1.X,p1.Y,p2.X,p2.Y);
		//draw_point(p1.X,p1.Y);
		//draw_point(p2.X,p2.Y);
	}
	with(obj_ShutterSwitch_Proximity)
	{
		var col = c_lime;
		if(playerDetected)
		{
			col = c_red;
		}
		draw_set_color(col);
		draw_set_alpha(0.5);
		if(string_contains(shape,"circle"))
		{
			draw_ellipse(x-sizeX,y-sizeY,x+sizeX-1,y+sizeY-1,true);
		}
		else
		{
			//draw_rectangle(x-sizeX,y-sizeY,x+sizeX-1,y+sizeY-1,true);
			draw_rectangle_betterOutline(x-sizeX,y-sizeY,x+sizeX,y+sizeY);
		}
		draw_set_color(c_white);
		
		var player = GetPlayer();
		if(instance_exists(player))
		{
			draw_line(player.Center().X,player.Center().Y,x,y);
		}
		draw_set_alpha(1);
	}
	
	with(obj_CamTile)
	{
		if(!visible)
		{
			draw_self();
		}
	}
	with(obj_CamTile_NonWScreen)
	{
		if(!visible)
		{
			draw_self();
		}
	}
	
	with(obj_Entity)
	{
		draw_set_color(c_white);
        draw_set_alpha(0.5);
        
		if(mask_index != sprite_index && sprite_exists(mask_index))
		{
			gpu_set_fog(true,c_aqua,0,0);
			draw_sprite_ext(mask_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,0.5);
			gpu_set_fog(false,0,0,0);
		}
		else
		{
	        //draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
			draw_rectangle_betterOutline(bb_left(),bb_top(),bb_right(),bb_bottom());
		}
		
		draw_set_color(c_white);
        draw_set_alpha(1);
	}
	with(obj_LifeBox)
	{
		draw_set_color(c_green);
        draw_set_alpha(0.5);
        
		if((!instance_exists(creator) || mask_index != creator.sprite_index) && sprite_exists(mask_index))
		{
			gpu_set_fog(true,c_green,0,0);
			draw_sprite_ext(mask_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,0.5);
			gpu_set_fog(false,0,0,0);
		}
		else
		{
	        draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
		}
		
		draw_set_color(c_white);
        draw_set_alpha(1);
	}
	with(obj_DamageBox)
	{
		var col = c_red;
		if(!hostile)
		{
			col = c_aqua;
		}
		draw_set_color(col);
        draw_set_alpha(0.5);
        
		if((!instance_exists(creator) || mask_index != creator.sprite_index) && sprite_exists(mask_index))
		{
			gpu_set_fog(true,col,0,0);
			draw_sprite_ext(mask_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,0.5);
			gpu_set_fog(false,0,0,0);
		}
		else
		{
	        draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
		}
		
		draw_set_color(c_white);
        draw_set_alpha(1);
	}
	
    with(obj_Player)
    {
		//pal_swap_set(palShader,palIndex,palIndex2,palDif,false);
		//DrawPlayer(x,y,rotation,0.5);
		//shader_reset();
		
        //draw_set_color(c_aqua);
        //draw_set_alpha(0.75);
        
        //draw_rectangle(x+6*dir,y+11,x+19*dir,y+24,0);
        //draw_rectangle(x+6*dir,y-5,x+19*dir,y+8,0);
        //draw_rectangle(x+6*dir,y-21,x+19*dir,y-8,0);
        //draw_rectangle(x+6*dir,y-37,x+19*dir,y-24,0);
        
        //draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
        
		draw_set_font(fnt_GUI);
		draw_set_color(c_white);
		draw_set_alpha(0.5);
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		var edgeAng = GetEdgeAngle(Edge.Bottom);
		if(entity_place_collide(0,2))
		{
			draw_text(x,y+10,string(edgeAng));
		}
		if(entity_place_collide(0,-2))
		{
			draw_set_halign(fa_center);
			draw_set_valign(fa_bottom);
			edgeAng = GetEdgeAngle(Edge.Top);
			draw_text(x,y-10,string(edgeAng));
		}
		if(entity_place_collide(2,0))
		{
			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);
			edgeAng = GetEdgeAngle(Edge.Right);
			draw_text(bb_right(),y,string(edgeAng));
		}
		if(entity_place_collide(-2,0))
		{
			draw_set_halign(fa_right);
			draw_set_valign(fa_middle);
			edgeAng = GetEdgeAngle(Edge.Left);
			draw_text(bb_left(),y,string(edgeAng));
		}
		draw_set_alpha(1);
    }
	
	with(obj_Camera)
	{
		var xx = x + (camWidth()/2),
			yy = y + (camHeight()/2);
		
		draw_set_color(c_white);
        draw_set_alpha(0.5);
		
		//draw_rectangle(scr_round(xx-camLimit_Right),scr_round(yy-camLimit_Bottom),scr_round(xx-camLimit_Left)-1,scr_round(yy-camLimit_Top)-1, true);
		//draw_rectangle(scr_round(playerX),scr_round(playerY),scr_round(playerX)-1,scr_round(playerY)-1,true);
		draw_rectangle_betterOutline(scr_round(xx-camLimit_Right),scr_round(yy-camLimit_Bottom),scr_round(xx-camLimit_Left),scr_round(yy-camLimit_Top));
		draw_rectangle_betterOutline(scr_round(playerX),scr_round(playerY),scr_round(playerX),scr_round(playerY));
		
		draw_set_alpha(1);
	}
}

#endregion
