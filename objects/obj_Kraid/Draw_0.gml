/// @description 

self.Palette();

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
	
	Limbs[i].Draw(frame, dir);
}

dmgFlash = max(dmgFlash-1,0);


/*if(instance_exists(head))
{
	draw_sprite_ext(mask_Kraid_Head,0,head.x,head.y,head.image_xscale,head.image_yscale,head.image_angle,c_white,1);

	var adposX = lengthdir_x(8,head.image_angle-90),
		adposY = lengthdir_y(8,head.image_angle-90);
	draw_sprite_ext(mask_Kraid_Head,0,head.x+adposX,head.y+adposY,head.image_xscale,head.image_yscale,head.image_angle,c_red,1);
}*/

/*
draw_set_font(fnt_GUI);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
var dpos = new Vector2(128, 256+64);
draw_text(dpos.X, dpos.Y, "health:" + string(life));
draw_text(dpos.X, dpos.Y+10, "real X:" + string(x));
draw_text(dpos.X, dpos.Y+20, "real Y:" + string(y));
draw_text(dpos.X, dpos.Y+30, "position.X:" + string(position.X));
draw_text(dpos.X, dpos.Y+40, "position.Y:" + string(position.Y));
*/
