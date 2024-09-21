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
	draw_rectangle(x1,camY-2,x2-1,camY+camH+2,false);
	
	var y1 = camY,
		y2 = 0;
	draw_rectangle(camX-2,y1,camX+camW+2,y2-1,false);
	
	draw_set_color(c_white);
}
if (camX+camW > room_width || camY+camH > room_height)
{
	draw_set_alpha(1);
	draw_set_color(c_black);
	
	var x1 = room_width,
		x2 = camX+camW;
	draw_rectangle(x1,camY-2,x2-1,camY+camH+2,false);
	
	var y1 = room_height,
		y2 = camY+camH;
	draw_rectangle(camX-2,y1,camX+camW+2,y2-1,false);
	
	draw_set_color(c_white);
}

#endregion

#region Distortion shader

if(!surface_exists(surfDistort))
{
	surfDistort = surface_create(camW,camH);
}
else
{
	surface_resize(surfDistort,camW,camH);
	
	surface_set_target(surfDistort);
	draw_clear_alpha(make_color_rgb(127,127,255),1);
	
	gpu_set_colorwriteenable(1,1,1,0);
	with(obj_Distort)
	{
		DrawDistort(-camX,-camY);
	}
	gpu_set_colorwriteenable(1,1,1,1);
	
	surface_reset_target();
}

if(!surface_exists(finalAppSurface))
{
	finalAppSurface = surface_create(camW,camH);
}
else
{
	surface_resize(finalAppSurface,camW,camH);
	
	surface_set_target(finalAppSurface);
	draw_clear_alpha(c_black,0);
	
	gpu_set_blendenable(false);
	draw_surface_ext(application_surface,0,0,1,1,0,c_white,1);
	gpu_set_blendenable(true);
	
	surface_reset_target();
}

shader_set(shd_Distortion);

var tex = surface_get_texture(surfDistort);

texture_set_stage(distortStage,tex);
gpu_set_texfilter_ext(distortStage, false);

var texel_x = texture_get_texel_width(tex);
var texel_y = texture_get_texel_height(tex);
shader_set_uniform_f(distortTexel, texel_x, texel_y);

draw_surface_ext(finalAppSurface,camX,camY,1,1,0,c_white,1);

shader_reset();

#endregion

#region Debug

if(keyboard_check_pressed(vk_divide))
{
	//debug = !debug;
	debug = scr_wrap(debug+1,0,4);
}

if(debug == 1)
{
	for(var i = 0; i < room_width; i += global.rmMapSize)
	{
		for(var j = 0; j < room_height; j += global.rmMapSize)
		{
			if(i+global.rmMapPixX+global.rmMapSize <= room_width && j+global.rmMapPixY+global.rmMapSize <= room_height)
			{
				draw_set_color(c_white);
				draw_set_alpha(0.33);
			
				draw_rectangle(i+global.rmMapPixX, j+global.rmMapPixY, i+global.rmMapPixX+global.rmMapSize-1, j+global.rmMapPixY+global.rmMapSize-1, true);
			
				draw_set_alpha(1);
			}
		}
	}
	
	with(obj_NPC)
	{
		draw_set_color(c_red);
        draw_set_alpha(0.75);
        
		if(mask_index != sprite_index && sprite_exists(mask_index))
		{
			gpu_set_fog(true,c_red,0,0);
			draw_sprite_ext(mask_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,0.75);
			gpu_set_fog(false,0,0,0);
		}
		else
		{
	        draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
		}
		
		draw_set_color(c_white);
        draw_set_alpha(1);
	}
	
	with(obj_Liquid)
	{
		if(_SurfWidth() > 0 && _SurfHeight() > 0)
		{
			draw_set_color(c_white);
	        draw_set_alpha(0.5);
		
			var pos = SurfPos();
			draw_rectangle(pos.X+1,pos.Y+1,pos.X+SurfWidth()-2,pos.Y+SurfHeight()-2,true);
        
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
			draw_rectangle(x-sizeX,y-sizeY,x+sizeX-1,y+sizeY-1,true);
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
	
	if(instance_exists(obj_Projectile))
	{
		with(obj_Projectile)
		{
			draw_set_color(c_fuchsia);
			draw_set_alpha(0.75);
			
			if(projLength > 0)
			{
				var numw = max(abs(bb_right() - bb_left()),1),
			        numd = clamp(point_distance(x,y,xstart,ystart),1,projLength);
				for(var j = numw; j < numd; j += numw)
				{
					var xw = x-lengthdir_x(j,direction),
						yw = y-lengthdir_y(j,direction);
					
					if(mask_index != sprite_index && sprite_exists(mask_index))
					{
						gpu_set_fog(true,c_fuchsia,0,0);
						draw_sprite_ext(mask_index,0,xw,yw,image_xscale,image_yscale,image_angle,c_white,0.75);
						gpu_set_fog(false,0,0,0);
					}
					else
					{
					    var bleft = bb_left(xw),
							btop = bb_top(yw),
							bright = bb_right(xw),
							bbottom = bb_bottom(yw);
						draw_rectangle(bleft,btop,bright,bbottom,0);
					}
				}
			}
			
			if(mask_index != sprite_index && sprite_exists(mask_index))
			{
				gpu_set_fog(true,c_fuchsia,0,0);
				draw_sprite_ext(mask_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,0.75);
				gpu_set_fog(false,0,0,0);
			}
			else
			{
				draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
			}
		}
	}
	
    with(obj_Player)
    {
		//pal_swap_set(palShader,palIndex,palIndex2,palDif,false);
		//DrawPlayer(x,y,rotation,0.5);
		//shader_reset();
		
        draw_set_color(c_aqua);
        draw_set_alpha(0.75);
        
        //draw_rectangle(x+6*dir,y+11,x+19*dir,y+24,0);
        //draw_rectangle(x+6*dir,y-5,x+19*dir,y+8,0);
        //draw_rectangle(x+6*dir,y-21,x+19*dir,y-8,0);
        //draw_rectangle(x+6*dir,y-37,x+19*dir,y-24,0);
        
        draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
        
        draw_set_color(c_white);
        draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_font(fnt_GUI);
		
		var xx = camera_get_view_x(view_camera[0]),
			yy = camera_get_view_y(view_camera[0]),
			marginX = 10,
			marginY = 10;
        draw_text(xx+marginX,yy+30+marginY,"state: "+obj_Display.stateText[state]);
        draw_text(xx+marginX,yy+30+marginY*2,"stateFrame: "+obj_Display.stateText[stateFrame]);
        draw_text(xx+marginX,yy+30+marginY*3,"lastState: "+obj_Display.stateText[lastState]);
        draw_text(xx+marginX,yy+30+marginY*4,"vel (x.y): "+string(velX)+" x "+string(velY));
        draw_text(xx+marginX,yy+30+marginY*5,"fVel (x.y): "+string(fVelX)+" x "+string(fVelY));
        draw_text(xx+marginX,yy+30+marginY*6,"pos diff (x.y): "+string(position.X-oldPosition.X)+" x "+string(position.Y-oldPosition.Y));
        //draw_text(xx+marginX,yy+30+marginY*7,"climbIndex: "+string(climbIndex));
        draw_text(xx+marginX,yy+30+marginY*8,"real pos (x.y): "+string(x) + " x "+string(y));
        draw_text(xx+marginX,yy+30+marginY*9,"position (x.y): "+string(position.X) + " x "+string(position.Y));
		
		
		draw_text(xx+marginX,yy+30+marginY*11,"speedCounter: "+string(speedCounter));
		
		var num = speedCounter;
		if(((cDash || global.autoDash) && speedBuffer > 0) || speedCounter > 0)
		{
			num += 1;
		}
		var sbStr = string(speedBuffer);
		/*if(speedBuffer == speedBufferMax-2 && speedBufferCounter >= speedBufferCounterMax[num]-3 && speedBufferCounter < speedBufferCounterMax[num]-1)
		{
			sbStr = "-"+sbStr+"-";
			if(speedBufferCounter >= speedBufferCounterMax[num]-2)
			{
				sbStr = "-"+sbStr+"-";
			}
		}*/
		if(speedBuffer == speedBufferMax-1)
		{
			sbStr = "-"+sbStr+"-";
		}
        draw_text(xx+marginX,yy+30+marginY*12,"speedBuffer: "+sbStr+ " : " +string(speedBufferCounter) + "/" + string(speedBufferCounterMax[num]));
		
        //draw_text(xx+marginX,yy+30+marginY*10,"cam centerX: "+string(obj_Camera.x+global.resWidth/2));
        //draw_text(xx+marginX,yy+30+marginY*11,"cam centerY: "+string(obj_Camera.y+global.resHeight/2));
        //draw_text(xx+marginX,yy+30+marginY*13,"torsoR: "+sprite_get_name(torsoR)+" | torsoL: "+sprite_get_name(torsoL));
        //draw_text(xx+marginX,yy+30+marginY*13,"bodyFrame: "+string(bodyFrame));
		
        draw_text(xx+marginX,yy+30+marginY*14,"colEdge: "+obj_Display.edgeText[colEdge]);
        draw_text(xx+marginX,yy+30+marginY*15,"spiderEdge: "+string(obj_Display.edgeText[spiderEdge]));
        draw_text(xx+marginX,yy+30+marginY*16,"prevSpiderEdge: "+string(obj_Display.edgeText[prevSpiderEdge]));
        draw_text(xx+marginX,yy+30+marginY*17,"spiderSpeed: "+string(spiderSpeed));
		
		draw_text(xx+marginX,yy+30+marginY*19,"speedBoostWJCounter: "+string(speedBoostWJCounter));
		
		/*for(var i = 0; i < ds_list_size(global.openHatchList); i++)
		{
			draw_text(xx+10,yy+40+10*i,global.openHatchList[| i]);
		}*/
		
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
		var xx = x + (global.resWidth/2),
			yy = y + (global.resHeight/2);
		
		draw_set_color(c_white);
        draw_set_alpha(0.5);
		
		draw_rectangle(xx-camLimit_Right,yy-camLimit_Bottom,xx-camLimit_Left-1,yy-camLimit_Top-1, true);
		draw_rectangle(scr_round(playerX),scr_round(playerY),scr_round(playerX)-1,scr_round(playerY)-1,true);
		
		draw_set_alpha(1);
	}
}
if(debug == 2)
{
	draw_surface_ext(surfDistort,camX,camY,1,1,0,c_white,1);
	
	with(obj_Tile)
	{
		if(object_is_ancestor(object_index,obj_Breakable))
		{
			draw_sprite_ext(sprite_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,1);
		}
		else if(mask_index != sprite_index && sprite_exists(mask_index))
		{
			draw_sprite_ext(mask_index,0,x,y,image_xscale,image_yscale,image_angle,c_white,0.75);
		}
		else if(!visible)
		{
			draw_self();
		}
	}
	
	with(obj_Player)
    {
		draw_set_color(c_aqua);
        draw_set_alpha(0.75);
        
		draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
        
        draw_set_color(c_white);
        draw_set_alpha(1);
	}
}

if(debug > 0)
{
	var xx = camera_get_view_x(view_camera[0]),
		yy = camera_get_view_y(view_camera[0]);
	
	var dbStr = "debug mode";
	if(instance_exists(obj_Player) && obj_Player.godmode)
	{
		dbStr += " : godmode enabled";
	}
	draw_set_color(c_white);
    draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fnt_Menu2);
	draw_text(xx+37,yy+30,dbStr);
	
	var spStr = "";
	
	if(instance_exists(obj_Player) && obj_Player.boots[Boots.SpeedBoost])
	{
		with(obj_Player)
		{
			for(var i = 0; i < speedBufferMax; i++)
			{
				if(i < speedBufferMax-1)
				{
					if(speedBuffer == i)
					{
						spStr += "+";
					}
					else
					{
						spStr += "-";
					}
				}
				else
				{
					if(speedBuffer == i)
					{
						spStr += "+";
					}
					else
					{
						spStr += "X";
					}
				}
			}
			
			spStr += "   spc: "+string(speedCounter);
		}
		
		draw_text(xx+80,yy+20,spStr);
	}
	
	draw_set_halign(fa_right);
	draw_text(xx+camW-10,yy+40,"fps_real: "+string(fps_real));
	draw_text(xx+camW-10,yy+50,"fps: "+string(fps));
	
	//show_debug_message("delta_time: "+string(delta_time));
}

#endregion
