/// @description Initialize
event_inherited();

pause = false;
isPaused = false;
pauseFade = 0;
unpause = true;
loadGame = false;
gameLoaded = false;
loadFade = 0;
gameEnd = false;
gameEnded = false;

enum Screen
{
	Map = 0,
	Inventory = 1,
	Options = 2,
	LogBook = 3
};
currentScreen = Screen.Map;
screenSelect = false;
screenSelectAnim = 0;

mapX = 0;
mapY = 0;
mapMove = 0;
mapMoveVelX = 0;
mapMoveVelY = 0;

pMapIconFrame = 0;
pMapIconFrameCounter = 0;
//pMapIconFrameNum = 1;
pMapIconSeq =		[0,1,2,3,4,3,2,1];
pMapIconNumSeq =	[12,8,6,4,16,2,3,4];


//invMove = 0;
//invMovePrev = 1;
//invMoveX = 0;

invMoveCounter = 0;

invPos = -1;
invPosX = 0;

/*suitSelect = -1;
beamSelect = -1;
itemSelect = -1;
miscSelect = -1;
bootsSelect = -1;*/

toggleItem = false;

invListL = ds_list_create();
invListR = ds_list_create();

textAnim = 0;

selectorAlpha = 0;
sAlphaNum = 1;

playerOffsetY = 20;

playerInvSurf = surface_create(global.resWidth,global.resHeight);

playerGlowY = 0;
playerGlowSurf = surface_create(global.resWidth,global.resHeight);
playerGlowSurf2 = surface_create(global.resWidth,global.resHeight);
playerFlashAlpha = 1;

playerGlowInd = -1;
playerGlowIndPrev = -1;

moveCounter = 0;

optionPos = 0;

option = array(
"DISPLAY OPTIONS",
"AUDIO OPTIONS",
"CONTROL OPTIONS",
"RESTART FROM LAST SAVE",
"QUIT TO MAIN MENU",
"QUIT TO DESKTOP");

confirmPos = 0;
confirmText = array("ARE YOU SURE?", "NO", "YES");
confirmRestart = false;//-1;
confirmQuitMM = false;//-1;
confirmQuitDT = false;//-1;

headerText = array(
"ZEBES",
"SAMUS",
"OPTIONS",
"LOG BOOK");
mapAreaText[MapArea.Crateria] = "CRATERIA";
mapAreaText[MapArea.WreckedShip] = "WRECKED SHIP";
mapAreaText[MapArea.Brinstar] = "BRINSTAR";
mapAreaText[MapArea.Norfair] = "NORFAIR";
mapAreaText[MapArea.Maridia] = "MARIDIA";
mapAreaText[MapArea.Tourian] = "TOURIAN";

itemHeaderText = array(
"SUIT",
"BEAM",
"EQUIP",
"GEAR",
"BOOTS");

suitName = array(
"VARIA SUIT",
"GRAVITY SUIT");
beamName = array(
"CHARGE BEAM",
"ICE BEAM",
"WAVE BEAM",
"SPAZER",
"PLASMA BEAM");
itemName = array(
"MISSILE",
"SUPER MISSILE",
"POWER BOMB",
"GRAPPLE BEAM",
"X-RAY VISOR");

miscName = array(
"POWER GRIP",
"MORPH BALL",
"M.B. BOMB",
"SPRING BALL",
"BOOST BALL",
"SPIDER BALL",
"SCREW ATTACK");
bootsName = array(
"HI-JUMP",
"SPACE JUMP",
"ACCEL DASH",
"SPEED BOOSTER",
"CHAIN SPARK");

pauseSurf = surface_create(global.resWidth,global.resHeight);

cursorFrame = 0;
cursorFrameCounter = 0;

cRight = false;
cLeft = false;
cUp = false;
cDown = false;
cSelect = false;
cCancel = false;
cStart = false;

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rStart = !cStart;

footerText[0] = "${itemSelectButton} - World Map\n"+
				"${menuSelectButton} - Place Marker\n"+
				"${menuCancelButton} - Menu Select";
footerText[1] = "${itemSelectButton} - Ability Info\n"+
				"${menuSelectButton} - Toggle Ability\n"+
				"${menuCancelButton} - Menu Select";
footerText[2] = "${menuSelectButton} - Choose Option\n"+
				"${menuCancelButton} - Menu Select";
footerText[3] = "${menuSelectButton} - Open Log\n"+
				"${menuCancelButton} - Menu Select";
footerText[4] = "${controlPad} - Choose Menu";

footerScrib = scribble(footerText[0]);
footerScrib.align(fa_center,fa_middle);
footerScrib.starting_format("fnt_GUI_Small2",c_white);

#region TextOutlineSurface

textSurface = surface_create(73,9);
function TextOutlineSurface(text)
{
	if(!surface_exists(textSurface))
	{
		textSurface = surface_create(73,9);
	}
	else
	{
		surface_set_target(textSurface);
		draw_clear_alpha(c_black,0);
		draw_set_color(c_white);
		draw_set_alpha(1);
		draw_text(0,0,text);
		draw_text(1,0,text);
		draw_text(2,0,text);
		draw_text(2,1,text);
		draw_text(2,2,text);
		draw_text(1,2,text);
		draw_text(0,2,text);
		draw_text(0,1,text);
		surface_reset_target();
	}
}

#endregion

#region DrawItemHeader
function DrawItemHeader(_x,_y,_name,_height,_facing)
{
	draw_set_font(fnt_GUI_Small2);
	
	var h = 10/17;
	var yscale = 1+h*(_height-1);
	draw_sprite_ext(sprt_Sub_ItemHeader,0,_x,_y,_facing,yscale,0,c_white,1);
	
	var cGreen = make_color_rgb(34,216,6);
	draw_set_alpha(1);
	draw_set_color(cGreen);
	var rx1 = _x+1,
		ry1 = _y+1,
		rx2 = rx1+string_width(_name)+2,
		ry2 = _y+6;
	
	var tx1 = rx2,
		ty1 = ry1,
		tx2 = rx2,
		ty2 = ry2,
		tx3 = tx2+6,
		ty3 = ty2;
	if(sign(_facing) == -1)
	{
		rx2 = _x-1;
		rx1 = rx2-string_width(_name)-3;
		tx1 = rx1-1;
		tx2 = rx1-1;
		tx3 = tx2-6;
	}
	draw_rectangle(rx1,ry1,rx2,ry2,false);
	draw_triangle(tx1,ty1,tx2,ty2,tx3,ty3,false);
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	var tx = rx1+2,
		ty = ry1-1;
	if(sign(_facing) == -1)
	{
		draw_set_halign(fa_right);
		tx = rx2-1;
	}
	draw_set_color(c_black);
	draw_text(tx,ty,_name);
}
#endregion

#region DrawInventoryPlayer
function DrawInventoryPlayer()
{
	var ww = global.resWidth;//, hh = global.resHeight;
	var xx = ww/2,
		yy = 50 + scr_round(playerOffsetY);

	draw_set_color(c_black)
	draw_set_alpha(0.5);
	draw_rectangle(-1,-1,ww+1,global.resHeight+1,false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	gpu_set_blendmode(bm_add);
	draw_sprite_ext(sprt_Sub_InvBG,0,ww/2,-30+scr_round(playerOffsetY/2),1,1,0,c_white,1);
	gpu_set_blendmode(bm_normal);

	var P = obj_Player;

	if(!surface_exists(playerInvSurf))
	{
		playerInvSurf = surface_create(global.resWidth,global.resHeight);
	}
	else
	{
		surface_resize(playerInvSurf,global.resWidth,global.resHeight);
		surface_set_target(playerInvSurf);
		draw_clear_alpha(c_black,0);
		
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
	
		draw_surface_ext(playerInvSurf,2,-1,1,1,0,c_black,1);
		draw_surface_ext(playerInvSurf,0,0,1,1,0,c_white,1);
	}

	playerGlowInd = -1;
	// 0 = full suit, 1 = beam, 2 = grip, 3 = torso
	// 4 = space jump, 5 = hi-jump, 6 = dash, 7 = x-ray
	
	//var playerGlowInd2 = -1;
	var yDest = 0;
	
	if(invPos != -1 && ((invPosX == 0 && !ds_list_empty(invListL)) || (invPosX == 1 && !ds_list_empty(invListR))))
	{
		var ability = invListL[| invPos];
		if(invPosX == 1)
		{
			ability = invListR[| invPos];
		}
		var index = string_digits(ability);
		
		if(string_pos("Suit",ability) != 0)
		{
			playerGlowInd = 0;
		}
		else if(string_pos("Beam",ability) != 0)
		{
			playerGlowInd = 1;
		}
		else if(string_pos("Item",ability) != 0)
		{
			playerGlowInd = 1;
			if(index == Item.PBomb)
			{
				playerGlowInd = 3;
			}
			if(index = Item.XRay)
			{
				playerGlowInd = 7;
			}
		}
		else if(string_pos("Misc",ability) != 0)
		{
			playerGlowInd = 3;
			if(index == Misc.PowerGrip)
			{
				playerGlowInd = 2;
			}
			if(index == Misc.ScrewAttack)
			{
				playerGlowInd = 0;
			}
		}
		else if(string_pos("Boots",ability) != 0)
		{
			yDest = -20;
			playerGlowInd = 0;
			if(index == Boots.HiJump)
			{
				playerGlowInd = 5;
			}
			if(index == Boots.SpaceJump)
			{
				playerGlowInd = 4;
			}
			if(index == Boots.Dodge)
			{
				playerGlowInd = 6;
			}
		}
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
			surface_resize(playerGlowSurf,global.resWidth,global.resHeight);
			surface_set_target(playerGlowSurf);
			draw_clear_alpha(c_black,0);
			
			var highlight_Suit = false,
				highlight_Beam = false,
				highlight_Grip = false,
				highlight_Torso = false,
				highlight_Boots1 = false,
				highlight_Boots2 = false,
				highlight_Visor = false;
			
			switch(playerGlowInd)
			{
				case 0:
				{
					highlight_Suit = true;
					highlight_Grip = true;
					highlight_Boots1 = true;
					highlight_Boots2 = true;
					break;
				}
				case 1:
				{
					highlight_Beam = true;
					break;
				}
				case 2:
				{
					highlight_Grip = true;
					break;
				}
				case 3:
				{
					highlight_Torso = true;
					break;
				}
				case 4:
				{
					highlight_Boots1 = true;
					highlight_Boots2 = true;
					break;
				}
				case 5:
				{
					highlight_Boots2 = true;
					break;
				}
				case 6:
				{
					highlight_Boots1 = true;
					highlight_Boots2 = true;
					highlight_Torso = true;
					break;
				}
				case 7:
				{
					highlight_Visor = true;
					break;
				}
			}
			
			if(highlight_Suit)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,P.suit[Suit.Varia],xx,yy);
			}
			if(highlight_Beam)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,2,xx,yy);
			}
			if(highlight_Grip)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,3+P.misc[Misc.PowerGrip],xx,yy);
			}
			if(highlight_Torso)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,5,xx,yy);
			}
			if(highlight_Boots1)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,6+P.boots[Boots.SpaceJump],xx,yy);
			}
			if(highlight_Boots2)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,8+P.boots[Boots.HiJump],xx,yy);
			}
			if(highlight_Visor)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask,10,xx,yy);
			}
			
			surface_reset_target();
		}
	
		if(!surface_exists(playerGlowSurf2))
		{
			playerGlowSurf2 = surface_create(global.resWidth,global.resHeight);
		}
		else
		{
			surface_resize(playerGlowSurf2,global.resWidth,global.resHeight);
			surface_set_target(playerGlowSurf2);
			draw_clear_alpha(c_black,0);
		
			var sprt = sprt_Sub_Samus_GlowMask;
		
			gpu_set_colorwriteenable(0,0,0,1);
			var height = 20;
			var totHeight = sprite_get_height(sprt);
			playerGlowY = scr_wrap(playerGlowY + 1, 0, totHeight);
		
			for(var i = -height; i < height; i++)
			{
				var lx1 = xx - sprite_get_width(sprt)/2 - 4,
					lx2 = xx + sprite_get_width(sprt)/2 + 4,
					ly = yy + wrap(i,0,totHeight) + playerGlowY;
			
				draw_set_color(c_white);
				draw_set_alpha((1-(abs(i)/height))*0.75);
				
				var num = 3;
				for(var k = 0; k < num; k++)
				{
					var ly2 = scr_wrap(ly + floor(totHeight/num)*k,yy,yy+totHeight);
					draw_line(lx1,ly2,lx2,ly2);
				}
			
				draw_set_color(c_black);
				draw_set_alpha(1);
			}
			gpu_set_colorwriteenable(1,1,1,0);
			
			draw_surface_ext(playerGlowSurf,0,0,1,1,0,make_color_rgb(136,232,16),1);
			gpu_set_colorwriteenable(1,1,1,1);
		
			if(playerFlashAlpha > 0)
			{
				draw_surface_ext(playerGlowSurf,0,0,1,1,0,make_color_rgb(136,232,16),playerFlashAlpha);
			}
		
			surface_reset_target();
		
			gpu_set_blendmode(bm_add);
			draw_surface_ext(playerGlowSurf2,0,0,1,1,0,c_white,1);
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
}
#endregion

#region DrawInventoryPlayer_Retro

useRetroPlayer = true;

function DrawInventoryPlayer_Retro()
{
	var ww = global.resWidth, hh = global.resHeight;
	var xx = ww/2,
		yy = 70;

	draw_set_color(c_black)
	draw_set_alpha(0.5);
	draw_rectangle(-1,-1,ww+1,global.resHeight+1,false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	gpu_set_blendmode(bm_add);
	//draw_sprite_ext(sprt_Sub_InvBG,0,ww/2,hh+45,1,-1,0,c_white,1);
	draw_sprite_ext(sprt_Sub_InvBG_Retro,0,ww/2,hh/2,1,1,0,c_white,1);
	gpu_set_blendmode(bm_normal);
	
	draw_sprite_ext(sprt_Sub_Lines_Base,0,ww/2,hh/2,1,1,0,c_white,1);
	var l = -1;
	if(invPos != -1 && ((invPosX == 0 && !ds_list_empty(invListL)) || (invPosX == 1 && !ds_list_empty(invListR))))
	{
		var ability = invListL[| invPos];
		if(invPosX == 1)
		{
			ability = invListR[| invPos];
		}
		var index = string_digits(ability);
		
		if(string_pos("Suit",ability) != 0)
		{
			l = 0;
		}
		else if(string_pos("Beam",ability) != 0)
		{
			l = 1;
		}
		else if(string_pos("Item",ability) != 0)
		{
			l = 2;
			if(index = Item.PBomb || index = Item.XRay)
			{
				l = 3;
			}
		}
		else if(string_pos("Misc",ability) != 0)
		{
			l = 4;
			if(index == Misc.PowerGrip)
			{
				l = 5;
			}
		}
		else if(string_pos("Boots",ability) != 0)
		{
			l = 7;
			if(index == Boots.HiJump || index == Boots.SpaceJump)
			{
				l = 6;
			}
		}
		
		if(l != -1)
		{
			draw_sprite_ext(sprt_Sub_Lines,l,ww/2,hh/2,1,1,0,c_white,1);
		}
	}
	
	/*var lineX1 = 0,
		lineY1 = 0,
		lineX2 = 0,
		lineY2 = 0,
		lineX3 = 0,
		lineY3 = 0;
	if(invPos != -1 && ((invPosX == 0 && !ds_list_empty(invListL)) || (invPosX == 1 && !ds_list_empty(invListR))))
	{
		var ability = invListL[| invPos];
		if(invPosX == 1)
		{
			ability = invListR[| invPos];
		}
		var index = string_digits(ability);
		
		if(string_pos("Suit",ability) != 0)
		{
			lineX1 = -75;
			lineY1 = -63 + 10*invPos;
			lineX2 = -28;
			lineY2 = -43;
		}
		else if(string_pos("Beam",ability) != 0)
		{
			lineX1 = -75;
			lineY1 = -25 + 10*(invPos-2);
			lineX2 = -27;
			lineY2 = 2;
		}
		else if(string_pos("Item",ability) != 0)
		{
			lineX1 = -75;
			lineY1 = 43 + 10*(invPos-7);
			lineX2 = -27;
			lineY2 = 2;
			if(index == Item.XRay)
			{
				lineX2 = -28;
				lineY2 = -43;
			}
		}
		else if(string_pos("Misc",ability) != 0)
		{
			lineX1 = 75;
			lineY1 = -45 + 10*invPos;
			lineX2 = 28;
			lineY2 = -30;
			if(index == Misc.PowerGrip)
			{
				lineY2 = -4;
			}
		}
		else if(string_pos("Boots",ability) != 0)
		{
			lineX1 = 75;
			lineY1 = 44 + 10*(invPos-6);
			lineX2 = 19;
			lineY2 = 48;
			if(index == Boots.SpeedBoost || index == Boots.ChainSpark || index == Boots.Dodge)
			{
				lineX3 = 28;
				lineY3 = -30;
			}
		}
		
		if(lineX1 != 0 && lineY1 != 0 )//&& ((lineX2 != 0 && lineY2 != 0) || (lineX3 != 0 && lineY3 != 0)))
		{
			draw_set_alpha(1);
			for(var i = 0; i < 3; i++)
			{
				draw_set_color(make_color_rgb(46,107,0));
				if(i == 1)
				{
					draw_set_color(c_white);
				}
				var xoff = ww/2,
					yoff = hh/2 - 2 + 2*i;
				//if(lineX1 < 0)
				//{
					if(lineX2 != 0 && lineY2 != 0)
					{
						draw_line(lineX1+xoff,lineY1+yoff,lineX2+xoff,lineY2+yoff);
					}
					if(lineX3 != 0 && lineY3 != 0)
					{
						draw_line(lineX1+xoff,lineY1+yoff,lineX3+xoff,lineY3+yoff);
					}
				//}
			}
		}
	}*/

	var P = obj_Player;

	if(!surface_exists(playerInvSurf))
	{
		playerInvSurf = surface_create(global.resWidth,global.resHeight);
	}
	else
	{
		surface_resize(playerInvSurf,global.resWidth,global.resHeight);
		surface_set_target(playerInvSurf);
		draw_clear_alpha(c_black,0);
		
		var i = P.suit[Suit.Varia];
		if(P.suit[Suit.Gravity])
		{
			i = 2+P.suit[Suit.Varia];
		}
		
		var b = 0;
		if(P.beam[Beam.Charge])
		{
			b = 1;
			if(P.beam[Beam.Spazer])
			{
				b = 4;
			}
			if(P.beam[Beam.Wave])
			{
				b = 3;
			}
			if(P.beam[Beam.Plasma])
			{
				b = 5;
			}
			if(P.beam[Beam.Ice])
			{
				b = 2;
			}
		}
		draw_sprite(sprt_Sub_Samus_Gun_Retro,b,xx-30,yy+39);
		
		draw_sprite(sprt_Sub_Samus_Retro,i,xx,yy);
		
		if(P.misc[Misc.PowerGrip])
		{
			draw_sprite(sprt_Sub_Samus_Grip_Retro,min(i,2),xx+4,yy+41);
		}
		if(P.boots[Boots.SpaceJump])
		{
			draw_sprite(sprt_Sub_Samus_Boots1_Retro,min(i,2),xx,yy+67);
		}
		if(P.boots[Boots.HiJump])
		{
			draw_sprite(sprt_Sub_Samus_Boots2_Retro,min(i,2),xx,yy+96);
		}
		
		surface_reset_target();
	
		draw_surface_ext(playerInvSurf,1,1,1,1,0,c_black,0.75);
		draw_surface_ext(playerInvSurf,0,0,1,1,0,c_white,1);
	}
	
	playerGlowInd = -1;
	// 0 = full suit, 1 = beam, 2 = grip, 3 = torso
	// 4 = space jump, 5 = hi-jump, 6 = dash, 7 = x-ray
	
	if(invPos != -1 && ((invPosX == 0 && !ds_list_empty(invListL)) || (invPosX == 1 && !ds_list_empty(invListR))))
	{
		var ability = invListL[| invPos];
		if(invPosX == 1)
		{
			ability = invListR[| invPos];
		}
		var index = string_digits(ability);
		
		if(string_pos("Suit",ability) != 0)
		{
			playerGlowInd = 0;
		}
		else if(string_pos("Beam",ability) != 0)
		{
			playerGlowInd = 1;
		}
		else if(string_pos("Item",ability) != 0)
		{
			playerGlowInd = 1;
			if(index == Item.PBomb)
			{
				playerGlowInd = 3;
			}
			if(index = Item.XRay)
			{
				playerGlowInd = 7;
			}
		}
		else if(string_pos("Misc",ability) != 0)
		{
			playerGlowInd = 3;
			if(index == Misc.PowerGrip)
			{
				playerGlowInd = 2;
			}
			if(index == Misc.ScrewAttack)
			{
				playerGlowInd = 0;
			}
		}
		else if(string_pos("Boots",ability) != 0)
		{
			playerGlowInd = 0;
			if(index == Boots.HiJump)
			{
				playerGlowInd = 5;
			}
			if(index == Boots.SpaceJump)
			{
				playerGlowInd = 4;
			}
			if(index == Boots.Dodge)
			{
				playerGlowInd = 6;
			}
		}
	}
	
	if(playerGlowInd != -1)
	{
		if(playerGlowInd != playerGlowIndPrev)
		{
			playerFlashAlpha = 0.6;//0.5;
		}
		if(toggleItem)
		{
			playerFlashAlpha = 0.85;//0.75;
		}
	
		if(!surface_exists(playerGlowSurf))
		{
			playerGlowSurf = surface_create(global.resWidth,global.resHeight);
		}
		else
		{
			surface_resize(playerGlowSurf,global.resWidth,global.resHeight);
			surface_set_target(playerGlowSurf);
			draw_clear_alpha(c_black,0);
			
			var highlight_Suit = false,
				highlight_Beam = false,
				highlight_Grip = false,
				highlight_Torso = false,
				highlight_Boots1 = false,
				highlight_Boots2 = false,
				highlight_Visor = false;
			
			switch(playerGlowInd)
			{
				case 0:
				{
					highlight_Suit = true;
					highlight_Beam = true;
					highlight_Grip = true;
					highlight_Boots1 = true;
					highlight_Boots2 = true;
					break;
				}
				case 1:
				{
					highlight_Beam = true;
					break;
				}
				case 2:
				{
					highlight_Grip = true;
					break;
				}
				case 3:
				{
					highlight_Torso = true;
					break;
				}
				case 4:
				{
					highlight_Boots1 = true;
					highlight_Boots2 = true;
					break;
				}
				case 5:
				{
					highlight_Boots2 = true;
					break;
				}
				case 6:
				{
					highlight_Boots1 = true;
					highlight_Boots2 = true;
					highlight_Torso = true;
					break;
				}
				case 7:
				{
					highlight_Visor = true;
					break;
				}
			}
			
			if(highlight_Beam)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask_Retro,2+P.beam[Beam.Charge]+2*P.suit[Suit.Varia],xx,yy);
			}
			if(highlight_Suit)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask_Retro,P.suit[Suit.Varia],xx,yy);
			}
			if(highlight_Grip)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask_Retro,6+P.suit[Suit.Varia],xx,yy);
				if(P.misc[Misc.PowerGrip])
				{
					draw_sprite(sprt_Sub_Samus_GlowMask_Retro,8,xx,yy);
				}
			}
			if(highlight_Torso)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask_Retro,9+P.suit[Suit.Varia],xx,yy);
			}
			if(highlight_Boots1)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask_Retro,11+P.boots[Boots.SpaceJump],xx,yy);
			}
			if(highlight_Boots2)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask_Retro,13+P.boots[Boots.HiJump],xx,yy);
			}
			if(highlight_Visor)
			{
				draw_sprite(sprt_Sub_Samus_GlowMask_Retro,15,xx,yy);
			}
			
			surface_reset_target();
		}
	
		if(!surface_exists(playerGlowSurf2))
		{
			playerGlowSurf2 = surface_create(global.resWidth,global.resHeight);
		}
		else
		{
			surface_resize(playerGlowSurf2,global.resWidth,global.resHeight);
			surface_set_target(playerGlowSurf2);
			draw_clear_alpha(c_black,0);
		
			var sprt = sprt_Sub_Samus_GlowMask_Retro;
		
			gpu_set_colorwriteenable(0,0,0,1);
			var height = 20;
			var totHeight = sprite_get_height(sprt);
			playerGlowY = scr_wrap(playerGlowY + 1, 0, totHeight);
		
			for(var i = -height; i < height; i++)
			{
				var lx1 = xx - sprite_get_width(sprt)/2 - 4,
					lx2 = xx + sprite_get_width(sprt)/2 + 4,
					ly = yy + wrap(i,0,totHeight) + playerGlowY;
			
				draw_set_color(c_white);
				draw_set_alpha((1-(abs(i)/height))*0.85);
				
				var num = 2;
				for(var k = 0; k < num; k++)
				{
					var ly2 = scr_wrap(ly + floor(totHeight/num)*k,yy,yy+totHeight);
					draw_line(lx1,ly2,lx2,ly2);
				}
			
				draw_set_color(c_black);
				draw_set_alpha(1);
			}
			gpu_set_colorwriteenable(1,1,1,0);
			
			draw_surface_ext(playerGlowSurf,0,0,1,1,0,make_color_rgb(136,232,16),1);
			gpu_set_colorwriteenable(1,1,1,1);
		
			if(playerFlashAlpha > 0)
			{
				gpu_set_fog(true,make_color_rgb(136,232,16),0,0);
				draw_surface_ext(playerGlowSurf,0,0,1,1,0,c_white,playerFlashAlpha);
				gpu_set_fog(false,0,0,0);
			}
		
			surface_reset_target();
		
			gpu_set_blendmode(bm_add);
			draw_surface_ext(playerGlowSurf2,0,0,1,1,0,c_white,1);
			gpu_set_blendmode(bm_normal);
		}
	}
	else
	{
		playerGlowY = 0;
	}

	playerFlashAlpha = max(playerFlashAlpha-0.05,0);

	playerGlowIndPrev = playerGlowInd;

	draw_set_color(c_black);
	draw_set_alpha(1);
}

#endregion