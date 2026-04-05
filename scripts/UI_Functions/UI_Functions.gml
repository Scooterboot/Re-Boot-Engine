
function UI_CreateMessageBox(header,description,messageType)
{
	var mbox = instance_create_depth(0,0,1,obj_MessageBox);
	mbox.header = header;
	mbox.description = description;
	mbox.messageType = messageType;
}

function UISpriteIcon(_sprtInd, _imgInd = undefined) constructor
{
	spriteIndex = _sprtInd;
	imageIndex = _imgInd;
	
	function GetScribText()
	{
		var str = sprite_get_name(spriteIndex);
		if(!is_undefined(imageIndex))
		{
			str += ","+string(imageIndex);
		}
		return "["+str+"]";
	}
}
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