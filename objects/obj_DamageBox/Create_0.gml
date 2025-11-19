
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
#endregion

creator = noone;
offsetX = 0;
offsetY = 0;
hostile = false;
neutral = false;

function Dmg_CanDealDamage(_lifeBox, _dmg, _dmgType, _dmgSubType)
{
	return creator.Entity_CanDealDamage(id, _lifeBox, _dmg, _dmgType, _dmgSubType);
}
function Dmg_ModifyDamageDealt(_lifeBox, _dmg, _dmgType, _dmgSubType)
{
	return creator.Entity_ModifyDamageDealt(id, _lifeBox, _dmg, _dmgType, _dmgSubType);
}
function Dmg_OnDamageDealt(_lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType)
{
	creator.Entity_OnDamageDealt(id, _lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType);
}
function Dmg_OnDamageDealt_Blocked(_lifeBox, _dmg, _dmgType, _dmgSubType)
{
	creator.Entity_OnDamageDealt_Blocked(id, _lifeBox, _dmg, _dmgType, _dmgSubType);
}

function Dmg_OnDmgBoxCollision(_lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType)
{
	creator.Entity_OnDmgBoxCollision(id, _lifeBox, _finalDmg, _dmg, _dmgType, _dmgSubType);
}

lifeBoxList = ds_list_create();

function Damage(_x, _y, _damage, _dmgType, _dmgSubType, _freezeType = 0, _freezeTime = 600, _deathType = -1)
{
	///@description Damage
	///@param x
	///@param y
	///@param damage
	///@param damageType
	///@param damageSubType
	///@param freezeType=0
	///@param freezeTime=600
	///@param deathType=-1
	
	x = _x+offsetX;
	y = _y+offsetY;
	
	var num = instance_place_list(x, y, obj_LifeBox, lifeBoxList, false);
	if(num > 0)
	{
		for(var i = 0; i < num; i++)
		{
			var lbox = lifeBoxList[| i];
			if(!instance_exists(lbox) || !instance_exists(creator) || !instance_exists(lbox.creator) || creator == lbox.creator)
			{
				continue;
			}
			if(!neutral && hostile == lbox.hostile)
			{
				continue;
			}
			if(!self.Dmg_CanDealDamage(lbox,_damage,_dmgType,_dmgSubType) || !lbox.Life_CanTakeDamage(id,_damage,_dmgType,_dmgSubType))
			{
				continue;
			}
			
			var dmg = self.Dmg_ModifyDamageDealt(lbox, _damage, _dmgType, _dmgSubType);
			dmg = lbox.Life_ModifyDamageTaken(id, _damage, _dmgType, _dmgSubType);
			
			if(dmg > 0)
			{
				var _iFrames = 0;
				if(ds_exists(creator.iFrameCounters,ds_type_list))
				{
					_iFrames = creator.GetInvFrames(lbox.creator);
				}
				if(_iFrames <= 0)
				{
					lbox.Life_OnDamageTaken(id, dmg, _damage, _dmgType, _dmgSubType, _freezeType, _freezeTime, _deathType);
					self.Dmg_OnDamageDealt(lbox, dmg, _damage, _dmgType, _dmgSubType);
					
					if(ds_exists(creator.iFrameCounters,ds_type_list) && lbox.creator.object_index != obj_Player)
					{
						ds_list_add(creator.iFrameCounters, new creator.InvFrameCounter(lbox.creator, creator.npcInvFrames));
					}
				}
			}
			else
			{
				lbox.Life_OnDamageTaken_Blocked(id, _damage, _dmgType, _dmgSubType, _freezeType, _freezeTime);
				self.Dmg_OnDamageDealt_Blocked(lbox, _damage, _dmgType, _dmgSubType);
			}
			
			self.Dmg_OnDmgBoxCollision(lbox, dmg, _damage, _dmgType, _dmgSubType);
		}
		ds_list_clear(lifeBoxList);
	}
}