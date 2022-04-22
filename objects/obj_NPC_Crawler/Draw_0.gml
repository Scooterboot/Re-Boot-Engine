/// @description debug
event_inherited();

var debug = false;
if(debug)
{
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_font(fnt_GUI_Small2);
		
	draw_text(x,bbox_bottom+10,"edge: "+string(edgeText[edge]));
	layer = layer_get_id("Collision");
}
