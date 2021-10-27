// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_BreakBlock(xx,yy,type)
{
	scr_DestroyObject(xx,yy,obj_ShotBlock);
	
	/*if(place_meeting(xx,yy,obj_BombBlock) && type == 0 && object_is_ancestor(object_index,obj_Projectile) && object_index.isBeam)
	{
	    var b = instance_place(xx,yy,obj_BombBlock);
	    if(!b.visible)
	    {
	        b.revealTile = true;
	    }
	}*/
	
	if(type == 1 || type >= 4)
	{
	    scr_DestroyObject(xx,yy,obj_BombBlock);

	    if(type == 1)
	    {
	        scr_DestroyObject(xx,yy,obj_ChainBlock);
	    }
	}

	if(type == 2 || type == 3)
	{
	    scr_DestroyObject(xx,yy,obj_MissileBlock);
	}

	if(type == 3)
	{
	    scr_DestroyObject(xx,yy,obj_SuperMissileBlock);
	}

	if(type == 4)
	{
	    scr_DestroyObject(xx,yy,obj_PowerBombBlock);
	}

	if(type == 5)
	{
	    scr_DestroyObject(xx,yy,obj_SpeedBlock);
	}

	if(type == 6)
	{
	    scr_DestroyObject(xx,yy,obj_ScrewBlock);
	}
}
function scr_DestroyObject(xx,yy,objIndex)
{
	var _list = ds_list_create();
	var _num = instance_place_list(xx,yy,objIndex,_list,true);
	if(_num > 0)
	{
		for(var i = 0; i < _num; i++)
		{
			instance_destroy(_list[| i]);
		}
	}
	ds_list_destroy(_list);
}