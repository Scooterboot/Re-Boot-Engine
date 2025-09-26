/// @description Update Bubbles and etc.

if(global.GamePaused())
{
	exit;
}

for(var i = ds_list_size(bubbleList)-1; i >= 0; i--)
{
	bubbleList[| i].Update();
	if(bubbleList[| i]._delete)
	{
		ds_list_delete(bubbleList,i);
	}
}

time += 0.0625;