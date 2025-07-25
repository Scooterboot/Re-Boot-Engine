///@desc A visually visible container for placing elements in it.
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
function LuiPanel(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiPanel") : LuiBase() constructor {
	
	self.name = name;
	self.pos_x = x;
	self.pos_y = y;
	self.width = width;
	self.height = height;
	initElement();
	
	self.draw = function() {
		//Base
		if !is_undefined(self.style.sprite_panel) {
			var _blend_color = self.style.color_main;
			if self.deactivated {
				_blend_color = merge_colour(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_panel, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
		}
		//Border
		if !is_undefined(self.style.sprite_panel_border) {
			draw_sprite_stretched_ext(self.style.sprite_panel_border, 0, self.x, self.y, self.width, self.height, self.style.color_border, 1);
		}
	}
}