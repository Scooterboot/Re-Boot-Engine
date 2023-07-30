/// @description Update Bubbles and etc.

if(global.gamePaused)
{
	exit;
}

for(var i = 0; i < ds_list_size(bubbleList); i++)
{
	bubbleList[| i].Update();
	if(bubbleList[| i]._delete)
	{
		ds_list_delete(bubbleList,i);
	}
}

time += 0.0625;