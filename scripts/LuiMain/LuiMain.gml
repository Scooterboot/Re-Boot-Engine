/// @desc Main UI container wich would be controll and render your UI.
function LuiMain() : LuiBase() constructor
{
	// Main variables
	self.name = "__lui_main_ui";
	self.width = display_get_gui_width();
	self.height = display_get_gui_height();
	self.ui_screen_surface = -1;
	self.update_ui_screen_surface = true;
	self.pre_draw_list = [];
	self.element_names = {};
	self.main_ui = self;
	self.element_in_focus = undefined;
	self.topmost_hovered_element = undefined;
	self.display_focused_element = false;
	
	// Init Flex
	self.flex_node = flexpanel_create_node({name: self.name, data: {}});
	flexpanel_node_style_set_width(self.flex_node, 100, flexpanel_unit.percent);
	flexpanel_node_style_set_height(self.flex_node, 100, flexpanel_unit.percent);
	var _data = flexpanel_node_get_data(self.flex_node);
	_data.element = self;
	self.needs_flex_update = true;
	
	// Init Screen grid
	self._screen_grid = {};
	for (var _x = 0, _width = ceil(display_get_gui_width() / LUI_GRID_SIZE); _x <= _width; ++_x)
	{
		for (var _y = 0, _height = ceil(display_get_gui_height() / LUI_GRID_SIZE); _y <= _height; ++_y)
		{
			var _key = string(_x) + "_" + string(_y);
			self._screen_grid[$ _key] = array_create(0);
		}
	}
	
	// Update
	self.base_update = method(self, update);
	self.update = function()
	{
		// Update all elements
		self.base_update();
			
		// Mouse position
		//var _mouse_x = device_mouse_x_to_gui(0);
		//var _mouse_y = device_mouse_y_to_gui(0);
		var _mouse_x = MousePos().X;
		var _mouse_y = MousePos().Y;
			
		// Mouse events
		if (_mouse_x >= 0 && _mouse_x <= self.width && _mouse_y >= 0 && _mouse_y <= self.height)
		{
			var _previous_hovered_element = self.topmost_hovered_element;
			self.topmost_hovered_element = self.getTopmostElement(_mouse_x, _mouse_y);
			if !is_undefined(_previous_hovered_element) && _previous_hovered_element != self.topmost_hovered_element
			{
				_previous_hovered_element.is_mouse_hovered = false;
				_previous_hovered_element.onMouseLeave();
				_previous_hovered_element.updateMainUiSurface();
			}
			
			if (!is_undefined(self.topmost_hovered_element) && !self.topmost_hovered_element.deactivated)
			{
				if self.topmost_hovered_element.is_mouse_hovered == false
				{
					self.topmost_hovered_element.is_mouse_hovered = true;
					self.topmost_hovered_element.onMouseEnter();
					self.topmost_hovered_element.updateMainUiSurface();
				}
				
				if (mouse_check_button(mb_left))
				{
					self.topmost_hovered_element.onMouseLeft();
					//self.updateMainUiSurface();
				}
				if (mouse_check_button_pressed(mb_left))
				{
					self.topmost_hovered_element.onMouseLeftPressed();
					// Set focus on element
					if self.element_in_focus != self.topmost_hovered_element
					{
						// Remove focus from previous element
						if !is_undefined(self.element_in_focus)
						{
							self.element_in_focus.removeFocus();
							self.element_in_focus = undefined;
						}
						self.topmost_hovered_element.setFocus();
						self.element_in_focus = self.topmost_hovered_element;
					}
					self.updateMainUiSurface();
				}
				if (mouse_check_button_released(mb_left))
				{
					self.topmost_hovered_element.onMouseLeftReleased();
					// Remove focus from element
					if !is_undefined(self.element_in_focus) && self.element_in_focus != self.topmost_hovered_element
					{
						self.element_in_focus.removeFocus();
						self.element_in_focus = undefined;
					}
					self.updateMainUiSurface();
				}
				if (mouse_wheel_down() || mouse_wheel_up())
				{
					self.topmost_hovered_element.onMouseWheel();
					self.updateMainUiSurface();
				}
			}
			else
			{
				// Remove focus from element
				if !is_undefined(self.element_in_focus)
				{
					if (mouse_check_button_pressed(mb_left))
					{
						self.element_in_focus.removeFocus();
						self.element_in_focus = undefined;
						self.updateMainUiSurface();
					}
				}
			}
		}
		
		// Keyboard events
		if !is_undefined(self.element_in_focus)
		{
			if keyboard_check(vk_anykey)
			{
				self.element_in_focus.onKeyboardInput();
				self.updateMainUiSurface();
			}
			if keyboard_check_released(vk_anykey)
			{
				self.element_in_focus.onKeyboardRelease();
			}
			if keyboard_check_pressed(vk_escape)
			{
				self.element_in_focus.removeFocus();
				self.element_in_focus = undefined;
				self.updateMainUiSurface();
			}
		}
		
		// Update all elements from flexpanels data and Z depth
		if self.needs_flex_update
		{
			self.needs_flex_update = false;
			self.flexCalculateLayout();
			self.flexUpdateAll();
		}
	}
	
	// Render
	self.base_render = method(self, render);
	self.render = function()
	{
		// Get previous alpha
		var _prev_alpha = draw_get_alpha();
		
		// Set alpha before render
		if LUI_FORCE_ALPHA_1
		{
			draw_set_alpha(1);
		}
		
		// Pre draw events
		for (var i = 0, n = array_length(self.pre_draw_list); i < n; ++i)
		{
			var _element = self.pre_draw_list[i];
			_element.preDraw();
		}
		
		// Create main ui surface
		if !surface_exists(self.ui_screen_surface)
		{
			self.ui_screen_surface = surface_create(self.width, self.height);
			self.update_ui_screen_surface = true;
		}
		
		// Update main ui surface
		if self.update_ui_screen_surface
		{
			// Set alpha 1 for drawing surface
			draw_set_alpha(1);
			
			// Set ui surface
			surface_set_target(self.ui_screen_surface);
			draw_clear_alpha(c_black, 0);
			gpu_set_blendequation_sepalpha(bm_eq_add, bm_eq_max);
			
			// Draw all elements
			self.base_render();
			
			// Reset ui surface
			gpu_set_blendequation(bm_eq_add);
			surface_reset_target();
			self.update_ui_screen_surface = false;
			
			// Reset alpha
			draw_set_alpha(LUI_FORCE_ALPHA_1 ? 1 : _prev_alpha);
		}
		
		// Draw all to screen
		if self.visible
		{
			//Draw main ui surface
			draw_surface_ext(self.ui_screen_surface, self.x, self.y, 1, 1, 0, c_white, LUI_FORCE_ALPHA_1 ? 1 : _prev_alpha);
			//Draw other stuff
			if self.display_focused_element
			{
				if !is_undefined(self.element_in_focus)
				{
					draw_rectangle_color(
						self.element_in_focus.x - 1, self.element_in_focus.y - 1, 
						self.element_in_focus.x + self.element_in_focus.width, self.element_in_focus.y + self.element_in_focus.height, c_white, c_white, c_white, c_white, true
					);
				}
			}
		}
		
		// Get topmost element
		var _element = self.topmost_hovered_element;
		
		// Draw tooltip text
		if !is_undefined(_element)
		{
			if _element.tooltip != ""
			{
				var _padding = self.style.padding; //Screen border indentation
				var _padding_text = self.style.padding; //Text border indentation inside tooltip box
				draw_set_font(self.style.font_default);
				var _width = string_width(_element.tooltip) + _padding_text*2;
				var _height = string_height(_element.tooltip) + _padding_text*2;
				var _mouse_x = clamp(device_mouse_x_to_gui(0) + 16, _padding, self.width - _width - _padding);
				var _mouse_y = clamp(device_mouse_y_to_gui(0) + 16, _padding, self.height - _height - _padding);
				// Draw tooltip sprite back
				if !is_undefined(self.style.sprite_tooltip)
				{
					draw_sprite_stretched_ext(self.style.sprite_tooltip, 0, _mouse_x, _mouse_y, _width, _height, self.style.color_tooltip, LUI_FORCE_ALPHA_1 ? 1 : _prev_alpha);
				}
				// Draw tooltip sprite border
				if !is_undefined(self.style.sprite_tooltip_border)
				{
					draw_sprite_stretched_ext(self.style.sprite_tooltip_border, 0, _mouse_x, _mouse_y, _width, _height, self.style.color_tooltip_border, LUI_FORCE_ALPHA_1 ? 1 : _prev_alpha);
				}
				// Draw text
				draw_set_color(self.style.color_font);
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				draw_text(_mouse_x + _padding_text, _mouse_y + _padding_text, _element.tooltip);
			}
		}
		
		// Draw debug screen grid
		if global.lui_debug_render_grid
		{
			self._drawScreenGrid();
		}
		
		// Draw debug info under mouse
		if global.lui_debug_mode != 0 && !is_undefined(_element)
		{
			if !is_undefined(self.style.font_debug)
			{
				draw_set_font(self.style.font_debug);
			}
			//Text on mouse
			var _mouse_x = device_mouse_x_to_gui(0) + 24;
			var _mouse_y = device_mouse_y_to_gui(0) + 24;
			//Text
			var _prev_color = draw_get_color();
			draw_set_alpha(1);
			draw_set_color(c_white);
			_luiDrawTextDebug(_mouse_x, _mouse_y, 
			"id: " + string(_element.element_id) + "\n" +
			"name: " + string(_element.name) + "\n" +
			"x: " + string(_element.pos_x) + (_element.auto_x ? " (auto)" : "") + " y: " + string(_element.pos_y) + (_element.auto_y ? " (auto)" : "") + "\n" +
			"w: " + string(_element.width) + (_element.auto_width ? " (auto)" : "") + " h: " + string(_element.height) + (_element.auto_height ? " (auto)" : "") + "\n" +
			"v: " + string(_element.value) + "\n" +
			"content: " + string(array_length(_element.content)) + "/" + string(array_length(_element.delayed_content)) + "\n" +
			"parent: " + (is_undefined(_element.parent) ? "undefined" : _element.parent.name) + "\n" +
			"z: " + string(_element.z));
			draw_set_color(_prev_color);
			draw_set_alpha(LUI_FORCE_ALPHA_1 ? 1 : _prev_alpha);
		}
	}
	
	// Cleanup
	self.onDestroy = function()
	{
		if surface_exists(self.ui_screen_surface)
		{
			surface_free(self.ui_screen_surface);
		}
		self.pre_draw_list = -1;
		self.element_in_focus = undefined;
		delete self._screen_grid;
		delete self.element_names;
		global.lui_element_count = 0;
		global.lui_z_index = 0;
	}
	
	///@desc Get element by name
	///@return {Struct}
	static getElement = function(_name)
	{
		if variable_struct_exists(self.element_names, _name)
		{
			return variable_struct_get(self.element_names, _name);
		}
		else
		{
			if LUI_LOG_ERROR_MODE >= 1 print($"LIME_UI.ERROR: Can't find element {_name}!");
			return -1;
		}
	}
}