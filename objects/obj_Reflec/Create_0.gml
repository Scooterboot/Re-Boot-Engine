/// @description 

var _p1 = new Vector2(-17,13),
	_p2 = new Vector2(17,13);

_len1 = _p1.Length();
_len2 = _p2.Length();

_ang1 = _p1.ToRotation();
_ang2 = _p2.ToRotation();

function GetPoint1()
{
	return new Vector2(x + lengthdir_x(_len1,_ang1+image_angle), y + lengthdir_y(_len1,_ang1+image_angle));
}
function GetPoint2()
{
	return new Vector2(x + lengthdir_x(_len2,_ang2+image_angle), y + lengthdir_y(_len2,_ang2+image_angle));
}
