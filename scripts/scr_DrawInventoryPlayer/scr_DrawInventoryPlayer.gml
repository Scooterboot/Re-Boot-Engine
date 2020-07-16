/// @description scr_DrawInventoryPlayer(x,y)

var sx = argument0, sy = argument1;

//draw_sprite_ext(sprt_Sub_InvBG,0,sx,sy-30+scr_round(playerOffsetY/2),1,1,0,c_white,0.5);
//gpu_set_blendmode(bm_add);
//draw_sprite_ext(sprt_Sub_InvBG,0,sx,sy-30+scr_round(playerOffsetY/2),1,1,0,c_white,0.5);
//gpu_set_blendmode(bm_normal);
draw_sprite_ext(sprt_Sub_InvBG,0,sx,sy-30+scr_round(playerOffsetY/2),1,1,0,c_white,1);

var ww = global.resWidth,
	hh = global.resHeight;
var xx = ww/2,
	yy = 50 + scr_round(playerOffsetY);

var P = obj_Player;

if(!surface_exists(playerInvSurf))
{
	playerInvSurf = surface_create(global.resWidth,global.resHeight);
}
else
{
	surface_set_target(playerInvSurf);
	draw_clear_alpha(c_black,0);
	
	/*draw_sprite(sprt_Sub_SamusShadow,P.suit[Suit.Varia],xx,yy-1);
	if(P.misc[Misc.PowerGrip])
	{
		draw_sprite(sprt_Sub_SamusShadow_Grip,0,xx+30,yy+35);
	}
	if(P.boots[Boots.SpaceJump])
	{
		draw_sprite(sprt_Sub_SamusShadow_Boots1,0,xx,yy+95);
	}
	if(P.boots[Boots.HiJump])
	{
		draw_sprite(sprt_Sub_SamusShadow_Boots2,0,xx,yy+133);
	}*/

	var i = P.suit[Suit.Varia];
	if(P.suit[Suit.Gravity])
	{
		i = 2+P.suit[Suit.Varia];
	}
	draw_sprite(sprt_Sub_Samus,i,xx,yy);
	if(P.misc[Misc.PowerGrip])
	{
		draw_sprite(sprt_Sub_Samus_Grip,min(i,2),xx+30,yy+36);
	}
	if(P.boots[Boots.SpaceJump])
	{
		draw_sprite(sprt_Sub_Samus_Boots1,min(i,2),xx,yy+96);
	}
	if(P.boots[Boots.HiJump])
	{
		draw_sprite(sprt_Sub_Samus_Boots2,min(i,2),xx,yy+134);
	}
	/*if(P.beam[Beam.Ice])
	{
		draw_sprite(sprt_Sub_Samus_GunLights,0,xx-33,yy+57);
	}
	if(P.beam[Beam.Wave] || P.beam[Beam.Spazer] || P.beam[Beam.Plasma])
	{
		var j = 0;
		if(P.beam[Beam.Wave])
		{
			j = 1;
			if(P.beam[Beam.Spazer])
			{
				j = 4;
				if(P.beam[Beam.Plasma])
				{
					j = 7;
				}
			}
			else if(P.beam[Beam.Plasma])
			{
				j = 5;
			}
		}
		else if(P.beam[Beam.Spazer])
		{
			j = 2;
			if(P.beam[Beam.Plasma])
			{
				j = 6;
			}
		}
		else if(P.beam[Beam.Plasma])
		{
			j = 3;
		}
		draw_sprite(sprt_Sub_Samus_GunLights,j,xx-33,yy+57);
	}*/
	if(P.beam[Beam.Ice])
	{
		draw_sprite(sprt_Sub_Samus_GunLights,0,xx-32,yy+57);
	}
	if(P.beam[Beam.Wave])
	{
		draw_sprite(sprt_Sub_Samus_GunLights,1,xx-32,yy+57);
	}
	if(P.beam[Beam.Spazer])
	{
		draw_sprite(sprt_Sub_Samus_GunLights,2,xx-32,yy+57);
	}
	if(P.beam[Beam.Plasma])
	{
		draw_sprite(sprt_Sub_Samus_GunLights,3,xx-32,yy+57);
	}
	
	surface_reset_target();
	
	draw_surface_ext(playerInvSurf,sx+2,sy-1,1,1,0,c_black,1);
	draw_surface_ext(playerInvSurf,sx,sy,1,1,0,c_white,1);
}

playerGlowInd = -1;
var yDest = 0;

if(beamSelect != -1)
{
	playerGlowInd = 2;
}
else if(bootsSelect != -1)
{
	yDest = -20;
	playerGlowInd = 0;
	if(bootsSelect == Boots.HiJump)
	{
		playerGlowInd = 8;
	}
	if(bootsSelect == Boots.SpaceJump)
	{
		playerGlowInd = 6;
	}
}
else if(miscSelect != -1)
{
	playerGlowInd = 5;
	if(miscSelect == Misc.PowerGrip)
	{
		playerGlowInd = 3;
	}
	if(miscSelect == Misc.ScrewAttack)
	{
		playerGlowInd = 0;
	}
}
else if(suitSelect != -1)
{
	playerGlowInd = 0;
}

if(playerOffsetY > yDest)
{
	playerOffsetY = max(playerOffsetY - max((playerOffsetY-yDest)/10,0.1), yDest);
}
if(playerOffsetY < yDest)
{
	playerOffsetY = min(playerOffsetY + max((yDest-playerOffsetY)/10,0.1), yDest);
}

if(playerGlowInd != -1)
{
	if(playerGlowInd != playerGlowIndPrev)
	{
		playerFlashAlpha = 0.75;
	}
	if(toggleItem)
	{
		playerFlashAlpha = 1;
	}
	
	if(!surface_exists(playerGlowSurf))
	{
		playerGlowSurf = surface_create(global.resWidth,global.resHeight);
	}
	else
	{
		surface_set_target(playerGlowSurf);
		draw_clear_alpha(c_black,0);
		
		if(playerGlowInd == 0)
		{
			draw_sprite(sprt_Sub_Samus_GlowMask,P.suit[Suit.Varia],xx,yy);
			if(P.misc[Misc.PowerGrip])
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,4,xx,yy);
			}
			if(P.boots[Boots.SpaceJump])
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,7,xx,yy);
			}
			if(P.boots[Boots.HiJump])
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,9,xx,yy);
			}
		}
		else if(playerGlowInd == 3)
		{
			draw_sprite(sprt_Sub_Samus_GlowMask,3+P.misc[Misc.PowerGrip],xx,yy);
		}
		else if(playerGlowInd == 6)
		{
			draw_sprite(sprt_Sub_Samus_GlowMask,6+P.boots[Boots.SpaceJump],xx,yy);
			if(P.boots[Boots.HiJump])
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,9,xx,yy);
			}
		}
		else if(playerGlowInd == 8)
		{
			draw_sprite(sprt_Sub_Samus_GlowMask,8+P.boots[Boots.HiJump],xx,yy);
		}
		else
		{
			draw_sprite(sprt_Sub_Samus_GlowMask,playerGlowInd,xx,yy);
		}
		
		surface_reset_target();
	}
	
	if(!surface_exists(playerGlowSurf2))
	{
		playerGlowSurf2 = surface_create(global.resWidth,global.resHeight);
	}
	else
	{
		surface_set_target(playerGlowSurf2);
		draw_clear_alpha(c_black,0);
		
		var sprt = sprt_Sub_Samus_GlowMask;
		
		gpu_set_colorwriteenable(0,0,0,1);
		var height = 20;
		var totHeight = sprite_get_height(sprt)+(height*2);
		playerGlowY = scr_wrap(playerGlowY + 1, 0, totHeight);
		
		for(var i = -height; i < height; i++)
		{
			var ly = scr_wrap(yy + playerGlowY + i,0,totHeight),
				lx1 = xx - sprite_get_width(sprt)/2 - 4,
				lx2 = xx + sprite_get_width(sprt)/2 + 4;
			
			draw_set_color(c_white);
			draw_set_alpha((1-(abs(i)/height))*0.75);
			draw_line(lx1,ly,lx2,ly);
			
			var ly2 = scr_wrap(ly + scr_floor(totHeight/3),0,totHeight);
			draw_line(lx1,ly2,lx2,ly2);
			
			var ly3 = scr_wrap(ly + scr_floor((totHeight/3)*2),0,totHeight);
			draw_line(lx1,ly3,lx2,ly3);
			
			draw_set_color(c_black);
			draw_set_alpha(1);
		}
		gpu_set_colorwriteenable(1,1,1,0);
		/*for(var i = 0; i < 360; i += 45)
		{
			var gx = scr_ceil(lengthdir_x(1,i)),
			gy = scr_ceil(lengthdir_y(1,i));
			draw_surface_ext(playerGlowSurf,gx,gy,1,1,0,make_color_rgb(136,232,16),0.5);
		}*/
		draw_surface_ext(playerGlowSurf,0,0,1,1,0,make_color_rgb(136,232,16),1);
		gpu_set_colorwriteenable(1,1,1,1);
		
		if(playerFlashAlpha > 0)
		{
			draw_surface_ext(playerGlowSurf,0,0,1,1,0,make_color_rgb(136,232,16),playerFlashAlpha);
		}
		
		surface_reset_target();
		
		gpu_set_blendmode(bm_add);
		draw_surface_ext(playerGlowSurf2,sx,sy,1,1,0,c_white,1);
		gpu_set_blendmode(bm_normal);
	}
}
else
{
	playerGlowY = 0;
}

playerFlashAlpha = max(playerFlashAlpha-0.075,0);

playerGlowIndPrev = playerGlowInd;

draw_set_color(c_black);
draw_set_alpha(1);