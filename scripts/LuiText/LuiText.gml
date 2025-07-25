///@desc Just a text.
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
///@arg {String} text
function LuiText(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiText", text = "sample text", scale_to_fit = false) : LuiBase() constructor {
	
	self.name = name;
	self.value = text;
	self.pos_x = x;
	self.pos_y = y;
	self.width = width;
	self.height = height;
	initElement();
	
	self.text_halign = fa_left;
	self.text_valign = fa_middle;
	self.scale_to_fit = scale_to_fit;
	
	self.onCreate = function() {
		if !is_undefined(self.style.font_default) {
			draw_set_font(self.style.font_default);
		}
		self.min_width = self.auto_width == true ? string_width(self.value) : self.width;
		self.height = self.auto_height == true ? max(self.min_height, string_height(self.value)) : self.height;
	}
	
	///@desc Set horizontal aligment of text.
	static setTextHalign = function(halign) {
		self.text_halign = halign;
		return self;
	}
	
	///@desc Set vertical aligment of text.
	static setTextValign = function(valign) {
		self.text_valign = valign;
		return self;
	}
	
	self.draw = function() {
		//Set font properties
		if !is_undefined(self.style.font_default) {
			draw_set_font(self.style.font_default);
		}
		if !self.deactivated {
			draw_set_color(self.style.color_font);
		} else {
			draw_set_color(merge_colour(self.style.color_font, c_black, 0.5));
		}
		draw_set_alpha(1);
		draw_set_halign(self.text_halign);
		draw_set_valign(self.text_valign);
		//Calculate right text align
		var _txt_x = 0;
		var _txt_y = 0;
		switch(self.text_halign) {
			case fa_left: 
				_txt_x = self.x;
			break;
			case fa_center:
				_txt_x = self.x + self.width / 2;
			break;
			case fa_right: 
				_txt_x = self.x + self.width;
			break;
		}
		switch(self.text_valign) {
			case fa_top: 
				_txt_y = self.y;
			break;
			case fa_middle:
				_txt_y = self.y + self.height / 2;
			break;
			case fa_bottom: 
				_txt_y = self.y + self.height;
			break;
		}
		//Draw text
		if self.value != "" {
			if !self.scale_to_fit {
				self._luiDrawTextCutoff(_txt_x, _txt_y, self.value, self.width);
			} else {
				var _text = self.value;
				var _xscale = self.width / string_width(_text);
				var _yscale = self.height / string_height(_text);
				var _scale = min(_xscale, _yscale);
				draw_text_transformed(_txt_x, _txt_y, _text, _scale, _scale, 0);
			}
		}
	}
}