/// @description UI surface clear
if(!surface_exists(surfUI))
{
	surfUI = surface_create(global.resWidth,global.resHeight);
}
if(surface_exists(surfUI))
{
	if(surface_get_width(surfUI) != global.resWidth || surface_get_height(surfUI) != global.resHeight)
	{
		surface_resize(surfUI,global.resWidth,global.resHeight);
	}
	surface_set_target(surfUI);
	draw_clear_alpha(c_black,0);
	surface_reset_target();
}


// debug
if(debug == 1)
{
	with(obj_Player)
	{
		surface_set_target(obj_Display.surfUI);
		
        draw_set_color(c_white);
        draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_font(fnt_GUI);
		
		var xx = 0,//camera_get_view_x(view_camera[0]),
			yy = 32,//camera_get_view_y(view_camera[0]),
			marginX = 8,
			marginY = 8;
        draw_text(xx+marginX,yy+marginY,"state: "+obj_Display.stateText[state]);
        draw_text(xx+marginX,yy+marginY*2,"stateFrame: "+obj_Display.stateText[stateFrame]);
        draw_text(xx+marginX,yy+marginY*3,"lastState: "+obj_Display.stateText[lastState]);
        draw_text(xx+marginX,yy+marginY*4,"vel (x.y): "+string(velX)+" x "+string(velY));
        draw_text(xx+marginX,yy+marginY*5,"fVel (x.y): "+string(fVelX)+" x "+string(fVelY));
        draw_text(xx+marginX,yy+marginY*6,"pos diff (x.y): "+string(position.X-oldPosition.X)+" x "+string(position.Y-oldPosition.Y));
        //draw_text(xx+marginX,yy+marginY*7,"climbIndex: "+string(climbIndex));
        draw_text(xx+marginX,yy+marginY*8,"real pos (x.y): "+string(x) + " x "+string(y));
        draw_text(xx+marginX,yy+marginY*9,"position (x.y): "+string(position.X) + " x "+string(position.Y));
		
		
		draw_text(xx+marginX,yy+marginY*11,"speedCounter: "+string(speedCounter));
		
		var num = speedCounter;
		if(((cSprint || global.autoSprint) && speedBuffer > 0) || speedCounter > 0)
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
        draw_text(xx+marginX,yy+marginY*12,"speedBuffer: "+sbStr+ " : " +string(speedBufferCounter) + "/" + string(speedBufferCounterMax[num]));
		
        //draw_text(xx+marginX,yy+marginY*10,"cam centerX: "+string(obj_Camera.x+global.resWidth/2));
        //draw_text(xx+marginX,yy+marginY*11,"cam centerY: "+string(obj_Camera.y+global.resHeight/2));
        //draw_text(xx+marginX,yy+marginY*13,"torsoR: "+sprite_get_name(torsoR)+" | torsoL: "+sprite_get_name(torsoL));
        //draw_text(xx+marginX,yy+marginY*13,"bodyFrame: "+string(bodyFrame));
		
        draw_text(xx+marginX,yy+marginY*14,"colEdge: "+obj_Display.edgeText[colEdge]);
        draw_text(xx+marginX,yy+marginY*15,"spiderEdge: "+string(obj_Display.edgeText[spiderEdge]));
        draw_text(xx+marginX,yy+marginY*16,"prevSpiderEdge: "+string(obj_Display.edgeText[prevSpiderEdge]));
        draw_text(xx+marginX,yy+marginY*17,"spiderSpeed: "+string(spiderSpeed));
		
		draw_text(xx+marginX,yy+marginY*19,"speedBoostWJCounter: "+string(speedBoostWJCounter));
		
		/*for(var i = 0; i < ds_list_size(global.openHatchList); i++)
		{
			draw_text(xx+10,yy+40+10*i,global.openHatchList[| i]);
		}*/
		
		surface_reset_target();
	}
}
if(debug > 0)
{
	var xx = 0,//camera_get_view_x(view_camera[0]),
		yy = 0;//camera_get_view_y(view_camera[0]);
	
	surface_set_target(surfUI);
	
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
	draw_text(xx+global.resWidth-10,yy+40,"fps_real: "+string(fps_real));
	draw_text(xx+global.resWidth-10,yy+50,"fps: "+string(fps));
	
	//show_debug_message("delta_time: "+string(delta_time));
	
	surface_reset_target();
}