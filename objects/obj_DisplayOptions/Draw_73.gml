/// @description Draw

var xx = camera_get_view_x(view_camera[0]),
	yy = camera_get_view_y(view_camera[0]),
	ww = global.resWidth,
	hh = global.resHeight,
	alpha = min(screenFade,obj_PauseMenu.pauseFade);

draw_sprite_tiled_ext(bg_Menu2,0,scr_round(xx),scr_round(yy),1,1,c_white,alpha);

var space = 16;

draw_set_font(GUIFont);
draw_set_color(c_white);
draw_set_alpha(alpha);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var oX = scr_round(xx + (ww/2) - 96),
	oY = scr_round(yy + (hh/2) - 96);

var dest = space*(optionPos+1);
var scrollYDest = clamp(-dest,-(array_length_1d(option)-1)*space,-4*space);
var rate = max(abs(scrollYDest - scrollY)*0.25, 1);
if(scrollY > scrollYDest)
{
	scrollY = max(scrollY - rate,scrollYDest);
}
else
{
	scrollY = min(scrollY + rate,scrollYDest);
}
oY = scr_round(yy + (hh/2) + scrollY);

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

var yOff = 0;
for(var i = 0; i < array_length_1d(option); i++)
{
	if(i == 0 || i == 4 || i == 6)
	{
		yOff += space;
		
		var str = header[0];
		if(i == 4)
		{
			str = header[1];
		}
		if(i == 6)
		{
			str = header[2];
		}
		var sh = string_height(str),
		col = make_color_rgb(72,168,56);
		
		var oYY = oY + (space*i) + yOff;

		gpu_set_blendmode(bm_add);
		draw_rectangle_colour(oX - 2,oYY - space - 1,oX + 192,oYY - space + sh,col,c_black,c_black,col,false);
		gpu_set_blendmode(bm_normal);
		draw_set_color(c_black);
		draw_text(oX + 1,oYY - space + 1,str);
		draw_set_color(c_white);
		draw_text(oX,oYY - space,str);
	}
	if(i == array_length_1d(option)-1)
	{
		yOff += space/2;
	}
	
	oYY = oY + (space*i) + yOff;
	
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
		var cOpt = "";
		if(i == 1)
		{
			cOpt = currentOptionName[i,(currentOption[i] > 0)];
		}
		else
		{
			cOpt = currentOptionName[i,currentOption[i]];
		}
		
		scr_DrawOptionText(oX+192-string_width(cOpt),oYY,cOpt,c_white,alpha,string_width(cOpt),bC,bA);
		
		bW = 185 - string_width(cOpt);
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