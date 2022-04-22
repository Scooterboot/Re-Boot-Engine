/// @description Draw

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight,
	alpha = screenFade;

if(room != rm_MainMenu)
{
	alpha = min(screenFade,obj_PauseMenu.pauseFade);
}

if(surface_exists(surf))
{
	surface_resize(surf,global.resWidth,global.resHeight);
	surface_set_target(surf);
	draw_clear_alpha(c_black,1);

	//draw_sprite_tiled_ext(bg_Menu2,0,ww/2-global.ogResWidth/2,0,1,1,c_white,1);
	draw_sprite_ext(bg_Menu2,0,ww/2,hh/2,3,3,0,c_white,1);

	var space = 16;

	draw_set_font(fnt_GUI);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var oX = scr_round((ww/2) - 128),
		oY = scr_round((hh/2) - 32);

	var str = header,
		sh = string_height(str),
		col = make_color_rgb(72,168,56);

	gpu_set_blendmode(bm_add);
	draw_rectangle_colour(oX - 2,oY - space - 1,oX + 256,oY - space + sh,col,c_black,c_black,col,false);
	gpu_set_blendmode(bm_normal);
	draw_set_color(c_black);
	draw_text(oX + 1,oY - space + 1,str);
	draw_set_color(c_white);
	draw_text(oX,oY - space,str);

	var tcol = c_black,
		talph = 0.5,
		tcol2 = c_white,
		talph2 = 0.15;

	var tipStrg = "";

	cursorFrameCounter++;
	if(cursorFrameCounter > 5)
	{
		cursorFrame++;
		cursorFrameCounter = 0;
	}
	if(cursorFrame >= 4)
	{
		cursorFrame = 0;
	}

	for(var i = 0; i < array_length(option); i++)
	{
		var oYY = oY + (i*space);
		var bC = tcol,
			bA = talph,
			indent = 0;
		if(optionPos == i)
		{
			bC = tcol2;
			bA = talph2;
			indent = 4;
		
			draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX+indent-4,oYY+string_height(option[i])/2,1,1,0,c_white,1);
		}
	
		var bW = string_width(option[i]);
		if(i < array_length(currentOption))
		{
			bW = 153 - indent;
		
			var bX = oX+160,
				bW2 = 96;
			draw_set_color(bC);
			draw_set_alpha(bA);
			draw_rectangle(bX-2,oYY-1,bX+bW2-1,oYY+sh,false);
			draw_set_color(make_color_rgb(26,108,0));
			draw_set_alpha(1);
			if(currentOption[i] > 0)
			{
				draw_rectangle(bX-1,oYY,bX+(bW2*currentOption[i])-2,oYY+sh-1,false);
			}
			draw_set_color(c_white);
			draw_set_halign(fa_middle);
			scr_DrawOptionText(bX+floor(bW2/2),oYY,string(floor(currentOption[i]*100))+"%",c_white,1,0,c_black,0);
			draw_set_halign(fa_left);
		}
		scr_DrawOptionText(oX+indent,oYY,option[i],c_white,1,bW,bC,bA);
	}

	tipStrg = optionTip[optionPos];

	if(tipStrg != "")
	{
		draw_set_font(fnt_GUI_Small);
		draw_set_halign(fa_middle);
		draw_set_valign(fa_bottom);
		var height = string_height_ext(tipStrg,9,ww);
	
		draw_set_alpha(0.75);
		draw_set_color(c_black);
		draw_rectangle(-32,hh-height,ww+31,hh,false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	
		var col2 = make_color_rgb(26,108,0);
		gpu_set_blendmode(bm_add);
		draw_rectangle_color(-32,hh-height,(ww/2)-1,hh,c_black,col2,col2,c_black,false);
		draw_rectangle_color((ww/2),hh-height,ww+31,hh,col2,c_black,c_black,col2,false);
		gpu_set_blendmode(bm_normal);
	
		draw_set_color(c_black);
		draw_text_ext((ww/2)+1,hh,tipStrg,9,ww);
		draw_set_color(c_white);
		draw_text_ext((ww/2),hh-1,tipStrg,9,ww);
	
		draw_set_font(fnt_GUI);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
	draw_set_alpha(1);
	draw_set_color(c_black);
	
	var appSurfScale = 1;
	if(global.upscale == 7)
	{
		appSurfScale = 1/obj_Main.screenScale;
	}
	draw_surface_ext(application_surface,0,0,appSurfScale,appSurfScale,0,c_white,1-alpha);
	
	surface_reset_target();
	
	gpu_set_blendenable(false);
	draw_surface_ext(surf,scr_round(xx),scr_round(yy),1,1,0,c_white,1);
	gpu_set_blendenable(true);
}
else
{
	surf = surface_create(global.resWidth,global.resHeight);
}