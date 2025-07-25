///@desc An empty, invisible container for elements.
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
function LuiContainer(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiContainer") : LuiBase() constructor {
	
	self.name = name;
	self.pos_x = x;
	self.pos_y = y;
	self.width = width;
	self.height = height;
	initElement();
}

///@desc An empty, invisible container with no padding on the sides for elements with ROW stacking
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
function LuiFlexRow(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiFlexRow") : LuiContainer(x, y, width, height, name) constructor {
	
	self.onCreate = function() {
		self.setFlexPadding(0).setFlexDirection(flexpanel_flex_direction.row);
	}
}

///@desc An empty, invisible container with no padding on the sides for elements with COLUMN stacking
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
function LuiFlexColumn(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiFlexRow") : LuiContainer(x, y, width, height, name) constructor {
	
	self.onCreate = function() {
		self.setFlexPadding(0).setFlexDirection(flexpanel_flex_direction.column);
	}
}

///@desc An empty, invisible container with absolute position on the screen for elements
///@arg {Real} x
///@arg {Real} y
///@arg {Real} width
///@arg {Real} height
///@arg {String} name
function LuiAbsContainer(x = LUI_AUTO, y = LUI_AUTO, width = LUI_AUTO, height = LUI_AUTO, name = "LuiAbsContainer") : LuiContainer(x, y, width, height, name) constructor {
	
	self.onCreate = function() {
		self.setPositionType(flexpanel_position_type.absolute);
	}
}