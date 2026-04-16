
surface_set_target(obj_Display.surfUI);
bm_set_one();

if(debug == 1)
{
	with(obj_Player)
	{
		draw_set_color(c_white);
        draw_set_alpha(1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_font(fnt_GUI_Small);
		
		var xx = 0,
			yy = 32,
			marginX = 8,
			marginY = 8;
		xx += marginX;
		yy += marginY;
        draw_text(xx,yy,"state: "+obj_Debug.stateText[state]);
		yy += marginY;
        draw_text(xx,yy,"animState: "+obj_Debug.animStateText[animState]);
		yy += marginY;
        draw_text(xx,yy,"moveState: "+obj_Debug.moveStateText[moveState]);
		yy += marginY;
        draw_text(xx,yy,"vel (x.y): "+string(velX)+" x "+string(velY));
		yy += marginY;
        draw_text(xx,yy,"fVel (x.y): "+string(fVelX)+" x "+string(fVelY));
		yy += marginY;
        draw_text(xx,yy,"pos diff (x.y): "+string(position.X-oldPosition.X)+" x "+string(position.Y-oldPosition.Y));
		yy += marginY;
        draw_text(xx,yy,"real pos (x.y): "+string(x) + " x "+string(y));
		yy += marginY;
        draw_text(xx,yy,"position (x.y): "+string(position.X) + " x "+string(position.Y));
		yy += marginY;
        draw_text(xx,yy,"jump: "+string(jump));
		yy += marginY;
        draw_text(xx,yy,"climbIndex: "+string(climbIndex));
		yy += marginY;
		
		if(item[Item.SpeedBooster])
		{
			draw_text(xx,yy,"speedCounter: "+string(speedCounter));
			yy += marginY;
			
			var num = speedCounter;
			if(((cSprint || global.autoSprint) && speedBuffer > 0) || speedCounter > 0)
			{
				num += 1;
			}
			var sbStr = " "+string(speedBuffer)+" ";
			if(speedBuffer == speedBufferMax-1)
			{
				sbStr = "-"+string(speedBuffer)+"-";
			}
	        draw_text(xx,yy,"speedBuffer: "+sbStr+ " : " +string(speedBufferCounter) + "/" + string(speedBufferCounterMax[num]));
			yy += marginY;
			draw_text(xx,yy,"speedBoostWJCounter: "+string(speedBoostWJCounter));
			yy += marginY;
		}
		yy += marginY;
		
        draw_text(xx,yy,"colEdge: "+obj_Debug.edgeText[colEdge]);
		yy += marginY;
		if(spiderBall)
		{
	        draw_text(xx,yy,"spiderEdge: "+string(obj_Debug.edgeText[spiderEdge]));
			yy += marginY;
	        draw_text(xx,yy,"prevSpiderEdge: "+string(obj_Debug.edgeText[prevSpiderEdge]));
			yy += marginY;
	        draw_text(xx,yy,"spiderSpeed: "+string(spiderSpeed));
			yy += marginY;
		}
		yy += marginY;
		
		if(state == State.Grapple)
		{
			draw_text(xx,yy,"grapAngle: "+string(grapAngle));
			yy += marginY;
			draw_text(xx,yy,"grappleDist: "+string(grappleDist));
			yy += marginY;
			draw_text(xx,yy,"grappleReelVel: "+string(grappleReelVel));
			yy += marginY;
		}
		if(state == State.GravGrapple)
		{
			draw_text(xx,yy,"gravGrapAngle: "+string(gravGrapAngle));
			yy += marginY;
			draw_text(xx,yy,"gravGrapAngleVel: "+string(gravGrapAngleVel));
			yy += marginY;
			draw_text(xx,yy,"gravGrapDist: "+string(gravGrapDist));
			yy += marginY;
			draw_text(xx,yy,"gravGrapReelVel: "+string(gravGrapReelVel));
			yy += marginY;
		}
		
		/*for(var i = 0; i < ds_list_size(global.openHatchList); i++)
		{
			draw_text(xx+10,yy+40+10*i,global.openHatchList[| i]);
		}*/
	}
}
if(debug > 0)
{
	var xx = 0,//camera_get_view_x(view_camera[0]),
		yy = 0;//camera_get_view_y(view_camera[0]);
	
	var dbStr = "debug mode";
	if(instance_exists(obj_Player) && obj_Player.godmode)
	{
		dbStr += " : godmode enabled";
	}
	draw_set_color(c_white);
    draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fnt_Menu);
	draw_text(xx+37,yy+30,dbStr);
	
	var spStr = "";
	
	if(instance_exists(obj_Player) && obj_Player.item[Item.SpeedBooster])
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
			
			spStr += "   sbc: "+string(speedCounter);
		}
		
		draw_text(xx+80,yy+20,spStr);
	}
	
	draw_set_halign(fa_right);
	draw_text(xx+global.resWidth-10,yy+40,"fps_real: "+string(fps_real));
	draw_text(xx+global.resWidth-10,yy+50,"fps: "+string(fps));
	
	//show_debug_message("delta_time: "+string(delta_time));
}

surface_reset_target();