/// @description 

palIndex = 0;
if(life <= lifeMax*0.875)
{
	palIndex = 1;
}
if(life <= lifeMax*0.75)
{
	palIndex = 2;
}
if(life <= lifeMax*0.625)
{
	palIndex = 3;
}
if(life <= lifeMax*0.5)
{
	palIndex = 4;
}
if(life <= lifeMax*0.375)
{
	palIndex = 5;
}
if(life <= lifeMax*0.25)
{
	palIndex = 6;
}
if(life <= lifeMax*0.125)
{
	palIndex = 7;
}

palIndex_Eyes = palIndex+1;

palIndex2_Eyes = 11;//5;
palDif_Eyes = eyeGlow;

if(dmgFlash > 4)
{
	palIndex = 8;//4;
	palDif = 0;
	
	palIndex_Eyes = 9;//6;
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