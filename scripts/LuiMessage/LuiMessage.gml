///@desc Show message with custom message text and button text
///@arg {Struct.LuiMain} ui
///@arg {Real} width
///@arg {Real} height
///@arg {String} text
function showLuiMessage(ui, width = LUI_AUTO, height = LUI_AUTO, text = "", button_text = "Close") {
	// Extra string for message elements
	var _extra = md5_string_utf8(text);
	// Black block area
	var _block_area = new LuiBlockArea(0, 0, display_get_gui_width(), display_get_gui_height(), "_lui_block_area_" + _extra).centerContent().setPositionType(flexpanel_position_type.absolute);
	// Pop up message panel
	var _calc_width = width;
	if _calc_width == LUI_AUTO {
		draw_set_font(ui.style.font_default);
		_calc_width = max(string_width(text), string_width(button_text)) + ui.style.padding * 2;
	}
	var _container = new LuiFlexColumn();
	var _panel = new LuiPanel(, , _calc_width, height, "_lui_popup_panel" + _extra);
	// Text
	var _txt = new LuiText(, , , , "_lui_popup_text" + _extra, text).setTextHalign(fa_center);
	// Button
	var _btn = new LuiButton(, , , , "_lui_popup_button" + _extra, button_text, function() {
		self.parent.parent.parent.destroy();
	});
	ui.addContent([
		_block_area.addContent([
			_panel.addContent([
				_container.addContent([
					_txt
				]),
				new LuiFlexColumn().setFlexGrow(1).setFlexJustifyContent(flexpanel_justify.flex_end).addContent([
					_btn
				])
			])
		])
	]);
	return _container;
}