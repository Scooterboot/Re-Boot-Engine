///@desc A progress bar/loading/filling anything.
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
///@arg {Real} value_min
///@arg {Real} value_max
///@arg {Bool} show_value
///@arg {Real} value
///@arg {Real} rounding
function LuiProgressBar(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiProgressBar", value_min = 0, value_max = 100, show_value = true, value = 0, rounding = 0) : LuiBase() constructor {
	
	self.name = name;
	self.pos_x = x;
	self.pos_y = y;
	self.width = width;
	self.height = height;
	initElement();
	
	self.value = value;
	self.value_min = min(value_min, value_max);
	self.value_max = max(value_min, value_max);
	self.rounding = rounding;
	self.show_value = show_value;
	
	///@ignore
	static _calcValue = function(value) {
		if self.rounding > 0 {
			return round(value / (self.rounding)) * (self.rounding);
		} else {
			return value;
		}
	}
	
	///@desc Sets the rounding rule for the value (0 - no rounding, 0.1 - round to tenths...).
	static setRounding = function(rounding) {
		self.rounding = rounding;
		return self;
	}
	
	self.draw = function() {
		//Base
		if !is_undefined(self.style.sprite_progress_bar) {
			var _blend_color = merge_color(self.style.color_progress_bar, c_black, 0.1);
			if self.deactivated {
				_blend_color = merge_colour(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_progress_bar, 0, self.x, self.y, width, height, _blend_color, 1);
		}
		//Bar value
		if !is_undefined(self.style.sprite_progress_bar_value) {
			var _bar_value = Range(self.value, self.value_min, self.value_max, 0, 1);
			var _blend_color = self.style.color_progress_bar_value;
			if self.deactivated {
				_blend_color = merge_colour(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_progress_bar_value, 0, self.x, self.y, width * _bar_value, height, _blend_color, 1);
		}
		//Border
		if !is_undefined(self.style.sprite_progress_bar_border) {
			draw_sprite_stretched_ext(self.style.sprite_progress_bar_border, 0, self.x, self.y, width, height, self.style.color_progress_bar_border, 1);
		}
		
		//Text value
		if self.show_value {
			if !is_undefined(self.style.font_default) draw_set_font(self.style.font_default);
			if !self.deactivated {
				draw_set_color(self.style.color_font);
			} else {
				draw_set_color(merge_colour(self.style.color_font, c_black, 0.5));
			}
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_text(self.x + self.width div 2, self.y + self.height div 2, _calcValue(self.value));
		}
	}
}