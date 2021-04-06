/// @description Initialize

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
mapSurf = surface_create(8,8);
pMapIconFrame = 0;
pMapIconFrameCounter = 0;
pMapIconFrameNum = 1;


invMove = 0;
invMovePrev = 1;
invMoveX = 0;

invMoveCounter = 0;

invPos = -1;

beamSelect = -1;
suitSelect = -1;
bootsSelect = -1;
miscSelect = -1;

toggleItem = false;

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
confirmRestart = -1;
confirmQuitMM = -1;
confirmQuitDT = -1;


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

#region SelectItem
function SelectItem(itemSelect,itemSelectX,itemSelectY,itemSelectXY, pHasItem,pHasItemY, pItem, ownItemX,ownItemY,ownItemXY, xPos,yPos,xyPos)
{
	itemSelectX = -1;
	itemSelectY = -1;
	itemSelectXY = -1;
					
	if(itemSelect == -1)
	{
		itemSelect = 0;
	}
	else
	{
		itemSelect += invMove;
						
		var num = array_length(pHasItem);
		while(!pHasItem[scr_wrap(itemSelect,0,array_length(pHasItem)-1)] && num > 0)
		{
			itemSelect += invMovePrev;
			num--;
		}
						
		if(itemSelect < 0 || itemSelect >= array_length(pHasItem))
		{
			if(ownItemY)
			{
				invPos = yPos;
				itemSelect = -1;
				if(invMove < 0)
				{
					itemSelectY = array_length(pHasItemY)-1;
				}
				else
				{
					itemSelectY = 0;
				}
				invMove = 0;
			}
			else
			{
				itemSelect = scr_wrap(itemSelect,0,array_length(pHasItem)-1);
			}
		}
						
		if(invMoveX != 0)
		{
			if(ownItemX)
			{
				invPos = xPos;
				itemSelect = -1;
				itemSelectX = 0;
			}
			else if(ownItemXY)
			{
				invPos = xyPos;
				itemSelect = -1;
				itemSelectXY = 0;
			}
			invMoveX = 0;
		}
						
		if(toggleItem && itemSelect == clamp(itemSelect,0,array_length(pHasItem)-1) && pHasItem[itemSelect])
		{
			pItem[itemSelect] = !pItem[itemSelect];
			audio_play_sound(snd_MenuBoop,0,false);
		}
	}
	
	var Return;
	Return[0] = itemSelect;
	Return[1] = itemSelectX;
	Return[2] = itemSelectY;
	Return[3] = itemSelectXY;
	Return[4] = pHasItem;
	Return[5] = pHasItemY;
	Return[6] = pItem;
	return Return;
}
#endregion

#region DrawInventoryPlayer
function DrawInventoryPlayer()
{
	var ww = global.resWidth;//, hh = global.resHeight;
	var xx = ww/2,
		yy = 50 + scr_round(playerOffsetY);

	draw_sprite_ext(sprt_Sub_InvBG,0,ww/2,-30+scr_round(playerOffsetY/2),1,1,0,c_white,1);

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