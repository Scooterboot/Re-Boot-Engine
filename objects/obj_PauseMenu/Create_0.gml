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

cursorGlowSurf = surface_create(11,15);

mapX = 0;
mapY = 0;
mapMove = 0;
mapMoveVelX = 0;
mapMoveVelY = 0;
mapSurf = surface_create(8,8);
pMapIconFrame = 0;
pMapIconFrameCounter = 0;
pMapIconFrameNum = 1;


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
"BOMB",
"SPRING BALL",
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

textSurface = surface_create(73,9);
#region TextOutlineSurface
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
	var playerGlowInd2 = -1;
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
			playerGlowInd = 2;
		}
		else if(string_pos("Item",ability) != 0)
		{
			playerGlowInd = 2;
			if(index == Item.PBomb)
			{
				playerGlowInd = 5;
			}
			if(index = Item.XRay)
			{
				playerGlowInd = 10;
			}
		}
		else if(string_pos("Misc",ability) != 0)
		{
			playerGlowInd = 5;
			if(index == Misc.PowerGrip)
			{
				playerGlowInd = 3;
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
				playerGlowInd = 8;
			}
			if(index == Boots.SpaceJump)
			{
				playerGlowInd = 6;
			}
			if(index == Boots.Dodge)
			{
				playerGlowInd = 5;
				playerGlowInd2 = 6;
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
			
			if(playerGlowInd2 != -1)
			{
				if(playerGlowInd2 == 6)
				{
					draw_sprite(sprt_Sub_Samus_GlowMask,6+P.boots[Boots.SpaceJump],xx,yy);
					if(P.boots[Boots.HiJump])
					{
						draw_sprite(sprt_Sub_Samus_GlowMask,9,xx,yy);
					}
				}
				else
				{
					draw_sprite(sprt_Sub_Samus_GlowMask,playerGlowInd2,xx,yy);
				}
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