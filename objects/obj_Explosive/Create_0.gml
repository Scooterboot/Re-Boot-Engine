/// @description Initialize
event_inherited();

type = ProjType.Missile;

damageType = DmgType.Explosive;

exploProj = noone;
exploDmgMult = 0.5;
exploSnd = -1;

blockDestroyType = -1;//2;
doorOpenType = -1;//1;

image_angle = 0;

pblockList = ds_list_create();
function MovePushBlock()
{
	var pbnum = instance_place_list(x,y,obj_PushBlock,pblockList,true);
	for(var i = 0; i < pbnum; i++)
	{
		var pblock = pblockList[| i];
		if(instance_exists(pblock))
		{
			pblock.explodePush(id,velX);
		}
	}
	ds_list_clear(pblockList);
}