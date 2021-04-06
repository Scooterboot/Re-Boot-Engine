/// @description scr_DrawOptionText(x,y,string,alpha,backWidth,backColor,backAlpha)
/// @param x
/// @param y
/// @param string
/// @param color
/// @param alpha
/// @param backWidth
/// @param backColor
/// @param backAlpha
function scr_DrawOptionText(xx, yy, str, col, alpha, bW, bC, bA) {

	draw_set_color(bC);
	draw_set_alpha(bA);

	draw_rectangle(xx-2,yy-1,xx+bW,yy+string_height(str),false);

	draw_set_alpha(alpha);

	draw_set_color(c_black);
	draw_text(xx+1,yy+1,str);
	draw_set_color(col);
	draw_text(xx,yy,str);
	draw_set_color(c_white);
	draw_set_alpha(1);
}
