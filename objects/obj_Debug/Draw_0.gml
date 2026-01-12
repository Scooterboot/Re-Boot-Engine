
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
	
	// this part may be a bit overkill for a simple debug overlay, but oh well
	if(!surface_exists(entityOutlineSurf)) { entityOutlineSurf = surface_create(1,1); }
	if(!surface_exists(entityOutlineSurf2)) { entityOutlineSurf2 = surface_create(1,1); }
	var this = id;
	with(obj_Entity)
	{
		draw_set_color(c_white);
        draw_set_alpha(0.5);
		
		if(mask_index != sprite_index && sprite_exists(mask_index))
		{
			var _sAdd = 6;
			var msk = mask_index,
				mskW = sprite_get_width(msk),
				mskH = sprite_get_height(msk),
				mskOffX = sprite_get_xoffset(msk),
				mskOffY = sprite_get_yoffset(msk);
			
			if(surface_exists(this.entityOutlineSurf))
			{
				surface_resize(this.entityOutlineSurf, mskW+_sAdd, mskH+_sAdd);
				surface_set_target(this.entityOutlineSurf);
				draw_clear_alpha(c_black,0);
				
				draw_sprite_ext(msk, 0, (_sAdd/2)+mskOffX, (_sAdd/2)+mskOffY, 1,1,0,c_black,1);
				
				surface_reset_target();
			}
			if(surface_exists(this.entityOutlineSurf2))
			{
				surface_resize(this.entityOutlineSurf2, mskW+_sAdd, mskH+_sAdd);
				surface_set_target(this.entityOutlineSurf2);
				draw_clear_alpha(c_black,0);
				
				if(surface_exists(this.entityOutlineSurf))
				{
					shader_set(shd_Outline);
					
					var outlineColor = shader_get_uniform(shd_Outline,"outlineColor");
					shader_set_uniform_f(outlineColor, 1,1,1,1 );
					
					var _ww = texture_get_texel_width(surface_get_texture(this.entityOutlineSurf2));
					var outlineW = shader_get_uniform(shd_Outline,"outlineW");
					shader_set_uniform_f(outlineW, _ww);
					
					var _hh = texture_get_texel_height(surface_get_texture(this.entityOutlineSurf2));
					var outlineH = shader_get_uniform(shd_Outline,"outlineH");
					shader_set_uniform_f(outlineH, _hh);
					
					draw_surface_ext(this.entityOutlineSurf,0,0,1,1,0,c_white,1);
					
					shader_reset();
				}
				
				surface_reset_target();
				
				var surfCos = dcos(image_angle),
					surfSin = dsin(image_angle),
					surfX = ((_sAdd/2)+mskOffX)*image_xscale,
					surfY = ((_sAdd/2)+mskOffY)*image_yscale;
				var surfFX = x - surfCos*surfX - surfSin*surfY,
					surfFY = y - surfCos*surfY + surfSin*surfX;
				
				bm_set_add();
				draw_surface_ext(this.entityOutlineSurf2, surfFX, surfFY, image_xscale,image_yscale,image_angle,c_white,0.5);
				bm_reset();
			}
		}
		else
		{
			//draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
			draw_rectangle_betterOutline(bbox_left, bbox_top, bbox_right, bbox_bottom);
		}
		draw_line(scr_round(bb_left()), scr_round(position.Y), scr_round(bb_right()), scr_round(position.Y));
		draw_line(scr_round(position.X), scr_round(bb_top()), scr_round(position.X), scr_round(bb_bottom()));
		
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
			//draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
			draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom,0);
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
			//draw_rectangle(bb_left(),bb_top(),bb_right(),bb_bottom(),0);
			draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom,0);
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

if(debug > 0)
{
	with(obj_GrappleTargetAssist)
	{
		var player = obj_Player;
		var pos = self.GetPlayerPos();
		var pX = pos.X, pY = pos.Y;
		
		draw_set_alpha(0.5);
		draw_set_color(c_gray);
		draw_line(pX,pY, pX+lengthdir_x(player.grappleMaxDist,shootDir),pY+lengthdir_y(player.grappleMaxDist,shootDir));
		draw_line(pX,pY, pX+lengthdir_x(player.grappleMaxDist,shootDir+assistRadius),pY+lengthdir_y(player.grappleMaxDist,shootDir+assistRadius));
		draw_line(pX,pY, pX+lengthdir_x(player.grappleMaxDist,shootDir-assistRadius),pY+lengthdir_y(player.grappleMaxDist,shootDir-assistRadius));
	
		if(is_struct(targetPoint))
		{
			draw_set_color(c_lime);
			draw_line(pX,pY, targetPoint.x,targetPoint.y);
		}
	
		if(obj_Debug.debug == 1)
		{
			draw_set_color(c_orange);
			for(var i = 0; i < ds_list_size(grapPoint_list); i++)
			{
				var gp = grapPoint_list[| i];
				draw_circle(gp.x-1,gp.y-1,4,false);
			}
		}
	
		draw_set_alpha(1);
		draw_set_color(c_white);
	}
}