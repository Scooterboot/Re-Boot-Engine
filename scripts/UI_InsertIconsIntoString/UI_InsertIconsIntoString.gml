function UI_InsertIconsIntoString(str)
{
	if(instance_exists(obj_UI_Controller))
	{
		return obj_UI_Controller.InsertButtonIcons(str);
	}
	return str;
}
