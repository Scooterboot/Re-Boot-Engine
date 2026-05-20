function UI_GetInputIconString(icon)
{
	if(is_struct(icon))
	{
		return icon.GetScribText();
	}
	else if(asset_get_type(icon) == asset_sprite)
	{
		return "["+sprite_get_name(icon)+"]";
	}
	else if(is_string(icon) && !string_contains(icon,"["))
	{
		return "[["+icon+"]";
	}
	return string(icon);
}
