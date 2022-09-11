/// @description 

palIndex = 0;
if(life <= lifeMax*0.8)
{
	palIndex = 1;
}
if(life <= lifeMax*0.5)
{
	palIndex = 2;
}
if(life <= lifeMax*0.3)
{
	palIndex = 3;
}
palIndex_Eyes = palIndex+1;

palIndex2_Eyes = 5;
palDif_Eyes = eyeGlow;

if(dmgFlash > 4)
{
	palIndex = 4;
	palDif = 0;
	
	palIndex_Eyes = 6;
	palDif_Eyes = 0;
}

for(var i = 0; i < array_length(Limbs); i++)
{
	var frame = 0;
	if(Limbs[i].name == "Hand_Back")
	{
		frame = lHandFrame;
	}
	if(Limbs[i].name == "Hand_Front")
	{
		frame = rHandFrame;
	}
	if(Limbs[i].name == "Head" || Limbs[i].name == "Eyes" || Limbs[i].name == "Ear")
	{
		frame = headFrame;
	}
	
	if(Limbs[i].name == "Eyes")
	{
		pal_swap_set(pal_Kraid_Eyes,palIndex_Eyes,palIndex2_Eyes,palDif_Eyes,false);
	}
	else
	{
		pal_swap_set(pal_Kraid,palIndex,palIndex2,palDif,false);
	}
	Limbs[i].Draw(frame,dir);
	shader_reset();
}

dmgFlash = max(dmgFlash-1,0);


/*if(instance_exists(head))
{
	draw_sprite_ext(mask_Kraid_Head,0,head.x,head.y,head.image_xscale,head.image_yscale,head.image_angle,c_white,1);

	var adposX = lengthdir_x(8,head.image_angle-90),
		adposY = lengthdir_y(8,head.image_angle-90);
	draw_sprite_ext(mask_Kraid_Head,0,head.x+adposX,head.y+adposY,head.image_xscale,head.image_yscale,head.image_angle,c_red,1);
}*/