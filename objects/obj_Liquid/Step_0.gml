/// @description Update Bubbles, Do Movement, etc.

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

if(!instance_exists(platform))
{
	platform = instance_create_layer(self.bb_left(), self.bb_top()+1, layer_get_id("Collision"), obj_LiquidPlatform);
	platform.image_xscale = (self.bb_right()-self.bb_left()+1)/16;
	platform.xRayHide = true;
}

if(moveY)
{
	if(abs(bobSpeed) >= bobBtm)
	{
		bobAcc *= -1;
	}
	bobSpeed += bobAcc;
	y += bobSpeed;
	
	image_yscale = scr_round(bottom-y + 1) / sprite_get_height(sprite_index);
	
	if(instance_exists(platform))
	{
		platform.isSolid = false;
		platform.UpdatePosition(self.bb_left(), self.bb_top()+1);
		platform.isSolid = true;
	}
}
