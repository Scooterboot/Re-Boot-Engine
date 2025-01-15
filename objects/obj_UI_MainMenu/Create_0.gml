/// @description 
event_inherited();

enum MMState
{
	TitleIntro,
	Title,
	MainMenu,
	FileSelect,
	FileCopy,
	LoadGame
}
state = MMState.TitleIntro;
targetState = state;

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
	if(moveCounterX >= moveCounterMax)
	{
		return cRight - cLeft;
	}
	return (cRight && rRight) - (cLeft && rLeft);
}
function MoveSelectY()
{
	if(moveCounterY >= moveCounterMax)
	{
		return cDown - cUp;
	}
	return (cDown && rDown) - (cUp && rUp);
}

selectedFile = -1;
copyFile = -1;

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
	
	var btn = [];
	for(var i = 0; i < array_length(mainMenuText); i++)
	{
		var str = mainMenuText[i];
		btn[i] = mainMenuPanel.CreateButton(0,hh/2 + 48 + 12*i, string_width(str), string_height(str), str);
		btn[i].x = ww/2 - btn[i].width/2;
		btn[i].DrawButton = DrawGenericButton;
	}
	
	btn[0].button_up = btn[2];
	btn[0].button_down = btn[1];
	btn[0].OnClick = function()
	{
		targetState = MMState.FileSelect;
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
		exit;
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
	
	var fBtnW = 248,
		fBtnH = 32,
		fBtnSpace = 36;
	
	var fileBtn = [];
	for(var i = 0; i < 5; i++)
	{
		fileBtn[i] = fileMenuPanel.CreateButton(ww/2 - fBtnW/2, 24 + fBtnSpace*i, fBtnW, fBtnH, fileMenuText[i]);
		fileBtn[i].fileIndex = i;
		fileBtn[i].OnClick = function()
		{
			with(other)
			{
				creator.selectedFile = fileIndex;
				creator.CreateSelectedFileMenu(GetY(),fileIndex);
			}
			
			audio_play_sound(snd_MenuTick,0,false);
		}
		fileBtn[i].DrawButton = DrawSaveFileButton;
	}
	
	draw_set_font(fnt_GUI);
	var str = fileMenuText[5];
	var backBtn = fileMenuPanel.CreateButton(ww/2 - 96, hh - 32, string_width(str), string_height(str), str);
	backBtn.DrawButton = DrawGenericButton;
	backBtn.OnClick = function()
	{
		targetState = MMState.MainMenu;
		audio_play_sound(snd_MenuTick,0,false);
	}
	backBtn.fileIndex = -1;
	
	for(var i = 0; i < 5; i++)
	{
		var prevB = backBtn;
		if(i > 0)
		{
			prevB = fileBtn[i-1]
		}
		var nextB = backBtn;
		if(i < 4)
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
	var btnW = 72;
	
	var str = fileOptionText[0];
	var startGameBtn = selectedFilePanel.CreateButton(fBtnW/2 - 40, 0, btnW, string_height(str), str);
	startGameBtn.y = fBtnH/2 - startGameBtn.height - 2;
	startGameBtn.OnClick = function()
	{
		targetState = MMState.LoadGame;
		audio_play_sound(snd_MenuShwsh,0,false);
	}
	startGameBtn.DrawButton = DrawGenericButton;
	
	str = fileOptionText[1];
	var cancelBtn = selectedFilePanel.CreateButton(fBtnW/2 - 40, 0, btnW, string_height(str), str);
	cancelBtn.y = fBtnH/2 + 2;
	cancelBtn.OnClick = function()
	{
		selectedFile = -1;
		audio_play_sound(snd_MenuTick,0,false);
	}
	cancelBtn.DrawButton = DrawGenericButton;
	
	startGameBtn.button_up = cancelBtn;
	startGameBtn.button_down = cancelBtn;
	cancelBtn.button_up = startGameBtn;
	cancelBtn.button_down = startGameBtn;
	
	if(file_exists(scr_GetFileName(_fileIndex)))
	{
		str = fileOptionText[2];
		var copyBtn = selectedFilePanel.CreateButton(fBtnW/2 + 38, 0, btnW, string_height(str), str);
		copyBtn.y = fBtnH/2 - copyBtn.height - 2;
		copyBtn.OnClick = function()
		{
			targetState = MMState.FileCopy;
			state = targetState;
			
			CreateCopyMenu(selectedFile);
		}
		copyBtn.DrawButton = DrawGenericButton;
		
		str = fileOptionText[3];
		var deleteBtn = selectedFilePanel.CreateButton(fBtnW/2 + 38, 0, btnW, string_height(str), str);
		deleteBtn.y = fBtnH/2 + 2;
		deleteBtn.OnClick = function()
		{
			scr_DeleteGame(selectedFile);
			fileTime[selectedFile] = -1;
			selectedFile = -1;
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
function CreateCopyMenu(_fileIndex)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	copyFilePanel = CreatePanel(0,0,ww,hh);
	
	var cBtnW = 248,
		cBtnH = 32,
		cBtnSpace = 36;
	
	var copyBtn = [];
	for(var i = 0; i < 5; i++)
	{
		copyBtn[i] = copyFilePanel.CreateButton(ww/2 - cBtnW/2, 24 + cBtnSpace*i, cBtnW, cBtnH, copyFileText[i]);
		copyBtn[i].fileIndex = i;
		copyBtn[i].OnClick = function()
		{
			scr_DeleteGame(other.fileIndex);
			file_copy(scr_GetFileName(selectedFile),scr_GetFileName(other.fileIndex));
			fileTime[other.fileIndex] = -1;
			
			targetState = MMState.FileSelect;
			state = targetState;
			instance_destroy(selectedFilePanel);
			selectedFile = -1;
			
			for(var j = 0; j < ds_list_size(fileMenuPanel.buttonList); j++)
			{
				var fmpBtn = fileMenuPanel.buttonList[| j];
				if(fmpBtn.fileIndex == other.fileIndex)
				{
					fileMenuPanel.selectedButton = fmpBtn;
				}
			}
			
			audio_play_sound(snd_MenuBoop,0,false);
		}
		copyBtn[i].DrawButton = DrawSaveFileButton;
		
		if(copyBtn[i].fileIndex == selectedFile)
		{
			copyBtn[i].GetMouse = function(){}
		}
	}
	copyFilePanel.selectedButton = copyBtn[0];
	if(copyBtn[0].fileIndex == selectedFile)
	{
		copyFilePanel.selectedButton = copyBtn[1];
	}
	
	draw_set_font(fnt_GUI);
	var str = copyFileText[5];
	var cancelBtn = copyFilePanel.CreateButton(ww/2 - 96, hh - 32, string_width(str), string_height(str), str);
	cancelBtn.DrawButton = DrawGenericButton;
	cancelBtn.OnClick = function()
	{
		targetState = MMState.FileSelect;
		state = targetState;
		audio_play_sound(snd_MenuTick,0,false);
	}
	
	for(var i = 0; i < 5; i++)
	{
		var prevB = cancelBtn;
		if(i > 0)
		{
			prevB = copyBtn[i-1];
		}
		if(i > 1 && copyBtn[i-1].fileIndex == selectedFile)
		{
			prevB = copyBtn[i-2];
		}
		var nextB = cancelBtn;
		if(i < 4)
		{
			nextB = copyBtn[i+1];
		}
		if(i < 3 && copyBtn[i+1].fileIndex == selectedFile)
		{
			nextB = copyBtn[i+2];
		}
		
		copyBtn[i].button_up = prevB;
		copyBtn[i].button_down = nextB;
	}
	
	cancelBtn.button_up = copyBtn[4];
	if(copyBtn[4].fileIndex == selectedFile)
	{
		cancelBtn.button_up = copyBtn[3];
	}
	cancelBtn.button_down = copyBtn[0];
	if(copyBtn[0].fileIndex == selectedFile)
	{
		cancelBtn.button_down = copyBtn[1];
	}
}
#endregion

fileTime = [-1,-1,-1,-1,-1];
filePercent = [-1,-1,-1,-1,-1];
fileEnergyMax = [-1,-1,-1,-1,-1];
fileEnergy = [-1,-1,-1,-1,-1];

itemList = ds_list_create();

noDataText = "NO DATA";
energyText = "ENERGY";
timeText = "TIME";
itemsText = "ITEMS";

fileIconFrame = 0;
fileIconFrameCounter = 0;

#region DrawGenericButton
function DrawGenericButton(_x, _y)
{
	with(other) // <- i shouldn't have to do this, but it'll throw errors if i dont.
	{
		var col = c_black,
			alph = 0.5;
		if(panel.selectedButton == id)
		{
			col = c_white;
			alph = 0.25;
			if(panel == creator.mainMenuPanel)
			{
				alph = 0.75;
			}
		}
		var alph2 = alpha*panel.alpha;
		
		draw_set_font(fnt_GUI);
		draw_set_align(fa_left,fa_top);
		scr_DrawOptionText(_x, _y, text, c_white, alph2, max(string_width(text),width), col, alph*alph2);
	}
}
#endregion
#region DrawSaveFileButton
function DrawSaveFileButton(_x, _y)
{
	with(other)
	{
		var col = c_black,
			alph = 0.5,
			frame = 0;
		if(panel.selectedButton == id)
		{
			col = c_white;
			alph = 0.25;
			frame = creator.fileIconFrame;
		}
		if(creator.state == MMState.FileCopy && creator.selectedFile == fileIndex)
		{
			col = c_yellow;
			alph = 0.4;
		}
		
		draw_set_alpha(alph*alpha);
		draw_set_color(col);
		draw_roundrect(_x-2, _y-2, _x+width, _y+height, false);
		
		draw_set_font(fnt_Menu);
		draw_set_align(fa_left,fa_middle);
		scr_DrawOptionText(_x+2, _y + height/2, text, c_white, alpha, 0, c_black, 0);
		
		draw_sprite_ext(sprt_UI_FileIcon, frame, _x+string_width(text)+8, _y+height/2, 1, 1, 0, c_white, alpha);
		
		if(creator.selectedFile != fileIndex || creator.state == MMState.FileCopy)
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
			
				scr_DrawOptionText(_x+width-strW/2-12, _y+height/2-8, str, c_white,1,0,c_black,0);
				var minute = scr_floor(fileTime / 60);
				var hour = scr_floor(minute / 60);
				while(minute >= 60)
				{
					minute -= 60;
				}
				var tStr = string_format(hour,2,0)+":"+string_format(minute,2,0);
				tStr = string_replace_all(tStr," ","0");
			
				draw_set_font(fnt_Menu2);
				scr_DrawOptionText(_x+width-strW/2-11, _y+height/2+1, tStr, c_white,1,0,c_black,0);
			}
			if(fileEnergyMax >= 0)
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small2);
				var tx = _x+width/2-10,
					ty = _y+height/2-7,
					str = creator.energyText,
					strW = string_width(str),
					strH = string_height(str);
				scr_DrawOptionText(tx-(strW/2)-2, ty-1, str, c_white, 1, 0, c_black, 0);
			
				draw_set_font(fnt_Menu);
				var str = string(fileEnergy);
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
						draw_sprite_ext(sprt_UI_HETank,(statEnergyTanks > j),floor(eX),floor(eY),1,1,0,c_white,1);
					}
				}
			}
			if(filePercent >= 0)
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small2);
				var px = _x+width/2+60,
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
		}
	}
}
#endregion

buttonTipY = 0;
buttonTip = array(
"Move",
"Select",
"Back",
"Cancel");

buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1]+"   ${menuCancelButton} - "+buttonTip[2];
buttonTipScrib = scribble(buttonTipString);
buttonTipScrib.starting_format("fnt_GUI_Small2",c_white);
buttonTipScrib.align(fa_center,fa_middle);

