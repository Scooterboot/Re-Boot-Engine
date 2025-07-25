///@desc This item displays the specified sprite with certain settings but works like a button.
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
///@arg {Asset.GMSprite} sprite
///@arg {Real} subimg
///@arg {Real} color
///@arg {Real} alpha
///@arg {Bool} maintain_aspect
///@arg {Function} callback
function LuiSpriteButton(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiSpriteButton", sprite, subimg = 0, color = c_white, alpha = 1, maintain_aspect = true, callback = undefined) : LuiBase() constructor {
	
	self.name = name;
	self.pos_x = x;
	self.pos_y = y;
	self.width = width;
	self.height = height;
	initElement();
	setCallback(callback);
	
	self.value = sprite;
	self.sprite = sprite;
	self.subimg = subimg;
	self.alpha = alpha;
	self.color_blend = color;
	
	self.sprite_real_width = sprite_get_width(self.sprite);
	self.sprite_real_height = sprite_get_height(self.sprite);
	self.maintain_aspect = maintain_aspect;
	self.aspect = self.sprite_real_width / self.sprite_real_height;
	
	self.is_pressed = false;
	
	///@desc Set blend color for sprite
	static setColorBlend = function(color_blend) {
		self.color_blend = color_blend;
	}
	
	self.draw = function() {
		//Calculate fit size
		var _width = self.width;
		var _height = self.height;
		if self.maintain_aspect {
			if _width / self.aspect <= self.height  {
				_height = _width / self.aspect;
			} else {
				_width = _height * self.aspect;
			}
		}
		//Get blend color
		var _blend_color = self.color_blend;
		if !self.deactivated {
			if self.mouseHover() {
				_blend_color = merge_colour(_blend_color, self.style.color_hover, 0.5);
				if self.is_pressed {
					_blend_color = merge_colour(_blend_color, c_black, 0.5);
				}
			}
		} else {
			_blend_color = merge_colour(_blend_color, c_black, 0.5);
		}
		//Draw sprite button
		var _sprite_render_function = self.style.sprite_render_function ?? draw_sprite_stretched_ext;
		_sprite_render_function(self.sprite, self.subimg, 
									floor(self.x + self.width/2 - _width/2), 
									floor(self.y + self.height/2 - _height/2), 
									_width, _height, 
									_blend_color, self.alpha);
	}
	
	self.onMouseLeftPressed = function() {
		self.is_pressed = true;
	}
	
	self.onMouseLeftReleased = function() {
		if self.is_pressed {
			self.is_pressed = false;
			self.callback();
			if self.style.sound_click != undefined audio_play_sound(self.style.sound_click, 1, false);
		}
	}
	
	self.onMouseLeave = function() {
		self.is_pressed = false;
	}
}