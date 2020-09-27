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

draw_sprite_tiled_ext(bg_Menu2,0,scr_round(xx),scr_round(yy),1,1,c_white,alpha);

var space = 16;

draw_set_font(GUIFont);
draw_set_color(c_white);
draw_set_alpha(alpha);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var oX = scr_round(xx + (ww/2) - 96),
	oY = scr_round(yy + (hh/2) - 32);

var str = header,
	sh = string_height(str),
	col = make_color_rgb(72,168,56);

gpu_set_blendmode(bm_add);
draw_rectangle_colour(oX - 2,oY - space - 1,oX + 192,oY - space + sh,col,c_black,c_black,col,false);
gpu_set_blendmode(bm_normal);
draw_set_color(c_black);
draw_text(oX + 1,oY - space + 1,str);
draw_set_color(c_white);
draw_text(oX,oY - space,str);

var tcol = c_black,
	talph = 0.5*alpha,
	tcol2 = c_white,
	talph2 = 0.15*alpha;

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

for(var i = 0; i < array_length_1d(option); i++)
{
	var oYY = oY + (i*space);
	var bC = tcol,
		bA = talph;
	if(optionPos == i)
	{
		bC = tcol2;
		bA = talph2;
		
		draw_sprite_ext(sprt_SelectCursor,cursorFrame,oX-4,oYY+string_height(option[i])/2,1,1,0,c_white,alpha);
	}
	
	var bW = string_width(option[i]);
	if(i < array_length_1d(currentOption))
	{
		bW = 121;
		
		var bX = oX+128,
			bW2 = 64;
		draw_set_color(bC);
		draw_set_alpha(bA);
		draw_rectangle(bX-2,oYY-1,bX+bW2-1,oYY+sh,false);
		draw_set_color(make_color_rgb(26,108,0));
		draw_set_alpha(alpha);
		if(currentOption[i] > 0)
		{
			draw_rectangle(bX-1,oYY,bX+(bW2*currentOption[i])-2,oYY+sh-1,false);
		}
		draw_set_color(c_white);
		draw_set_halign(fa_middle);
		scr_DrawOptionText(bX+floor(bW2/2),oYY,string(floor(currentOption[i]*100))+"%",c_white,alpha,0,c_black,0);
		draw_set_halign(fa_left);
	}
	scr_DrawOptionText(oX,oYY,option[i],c_white,alpha,bW,bC,bA);
}

tipStrg = optionTip[optionPos];

if(tipStrg != "")
{
	draw_set_font(GUIFontSmall);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_bottom);
	var height = string_height_ext(tipStrg,9,ww);
	
	draw_set_alpha(alpha*0.75);
	draw_set_color(c_black);
	draw_rectangle(xx-32,yy+hh-height,xx+ww+31,yy+hh,false);
	draw_set_alpha(alpha);
	draw_set_color(c_white);
	
	var col2 = make_color_rgb(26,108,0);
	gpu_set_blendmode(bm_add);
	draw_rectangle_color(xx-32,yy+hh-height,xx+(ww/2)-1,yy+hh,c_black,col2,col2,c_black,false);
	draw_rectangle_color(xx+(ww/2),yy+hh-height,xx+ww+31,yy+hh,col2,c_black,c_black,col2,false);
	gpu_set_blendmode(bm_normal);
	
	draw_set_color(c_black);
	draw_text_ext(xx+(ww/2)+1,yy-1+hh+1,tipStrg,9,ww);
	draw_set_color(c_white);
	draw_text_ext(xx+(ww/2),yy-1+hh,tipStrg,9,ww);
	
	draw_set_font(GUIFont);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
draw_set_alpha(1);
draw_set_color(c_black);