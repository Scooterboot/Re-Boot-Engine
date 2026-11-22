function UI_GetInputIconString(icon)
{
	if(is_struct(icon) && is_instanceof(icon, UISpriteIcon))
	{
		return icon.GetScribText();
	}
	else if(is_string(icon) && !string_contains(icon,"["))
	{
		return "[["+icon+"]";
	}
	else if(is_undefined(icon))
	{
		return undefined;
	}
	return string(icon);
}
