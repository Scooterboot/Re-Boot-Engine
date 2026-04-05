
#region BBox vars
function bb_left(xx = undefined)
{
	/// @description bb_left
	/// @param baseX=x
	xx = is_undefined(xx) ? x : xx;
	return bbox_left-x + xx;
}
function bb_right(xx = undefined)
{
	/// @description bb_right
	/// @param baseX=x
	xx = is_undefined(xx) ? x : xx;
	return bbox_right-x + xx - 1;
}
function bb_top(yy = undefined)
{
	/// @description bb_top
	/// @param baseY=y
	yy = is_undefined(yy) ? y : yy;
	return bbox_top-y + yy;
}
function bb_bottom(yy = undefined)
{
	/// @description bb_bottom
	/// @param baseY=y
	yy = is_undefined(yy) ? y : yy;
	return bbox_bottom-y + yy - 1;
}

function bb_width(xx = undefined)
{
	return self.bb_right(xx)-self.bb_left(xx);
}
function bb_height(yy = undefined)
{
	return self.bb_bottom(yy)-self.bb_top(yy);
}
function Center(useRealXY = false, xx = undefined, yy = undefined)
{
	if(useRealXY)
	{
		return new Vector2(self.bb_left(x) + self.bb_width(x)/2, self.bb_top(y) + self.bb_height(y)/2);
	}
	return new Vector2(self.bb_left(xx) + self.bb_width(xx)/2, self.bb_top(yy) + self.bb_height(yy)/2);
}
#endregion

creator = noone;
offsetX = 0;
offsetY = 0;
hostile = false;

function UpdatePos(_x,_y)
{
	x = _x+offsetX;
	y = _y+offsetY;
}

function Life_CanTakeDamage(_dmgBox, _dmg, _dmgType, _dmgSubType)
{
	return creator.Entity_CanTakeDamage(id, _dmgBox, _dmg, _dmgType, _dmgSubType);
}
function Life_ModifyDamageTaken(_dmgBox, _dmg, _dmgType, _dmgSubType)
{
	return creator.Entity_ModifyDamageTaken(id, _dmgBox, _dmg, _dmgType, _dmgSubType);
}
function Life_OnDamageTaken(_dmgBox, _finalDmg, _dmg, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600, _npcDeathType = -1)
{
	creator.Entity_OnDamageTaken(id, _dmgBox, _finalDmg, _dmg, _dmgType, _dmgSubType, _freezeType, _freezeTime, _npcDeathType);
}
function Life_OnDamageTaken_Blocked(_dmgBox, _damage, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600)
{
	creator.Entity_OnDamageTaken_Blocked(id, _dmgBox, _damage, _dmgType, _dmgSubType, _freezeType, _freezeTime);
}