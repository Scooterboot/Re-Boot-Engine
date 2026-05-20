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
