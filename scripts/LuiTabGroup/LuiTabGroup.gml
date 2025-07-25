///@desc Panel with tabs
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
///@arg {Real} tab_height
function LuiTabGroup(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiTabGroup", tab_height = 32) : LuiBase() constructor {
	
	self.name = name;
	self.pos_x = x;
	self.pos_y = y;
	self.width = width;
	self.height = height;
	initElement();
	
	self.is_pressed = false;
	self.tabs = undefined;
	self.tab_height = tab_height;
	
	self.tabgroup_header = undefined;
	
	self.onCreate = function() {
		// Setting up padding for tabgroup
		self.setFlexPadding(0).setFlexGap(0);
		// Init header container for tabs
		self._initHeader();
		// Add header to tabgroup
		self.addContent(self.tabgroup_header);
		self.tabgroup_header.setFlexGap(0).setMinHeight(self.tab_height);
		// Init tabs
		self._initTabs();
	}
	
	///@desc Create header container for tabs
	///@ignore
	static _initHeader = function() {
		if is_undefined(self.tabgroup_header) {
			self.tabgroup_header = new LuiFlexRow(, , , self.tab_height, "_tabgroup_header_" + string(self.element_id));
		}
	}
	
	///@desc Create tabs
	///@ignore
	static _initTabs = function() {
		if !is_undefined(self.tabs) {
			if !is_array(self.tabs) self.tabs = [self.tabs];
			var _tab_count = array_length(self.tabs);
			for (var i = 0; i < _tab_count; ++i) {
			    // Get tab
				var _tab = self.tabs[i];
				// Init tab container
				_tab._initContainer();
				// Set tabgroup parent for tab
				_tab.tabgroup = self;
				// Add tab container to tabgroup
				self.addContent(_tab.tab_container);
			}
			//Add tab to header of tabgroup
			self.tabgroup_header.addContent(self.tabs);
			//Deactivate all and activate first
			self.tabDeactivateAll();
			self.tabs[0].tabActivate();
		}
	}
	
	///@desc Add LuiTab's
	static addTabs = function(_tabs) {
        self.tabs = _tabs;
		if !is_undefined(self.main_ui) self._initTabs();
        return self;
    }
	
	///@desc Deactivate all tabs
	static tabDeactivateAll = function() {
		var _tab_count = array_length(self.tabs);
		for (var i = 0; i < _tab_count; ++i) {
		    //Get tab
			var _tab = self.tabs[i];
			//Deactivate it
			_tab.tabDeactivate();
		}
	}
	
	///@desc Removes tab (WIP)
    static removeTab = function(index) {
        if (index >= 0 && index < array_length(self.tabs)) {
            array_delete(self.tabs, index, 1);
        }
        return self;
    }
	
	self.draw = function() {
		//Base
		if !is_undefined(self.style.sprite_tabgroup) {
			var _blend_color = self.style.color_main;
			if self.deactivated {
				_blend_color = merge_colour(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_tabgroup, 0, self.x, self.y + self.tab_height, self.width, self.height - self.tab_height, _blend_color, 1);
		}
		//Border
		if !is_undefined(self.style.sprite_tabgroup_border) {
			draw_sprite_stretched_ext(self.style.sprite_tabgroup_border, 0, self.x, self.y + self.tab_height, self.width, self.height - self.tab_height, self.style.color_border, 1);
		}
	}
	
	self.onShow = function() {
		//Turn of visible of deactivated tab_container's
		var _tab_count = array_length(self.tabs);
		for (var i = 0; i < _tab_count; ++i) {
			var _tab = self.tabs[i];
			if !_tab.is_active {
				_tab.tab_container.setVisible(false);
			}
		}
	}
}

///@desc Tab, used for LuiTabGroup.
///@arg {String} name
///@arg {String} text
function LuiTab(name = "LuiTab", text = "Tab") : LuiButton(LUI_AUTO, LUI_AUTO, LUI_AUTO, LUI_AUTO, name, text) constructor {
	
	self.is_active = false;
	self.tabgroup = undefined;
	self.tab_container = undefined;
	
	self.onCreate = function() {
		self._initContainer();
		if sprite_exists(self.icon.sprite) self._calcIconSize();
	}
	
	///@desc Change getContainer function for compatibility with setFlex... functions
	self.getContainer = function() {
		self._initContainer();
		return self.container;
	}
	
	///@ignore
	static _initContainer = function() {
		if is_undefined(self.tab_container) {
			self.tab_container = new LuiContainer(0, 0, , , $"_tab_container_{self.element_id}").setVisible(false).setFlexDisplay(flexpanel_display.none).setFlexGrow(1);
			self.setContainer(self.tab_container);
		}
	}
	
	///@desc Activate current tab
	static tabActivate = function() {
		self.is_active = true;
		self.tab_container.setVisible(true).setFlexDisplay(flexpanel_display.flex);
	}
	
	///@desc Deactivate current tab
	static tabDeactivate = function() {
		self.is_active = false;
		self.tab_container.setVisible(false).setFlexDisplay(flexpanel_display.none);
	}
	
	///@desc Works like usual addContent, but redirect add content to tab_container of this tab
	self.addContent = function(elements) {
		self._initContainer();
		self.tab_container.addContent(elements);
		return self;
	}
	
	self.draw = function() {
		// Base
		if !is_undefined(self.style.sprite_tab) {
			var _blend_color = self.style.color_main;
			if !self.is_active {
				_blend_color = merge_colour(_blend_color, c_black, 0.25);
				if self.mouseHover() {
					_blend_color = merge_colour(_blend_color, self.style.color_hover, 0.5);
					if self.is_pressed == true {
						_blend_color = merge_colour(_blend_color, c_black, 0.5);
					}
				}
			}
			if self.deactivated {
				_blend_color = merge_colour(_blend_color, c_black, 0.5);
			}
			draw_sprite_stretched_ext(self.style.sprite_tab, 0, self.x, self.y, self.width, self.height, _blend_color, 1);
		}
		
		// Icon
		self._drawIcon();
		
		// Text
		if self.text != "" {
			if !is_undefined(self.style.font_buttons) {
				draw_set_font(self.style.font_buttons);
			}
			if !self.deactivated {
				draw_set_color(self.style.color_font);
			} else {
				draw_set_color(merge_colour(self.style.color_font, c_black, 0.5));
			}
			draw_set_alpha(1);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			var _txt_x = self.x + self.width / 2;
			var _txt_y = self.y + self.height / 2;
			_luiDrawTextCutoff(_txt_x, _txt_y, self.text, self.width);
		}
		
		// Border
		if !is_undefined(self.style.sprite_tab_border) {
			draw_sprite_stretched_ext(self.style.sprite_tab_border, 0, self.x, self.y, self.width, self.height, self.style.color_button_border, 1);
		}
	}
	
	self.onMouseLeftReleased = function() {
		if self.is_pressed && !self.is_active {
			self.is_pressed = false;
			self.tabgroup.tabDeactivateAll();
			self.tabActivate();
			if self.style.sound_click != undefined audio_play_sound(self.style.sound_click, 1, false);
		}
	}
}