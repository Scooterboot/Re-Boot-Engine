/// @description 
event_inherited();

enum MMState
{
	TitleIntro,
	Title,
	MainMenu,
	FileMenu,
	LoadGame
}
state = MMState.TitleIntro;
targetState = state;

enum MMSubState
{
	None,
	FileSelected,
	FileCopy,
	ConfirmCopy,
	ConfirmDelete
}
subState = MMSubState.None;

screenFade = 1;
screenFadeRate = 0.075;

titleAlpha = 0;
pressStartAnim = 0;
startString = "PRESS START";

moveCounterX = 0;
moveCounterY = 0;
moveCounterMax = 30;
function MoveSelectX()
{
	if(creator.moveCounterX >= creator.moveCounterMax)
	{
		return creator.cMenuRight - creator.cMenuLeft;
	}
	return (creator.cMenuRight && creator.rMenuRight) - (creator.cMenuLeft && creator.rMenuLeft);
}
function MoveSelectY()
{
	if(creator.moveCounterY >= creator.moveCounterMax)
	{
		return creator.cMenuDown - creator.cMenuUp;
	}
	return (creator.cMenuDown && creator.rMenuDown) - (creator.cMenuUp && creator.rMenuUp);
}

selectedFile = -1;
copyFile = -1;

fileTime = array_create(5, -1);
filePercent = array_create(5, -1);
fileEnergyMax = array_create(5, -1);
fileEnergy = array_create(5, -1);

itemList = ds_list_create();

#region Main Menu Panel

mainMenuText = [
"START GAME",
"SETTINGS",
"QUIT TO DESKTOP"];

mainMenuPanel = noone;
function CreateMainMenuPanel()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	draw_set_font(fnt_GUI);
	
	mainMenuPanel = CreatePanel(0,0,ww,hh);
	mainMenuPanel.alpha = 0;
	mainMenuPanel.MoveSelectX = MoveSelectX;
	mainMenuPanel.MoveSelectY = MoveSelectY;
	
	var btn = [];
	for(var i = 0; i < array_length(mainMenuText); i++)
	{
		var str = mainMenuText[i];
		var btnW = max(string_width(str),104), btnH = string_height(str)+1;
		btn[i] = mainMenuPanel.CreateButton(ww/2 - btnW/2, hh/2 + 48 + 12*i, btnW, btnH, str);
		btn[i].DrawButton = DrawMainMenuButton;
	}
	
	btn[0].button_up = btn[2];
	btn[0].button_down = btn[1];
	btn[0].OnClick = function()
	{
		targetState = MMState.FileMenu;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	btn[1].button_up = btn[0];
	btn[1].button_down = btn[2];
	btn[1].OnClick = function()
	{
		
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	btn[2].button_up = btn[1];
	btn[2].button_down = btn[0];
	btn[2].OnClick = function()
	{
		instance_deactivate_object(all);
		game_end();
	}
}
#endregion
#region File Menu Panel

fileMenuText = [
"FILE A",
"FILE B",
"FILE C",
"FILE D",
"FILE E",
"BACK"];

fileMenuPanel = noone;
function CreateFileMenuPanel()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	fileMenuPanel = CreatePanel(0,0,ww,hh);
	fileMenuPanel.MoveSelectX = MoveSelectX;
	fileMenuPanel.MoveSelectY = MoveSelectY;
	
	var fBtnW = 248,
		fBtnH = 32,
		fBtnSpace = 36;
	
	var fileBtn = [];
	for(var i = 0; i < array_length(fileMenuText)-1; i++)
	{
		fileBtn[i] = fileMenuPanel.CreateButton(ww/2 - fBtnW/2, 24 + fBtnSpace*i, fBtnW, fBtnH, fileMenuText[i]);
		fileBtn[i].fileIndex = i;
		fileBtn[i].OnClick = function()
		{
			with(other)
			{
				creator.subState = MMSubState.FileSelected;
				creator.selectedFile = fileIndex;
				creator.CreateSelectedFileMenu(GetY(),fileIndex);
			}
			
			audio_play_sound(snd_MenuTick,0,false);
		}
		fileBtn[i].DrawButton = DrawSaveFileButton;
	}
	
	draw_set_font(fnt_GUI);
	var str = fileMenuText[5];
	var bBtnW = max(string_width(str),48), bBtnH = string_height(str)+1;
	var backBtn = fileMenuPanel.CreateButton(ww/2 - 96, hh - 32, bBtnW, bBtnH, str);
	backBtn.DrawButton = DrawMainMenuButton;
	backBtn.OnClick = function()
	{
		targetState = MMState.MainMenu;
		audio_play_sound(snd_MenuTick,0,false);
	}
	backBtn.fileIndex = -1;
	
	for(var i = 0; i < array_length(fileMenuText)-1; i++)
	{
		var prevB = backBtn;
		if(i > 0)
		{
			prevB = fileBtn[i-1]
		}
		var nextB = backBtn;
		if(i < array_length(fileMenuText)-2)
		{
			nextB = fileBtn[i+1];
		}
		
		fileBtn[i].button_up = prevB;
		fileBtn[i].button_down = nextB;
	}
	backBtn.button_up = fileBtn[4];
	backBtn.button_down = fileBtn[0];
}
#endregion
#region Selected File Panel

fileOptionText = [
"START GAME",
"CANCEL",
"COPY FILE",
"DELETE FILE"];

selectedFilePanel = noone;
function CreateSelectedFileMenu(_yoffset, _fileIndex)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	var fBtnW = 248,
		fBtnH = 32;
	
	selectedFilePanel = CreatePanel(ww/2-fBtnW/2, _yoffset, fBtnW, fBtnH)
	selectedFilePanel.fileIndex = _fileIndex;
	
	draw_set_font(fnt_GUI);
	var btnW = 78;//72;
	
	var str = fileOptionText[0];
	var strH = string_height(str)+1;
	var startGameBtn = selectedFilePanel.CreateButton(fBtnW/2 - btnW/2, fBtnH/2 - strH - 2, btnW, strH, str);
	startGameBtn.OnClick = function()
	{
		targetState = MMState.LoadGame;
		audio_play_sound(snd_MenuShwsh,0,false);
	}
	startGameBtn.DrawButton = DrawGenericButton;
	
	str = fileOptionText[1];
	strH = string_height(str)+1;
	var cancelBtn = selectedFilePanel.CreateButton(fBtnW/2 - btnW/2, fBtnH/2 + 2, btnW, strH, str);
	cancelBtn.OnClick = function()
	{
		subState = MMSubState.None;
		selectedFile = -1;
		instance_destroy(selectedFilePanel);
		audio_play_sound(snd_MenuTick,0,false);
	}
	cancelBtn.DrawButton = DrawGenericButton;
	
	startGameBtn.button_up = cancelBtn;
	startGameBtn.button_down = cancelBtn;
	cancelBtn.button_up = startGameBtn;
	cancelBtn.button_down = startGameBtn;
	
	if(file_exists(scr_GetFileName(_fileIndex)))
	{
		startGameBtn.x = scr_floor(fBtnW/2 - 52);
		cancelBtn.x = scr_floor(fBtnW/2 - 52);
		
		str = fileOptionText[2];
		strH = string_height(str)+1;
		var copyBtn = selectedFilePanel.CreateButton(fBtnW/2 + 28, fBtnH/2 - strH - 2, btnW, strH, str);
		copyBtn.OnClick = function()
		{
			subState = MMSubState.FileCopy;
			CreateCopyMenu();
			audio_play_sound(snd_MenuTick,0,false);
		}
		copyBtn.DrawButton = DrawGenericButton;
		
		str = fileOptionText[3];
		strH = string_height(str)+1;
		var deleteBtn = selectedFilePanel.CreateButton(fBtnW/2 + 28, fBtnH/2 + 2, btnW, strH, str);
		deleteBtn.OnClick = function()
		{
			subState = MMSubState.ConfirmDelete;
			CreateConfirmDeletePanel();
			audio_play_sound(snd_MenuBoop,0,false);
		}
		deleteBtn.DrawButton = DrawGenericButton;
	
		copyBtn.button_up = deleteBtn;
		copyBtn.button_down = deleteBtn;
		deleteBtn.button_up = copyBtn;
		deleteBtn.button_down = copyBtn;
		
		startGameBtn.button_left = copyBtn;
		startGameBtn.button_right = copyBtn;
		cancelBtn.button_left = deleteBtn;
		cancelBtn.button_right = deleteBtn;
		
		copyBtn.button_left = startGameBtn;
		copyBtn.button_right = startGameBtn;
		deleteBtn.button_left = cancelBtn;
		deleteBtn.button_right = cancelBtn;
	}
	
	selectedFilePanel.selectedButton = startGameBtn;
}
#endregion
#region Copy File Panel

copyFileText = [
"FILE A",
"FILE B",
"FILE C",
"FILE D",
"FILE E",
"CANCEL"];

copyFilePanel = noone;
function CreateCopyMenu()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	copyFilePanel = CreatePanel(0,0,ww,hh);
	copyFilePanel.MoveSelectX = MoveSelectX;
	copyFilePanel.MoveSelectY = MoveSelectY;
	
	var cBtnW = 248,
		cBtnH = 32,
		cBtnSpace = 36;
	
	var copyBtn = [];
	for(var i = 0; i < array_length(copyFileText)-1; i++)
	{
		copyBtn[i] = copyFilePanel.CreateButton(ww/2 - cBtnW/2, 24 + cBtnSpace*i, cBtnW, cBtnH, copyFileText[i]);
		copyBtn[i].fileIndex = i;
		copyBtn[i].OnClick = function()
		{
			subState = MMSubState.ConfirmCopy;
			CreateConfirmCopyPanel(selectedFile, other.fileIndex);
			audio_play_sound(snd_MenuBoop,0,false);
		}
		copyBtn[i].DrawButton = DrawSaveFileButton;
		
		if(copyBtn[i].fileIndex == selectedFile)
		{
			copyBtn[i].active = false;
		}
	}
	copyFilePanel.selectedButton = copyBtn[0];
	if(!copyBtn[0].active)
	{
		copyFilePanel.selectedButton = copyBtn[1];
	}
	
	var cbtn = array_length(copyFileText)-1;
	draw_set_font(fnt_GUI);
	var str = copyFileText[5];
	var bBtnW = max(string_width(str),48), bBtnH = string_height(str)+1;
	copyBtn[cbtn] = copyFilePanel.CreateButton(ww/2 - 96, hh - 32, bBtnW, bBtnH, str);
	copyBtn[cbtn].DrawButton = DrawMainMenuButton;
	copyBtn[cbtn].OnClick = function()
	{
		subState = MMSubState.FileSelected;
		instance_destroy(copyFilePanel);
		audio_play_sound(snd_MenuTick,0,false);
	}
	
	var len = array_length(copyFileText);
	for(var i = 0; i < len; i++)
	{
		var prevB = copyBtn[scr_wrap(i-1,0,len)],
			nextB = copyBtn[scr_wrap(i+1,0,len)];
		if(!prevB.active)
		{
			prevB = copyBtn[scr_wrap(i-2,0,len)]
		}
		if(!nextB.active)
		{
			nextB = copyBtn[scr_wrap(i+2,0,len)]
		}
		
		copyBtn[i].button_up = prevB;
		copyBtn[i].button_down = nextB;
	}
}
#endregion
#region Confirm Copy Panel

confirmCopyText = [
"COPYING ",
" TO ",
"ARE YOU SURE?",
"YES",
"NO"];

confirmCopyPanel = noone;
function CreateConfirmCopyPanel(srcFile, destFile)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	draw_set_font(fnt_Menu2);
	var str = confirmCopyText[0] + "["+copyFileText[srcFile]+"]" + confirmCopyText[1] + "["+copyFileText[destFile]+"]" + "\n\n" + confirmCopyText[2];
	var pnlW = 248,//string_width(str) + 4,
		pnlH = string_height(str) + 24;
	confirmCopyPanel = CreatePanel(ww/2 - pnlW/2, hh/2 - pnlH/2, pnlW, pnlH);
	confirmCopyPanel.text = str;
	confirmCopyPanel.alpha = 0;
	confirmCopyPanel.DrawPanel = DrawConfirmPanel;
	
	draw_set_font(fnt_GUI);
	str = confirmCopyText[3];
	var yesBtn = confirmCopyPanel.CreateButton(pnlW/2 - 16 - string_width(str), pnlH - string_height(str) - 4, string_width(str) + 4, string_height(str)+1, str);
	yesBtn.DrawButton = DrawMainMenuButton;
	yesBtn.srcFile = srcFile;
	yesBtn.destFile = destFile;
	yesBtn.OnClick = function()
	{
		scr_DeleteGame(other.destFile);
		file_copy(scr_GetFileName(other.srcFile),scr_GetFileName(other.destFile));
		fileTime[other.destFile] = -1;
		
		selectedFile = -1;
		subState = MMSubState.None;
		instance_destroy(copyFilePanel);
		instance_destroy(selectedFilePanel);
		instance_destroy(confirmCopyPanel);
		
		for(var j = 0; j < ds_list_size(fileMenuPanel.buttonList); j++)
		{
			var fmpBtn = fileMenuPanel.buttonList[| j];
			if(fmpBtn.fileIndex == other.destFile)
			{
				fileMenuPanel.selectedButton = fmpBtn;
			}
		}
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	str = confirmCopyText[4];
	var noBtn = confirmCopyPanel.CreateButton(pnlW/2 + 16, pnlH - string_height(str) - 4, string_width(str) + 4, string_height(str)+1, str);
	noBtn.DrawButton = DrawMainMenuButton;
	noBtn.OnClick = function()
	{
		subState = MMSubState.FileCopy;
		instance_destroy(confirmCopyPanel);
		audio_play_sound(snd_MenuTick,0,false);
	}
	
	yesBtn.button_left = noBtn;
	yesBtn.button_right = noBtn;
	noBtn.button_left = yesBtn;
	noBtn.button_right = yesBtn;
	
	confirmCopyPanel.selectedButton = noBtn;
}

#endregion
#region Confirm Delete Panel

confirmDeleteText = [
"DELETING ",
"ARE YOU SURE?",
"YES",
"NO"];

confirmDeletePanel = noone;
function CreateConfirmDeletePanel()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	draw_set_font(fnt_Menu2);
	var str = confirmDeleteText[0] + "["+fileMenuText[selectedFile]+"]" + "\n\n" + confirmDeleteText[1];
	var pnlW = 248,//string_width(str) + 4,
		pnlH = string_height(str) + 24;
	confirmDeletePanel = CreatePanel(ww/2 - pnlW/2, hh/2 - pnlH/2, pnlW, pnlH);
	confirmDeletePanel.text = str;
	confirmDeletePanel.alpha = 0;
	confirmDeletePanel.DrawPanel = DrawConfirmPanel;
	
	str = confirmDeleteText[2];
	var yesBtn = confirmDeletePanel.CreateButton(pnlW/2 - 16 - string_width(str), pnlH - string_height(str) - 4, string_width(str) + 4, string_height(str)+1, str);
	yesBtn.DrawButton = DrawMainMenuButton;
	yesBtn.OnClick = function()
	{
		scr_DeleteGame(selectedFile);
		fileTime[selectedFile] = -1;
		selectedFile = -1;
		subState = MMSubState.None;
		instance_destroy(selectedFilePanel);
		instance_destroy(confirmDeletePanel);
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	str = confirmDeleteText[3];
	var noBtn = confirmDeletePanel.CreateButton(pnlW/2 + 16, pnlH - string_height(str) - 4, string_width(str) + 4, string_height(str)+1, str);
	noBtn.DrawButton = DrawMainMenuButton;
	noBtn.OnClick = function()
	{
		subState = MMSubState.FileSelected;
		instance_destroy(confirmDeletePanel);
		audio_play_sound(snd_MenuTick,0,false);
	}
	
	yesBtn.button_left = noBtn;
	yesBtn.button_right = noBtn;
	noBtn.button_left = yesBtn;
	noBtn.button_right = yesBtn;
	
	confirmDeletePanel.selectedButton = noBtn;
}

#endregion

#region DrawGenericButton
function DrawGenericButton(_x, _y)
{
	//with(other)
	/*{
		var col = c_black,
			alph = 0.5;
		if(panel.selectedButton == id)
		{
			col = c_aqua;
			alph = 0.5;
		}
		var alph2 = alpha*panel.alpha;
		draw_set_color(col);
		draw_set_alpha(alph*alph2);
		draw_roundrect(_x-2, _y-2, _x+width, _y+height, false);
			
		var xx = _x+width/2, yy = _y+height/2;
		draw_set_alpha(alph2);
		draw_set_font(fnt_GUI);
		draw_set_align(fa_center,fa_middle);
		draw_set_color(c_black);
		draw_text(xx+1,yy+1,text);
		draw_set_color(c_white);
		draw_text(xx,yy,text);
		draw_set_alpha(1);
	}*/
	var _sprt = sprt_UI_GenericButton,
		_sw = sprite_get_width(_sprt),
		_sh = sprite_get_height(_sprt),
		_ind = 2,
		_alph = 0.65,
		_bAlph = 0.65;
	if(panel.selectedButton == id)
	{
		_ind = 0;
		_alph = 0.85;
		_bAlph = 0.85;
	}
	var alph2 = alpha*panel.alpha,
		_ww = max(width,_sw),
		_hh = max(height,_sh),
		_xx = _x+width/2-_ww/2,
		_yy = _y+height/2-_hh/2;
	draw_sprite_stretched_ext(_sprt,_ind+1, _xx,_yy, _ww,_hh, c_white,alph2*_bAlph);
	draw_sprite_stretched_ext(_sprt,_ind, _xx,_yy, _ww,_hh, c_white,alph2*_alph);
	
	var xx = _x+width/2, yy = _y+height/2+1;
	draw_set_alpha(alph2);
	draw_set_font(fnt_GUI);
	draw_set_align(fa_center,fa_middle);
	draw_set_color(c_black);
	draw_text(xx+1,yy+1,text);
	draw_set_color(c_white);
	draw_text(xx,yy,text);
	draw_set_alpha(1);
}
#endregion
#region DrawMainMenuButton
function DrawMainMenuButton(_x, _y)
{
	//with(other)
	/*{
		var col = c_black,
			alph = 0.5,
			ol_col = c_black,
			ol_alph = 0;
		if(panel.selectedButton == id)
		{
			col = c_aqua;
			alph = 0.25;
			ol_col = c_aqua;
			ol_alph = 0.75;
		}
		var alph2 = alpha*panel.alpha;
		draw_set_color(col);
		draw_set_alpha(alph*alph2);
		draw_rectangle(_x, _y, _x+width, _y+height, false);
		
		draw_set_color(ol_col);
		draw_set_alpha(ol_alph*alph2);
		draw_line(_x, _y, _x+width, _y);
		draw_line(_x, _y+height, _x+width, _y+height);
		
		var w2 = max(scr_ceil(width/4),8);
		for(var i = 0; i < w2; i++)
		{
			draw_set_color(col);
			draw_set_alpha(alph*alph2 * ((w2-i)/w2));
			draw_line(_x-i-1, _y-1, _x-i-1, _y+height);
			draw_line(_x+width+i+1, _y-1, _x+width+i+1, _y+height);
			
			draw_set_color(ol_col);
			draw_set_alpha(ol_alph*alph2 * ((w2-i)/w2));
			draw_point(_x-i, _y);
			draw_point(_x-i, _y+height);
			draw_point(_x+width+i+1, _y);
			draw_point(_x+width+i+1, _y+height);
		}
			
		var xx = _x+width/2, yy = _y+height/2 + 1;
		draw_set_alpha(alph2);
		draw_set_font(fnt_GUI);
		draw_set_align(fa_center,fa_middle);
		draw_set_color(c_black);
		draw_text(xx+1,yy+1,text);
		draw_set_color(c_white);
		draw_text(xx,yy,text);
		draw_set_alpha(1);
	}*/
	DrawGenericButton(_x, _y);
}
#endregion
#region DrawSaveFileButton

noDataText = "NO DATA";
energyText = "ENERGY";
timeText = "TIME";
itemsText = "ITEMS";

fileIconFrame = 0;
fileIconFrameCounter = 0;

function DrawSaveFileButton(_x, _y)
{
	//with(other)
	{
		/*
		var col = c_black,
			alph = 0.5,
			ol_col = c_black,
			ol_alph = 0,
			frame = 0;
		if(panel.selectedButton == id)
		{
			col = c_lime;
			alph = 0.4;
			ol_col = c_lime;
			ol_alph = 0.6;
			frame = creator.fileIconFrame;
		}
		if((creator.subState == MMSubState.FileCopy || creator.subState == MMSubState.ConfirmCopy) && creator.selectedFile == fileIndex)
		{
			col = c_yellow;
			alph = 0.4;
			ol_col = c_yellow;
			ol_alph = 0.4;
		}
		
		draw_set_alpha(alph*alpha);
		draw_set_color(col);
		draw_roundrect(_x-2, _y-2, _x+width, _y+height, false);
		if(ol_alph > 0)
		{
			draw_set_alpha(ol_alph*alpha);
			draw_set_color(ol_col);
			draw_roundrect(_x-2, _y-2, _x+width, _y+height, true);
		}
		*/
		var alph = 0.5,
			btnFrame = 0,
			icoFrame = 0;
		if(panel.selectedButton == id)
		{
			alph = 0.9;
			btnFrame = 1;
			icoFrame = creator.fileIconFrame;
		}
		if((creator.subState == MMSubState.FileCopy || creator.subState == MMSubState.ConfirmCopy) && creator.selectedFile == fileIndex)
		{
			alph = 0.75;
			btnFrame = 2;
		}
		draw_sprite_stretched_ext(sprt_UI_SaveFileBtn,btnFrame,_x,_y,width,height,c_white,alph*alpha);
		
		draw_set_font(fnt_Menu);
		draw_set_align(fa_left,fa_middle);
		scr_DrawOptionText(_x+3, _y + height/2, text, c_white, alpha, 0, c_black, 0);
		
		draw_sprite_ext(sprt_UI_FileIcon, icoFrame, _x+string_width(text)+7, _y+height/2, 1, 1, 0, c_white, alpha);
		
		if(creator.selectedFile != fileIndex || creator.subState == MMSubState.FileCopy || creator.subState == MMSubState.ConfirmCopy || creator.subState == MMSubState.ConfirmDelete)
		{
			var fileEnergyMax = creator.fileEnergyMax[fileIndex],
				fileEnergy = creator.fileEnergy[fileIndex],
				filePercent = creator.filePercent[fileIndex],
				fileTime = creator.fileTime[fileIndex];
			if(fileTime < 0)
			{
				draw_set_font(fnt_GUI);
				draw_set_align(fa_center,fa_middle);
				scr_DrawOptionText(_x+width/2, _y+height/2, creator.noDataText, c_white,1,0,c_black,0);
			}
			else
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small2);
				var str = creator.timeText,
					strW = string_width(str);
				scr_DrawOptionText(_x+width-strW/2-22, _y+height/2-8, str, c_white,1,0,c_black,0);
				
				var minute = scr_floor(fileTime / 60);
				var hour = scr_floor(minute / 60);
				while(minute >= 60)
				{
					minute -= 60;
				}
				var tStr = string_format(hour,2,0)+":"+string_format(minute,2,0);
				tStr = string_replace_all(tStr," ","0");
				draw_set_font(fnt_Menu2);
				scr_DrawOptionText(_x+width-strW/2-21, _y+height/2+1, tStr, c_white,1,0,c_black,0);
			}
			if(filePercent >= 0)
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small2);
				var px = _x+width/2+52,
					str = creator.itemsText,
					strW = string_width(creator.itemsText),
					strH = string_height(creator.itemsText);
				scr_DrawOptionText(px, _y+height/2-8, str, c_white,1,0,c_black,0);
				
				var percent = scr_floor(filePercent);
				var pStr = string_format(percent,2,0)+"%";
				pStr = string_replace_all(pStr," ","0");
				draw_set_font(fnt_Menu2);
				scr_DrawOptionText(px, _y+height/2+1, pStr, c_white,1,0,c_black,0);
			}
			if(fileEnergyMax >= 0)
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small2);
				var tx = _x+width/2-16,
					ty = _y+height/2-7,
					str = creator.energyText,
					strW = string_width(str),
					strH = string_height(str);
				scr_DrawOptionText(tx-(strW/2)-2, ty-1, str, c_white, 1, 0, c_black, 0);
			
				draw_set_font(fnt_Menu);
				str = string(fileEnergy);
				str = string_char_at(str,string_length(str)-1)+string_char_at(str,string_length(str));
				scr_DrawOptionText(tx-(strW/2)-2, ty+strH-3, str, c_white,1,0,c_black,0);
			
				var energyTanks = floor(fileEnergyMax / 100),
					statEnergyTanks = floor(fileEnergy / 100);
				if(energyTanks > 0)
				{
					for(var j = 0; j < energyTanks; j++)
					{
						var eX = tx + (7*j)/2,
							eY = ty;
						if(j%2 != 0)
						{
							eX = tx + (7*(j-1))/2;
							eY = ty+7;
						}
						draw_sprite_ext(sprt_HUD_ETank,(statEnergyTanks > j),floor(eX),floor(eY),1,1,0,c_white,1);
					}
				}
			}
		}
	}
}
#endregion
#region DrawConfirmPanel
function DrawConfirmPanel(_x, _y)
{
	//with(other)
	{
		alpha = min(alpha+0.15,1);
		
		var col = c_black,
			alph = 0.75,
			//ol_col = c_lime,
			ol_alph = 0.75;
		draw_set_color(col);
		draw_set_alpha(alph*alpha);
		draw_rectangle(_x, _y, _x+width, _y+height, false);
		
		/*draw_set_color(ol_col);
		draw_set_alpha(ol_alph*alpha);
		draw_line(_x, _y, _x+width, _y);
		draw_line(_x, _y+height, _x+width, _y+height);
		
		var w2 = 8;
		for(var i = 0; i < w2; i++)
		{
			draw_set_color(col);
			draw_set_alpha(alph*alpha * ((w2-i)/w2));
			draw_line(_x-i-1, _y-1, _x-i-1, _y+height);
			draw_line(_x+width+i+1, _y-1, _x+width+i+1, _y+height);
			
			draw_set_color(ol_col);
			draw_set_alpha(ol_alph*alpha * ((w2-i)/w2));
			draw_point(_x-i, _y);
			draw_point(_x-i, _y+height);
			draw_point(_x+width+i+1, _y);
			draw_point(_x+width+i+1, _y+height);
		}*/
		draw_sprite_stretched_ext(sprt_UI_GenericButton,0, _x,_y, width,height, c_white,ol_alph*alpha);
		
		var _sx = _x+width/2, _sy = _y+4;
		draw_set_font(fnt_Menu2);
		draw_set_align(fa_center,fa_top);
		draw_set_alpha(alpha);
		draw_set_color(c_black);
		draw_text(_sx+1,_sy+1,text);
		draw_set_color(c_white);
		draw_text(_sx,_sy,text);
		draw_set_alpha(1);
		
		for(var i = 0; i < ds_list_size(buttonList); i++)
		{
			var btn = buttonList[| i];
			btn.DrawButton(btn.GetX(),btn.GetY());
		}
	}
}
#endregion

buttonTipY = 0;
buttonTip = [
"Move",
"Select",
"Back",
"Cancel"];

buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1]+"   ${menuCancelButton} - "+buttonTip[2];
buttonTipScrib = scribble(buttonTipString);
buttonTipScrib.starting_format("fnt_GUI_Small2",c_white);
buttonTipScrib.align(fa_center,fa_middle);

