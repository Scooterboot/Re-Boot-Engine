/// @description 
//event_perform_object(obj_Breakable,ev_step,0);

if(!instance_exists(dmgBoxes[0]))
{
	var spW = sprite_get_width(sprite_index),
		spH = sprite_get_height(sprite_index),
		oLenX = -1 * sign(image_xscale),
		oLenY = -1 * sign(image_yscale),
		oX = (lengthdir_x(oLenX,image_angle) - lengthdir_y(oLenY,image_angle)),
		oY = (lengthdir_x(oLenY,image_angle) + lengthdir_y(oLenX,image_angle));
	dmgBoxes[0] = self.CreateDamageBox(oX,oY,sprite_index,true);
	dmgBoxes[0].image_xscale = ((spW*abs(image_xscale)) + 2) / spW * sign(image_xscale);
	dmgBoxes[0].image_yscale = ((spH*abs(image_yscale)) + 2) / spH * sign(image_yscale);
	dmgBoxes[0].image_angle = image_angle;
	dmgBoxes[0].direction = direction;
}
else
{
	dmgBoxes[0].Damage(x,y,damage,damageType,damageSubType);
	self.IncrInvFrames();
}

frameCounter++;
if(frameCounter > 8)
{
	frame = scr_wrap(frame+1,0,4);
	frameCounter = 0;
}
image_index = frameSeq[frame];