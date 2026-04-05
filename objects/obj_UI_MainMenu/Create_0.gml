/// @description 
event_inherited();
screenFade = 1;

enum UI_MMState
{
	TitleIntro,
	Title,
	MainMenu,
	FileMenu,
	LoadGame
}
state = UI_MMState.TitleIntro;
targetState = state;

enum UI_MMSubState
{
	None,
	FileSelected,
	FileCopy,
	ConfirmCopy,
	ConfirmDelete
}
subState = UI_MMSubState.None;

titleAlpha = 0;
pressStartAnim = 0;
startString = "PRESS START";

selectedFile = -1;
copyFile = -1;

fileTime = array_create(5, -1);
filePercent = array_create(5, -1);
fileEnergyMax = array_create(5, -1);
fileEnergy = array_create(5, -1);

itemList = ds_list_create();

#region Main Menu Page

mainMenuText = [
"START GAME",
"SETTINGS",
"QUIT GAME"];

mainMenuPage = noone;
function CreateMainMenuPage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	draw_set_font(fnt_GUI);
	
	mainMenuPage = self.CreatePage();
	
	var btn = [],
		btnW = 104,
		btnH = 11;//9;
	for(var i = 0; i < array_length(mainMenuText); i++)
	{
		var str = mainMenuText[i];
		btn[i] = mainMenuPage.CreateUIButton(, ww/2 - btnW/2, hh/2 + 48 + 12*i, btnW, btnH, str);
		btn[i].sprtAlpha = 0.75;
		btn[i].sprtSelectAlpha = 0.85;
	}
	
	btn[0].SetNavElements(btn[2],btn[1]);
	btn[0].OnClick = function()
	{
		targetState = UI_MMState.FileMenu;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	btn[1].SetNavElements(btn[0],btn[2]);
	btn[1].OnClick = function()
	{
		if(obj_UI_SettingsMenu.activeState == UI_ActiveState.Inactive)
		{
			obj_UI_SettingsMenu.activeState = UI_ActiveState.Activating;
		}
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	btn[2].SetNavElements(btn[1],btn[0]);
	btn[2].OnClick = function()
	{
		instance_deactivate_object(all);
		game_end();
	}
}

#endregion
#region File Menu Page

fileMenuText = [
"FILE A",
"FILE B",
"FILE C",
"FILE D",
"FILE E",
"BACK"];

fileMenuPage = noone;
function CreateFileMenuPage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	fileMenuPage = self.CreatePage(,1);
	
	var fBtnSprt = sprt_UI_SaveFileBtn,
		fBtnW = 248,
		fBtnH = 32,
		fBtnSpace = fBtnH+4;
	
	var fileBtn = [];
	for(var i = 0; i < array_length(fileMenuText)-1; i++)
	{
		fileBtn[i] = fileMenuPage.CreateUIButton(, ww/2 - fBtnW/2, 24 + fBtnSpace*i, fBtnW, fBtnH, fileMenuText[i]);
		fileBtn[i].fileIndex = i;
		fileBtn[i].OnClick = function()
		{
			with(other)
			{
				creatorUI.subState = UI_MMSubState.FileSelected;
				creatorUI.selectedFile = fileIndex;
				creatorUI.CreateSelectedFilePage(self.GetY(), fileIndex);
			}
			
			audio_play_sound(snd_MenuTick,0,false);
		}
		fileBtn[i].PreDraw = DrawSaveFileButton;
	}
	
	draw_set_font(fnt_GUI);
	var str = fileMenuText[5];
	//var bBtnW = max(string_width(str),48), bBtnH = string_height(str)+1;
	var bBtnW = 56, 
		bBtnH = 11;//9;
	var backBtn = fileMenuPage.CreateUIButton(, ww/2 - 96, hh - 32, bBtnW, bBtnH, str);
	backBtn.sprtAlpha = 0.75;
	backBtn.sprtSelectAlpha = 0.85;
	backBtn.OnClick = function()
	{
		targetState = UI_MMState.MainMenu;
		audio_play_sound(snd_MenuTick,0,false);
	}
	backBtn.HotKey = function()
	{
		return (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
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
		
		fileBtn[i].SetNavElements(prevB,nextB);
	}
	backBtn.SetNavElements(fileBtn[4],fileBtn[0]);
}

#endregion
#region Selected File Page

fileOptionText = [
"START GAME",
"CANCEL",
"COPY FILE",
"DELETE FILE"];

selectedFilePage = noone;
function CreateSelectedFilePage(_yoffset, _fileIndex)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	var fBtnW = 248,
		fBtnH = 32;
	
	selectedFilePage = self.CreatePage(,1);
	var sfPanel = selectedFilePage.CreateUIPanel(, ww/2-fBtnW/2, _yoffset, fBtnW, fBtnH)
	sfPanel.fileIndex = _fileIndex;
	
	draw_set_font(fnt_GUI);
	var btnW = 78,//72;
		btnH = 11;//9;
	
	var str = fileOptionText[0];
	var startGameBtn = sfPanel.CreateUIButton(, fBtnW/2 - btnW/2, fBtnH/2 - 12, btnW, btnH, str);
	startGameBtn.OnClick = function()
	{
		targetState = UI_MMState.LoadGame;
		audio_play_sound(snd_MenuShwsh,0,false);
	}
	
	str = fileOptionText[1];
	var cancelBtn = sfPanel.CreateUIButton(, fBtnW/2 - btnW/2, fBtnH/2 + 1, btnW, btnH, str);
	cancelBtn.OnClick = function()
	{
		subState = UI_MMSubState.None;
		selectedFile = -1;
		instance_destroy(selectedFilePage);
		audio_play_sound(snd_MenuTick,0,false);
	}
	cancelBtn.HotKey = function()
	{
		return (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
	}
	
	startGameBtn.SetNavElements(cancelBtn,cancelBtn);
	cancelBtn.SetNavElements(startGameBtn,startGameBtn);
	
	if(file_exists(scr_GetFileName(_fileIndex)))
	{
		startGameBtn.x = scr_floor(fBtnW/2 - 52);
		cancelBtn.x = scr_floor(fBtnW/2 - 52);
		
		str = fileOptionText[2];
		var copyBtn = sfPanel.CreateUIButton(, fBtnW/2 + 28, fBtnH/2 - 12, btnW, btnH, str);
		copyBtn.OnClick = function()
		{
			subState = UI_MMSubState.FileCopy;
			self.CreateCopyFilePage();
			audio_play_sound(snd_MenuTick,0,false);
		}
		
		str = fileOptionText[3];
		var deleteBtn = sfPanel.CreateUIButton(, fBtnW/2 + 28, fBtnH/2 + 1, btnW, btnH, str);
		deleteBtn.OnClick = function()
		{
			subState = UI_MMSubState.ConfirmDelete;
			self.CreateConfirmDeletePage();
			audio_play_sound(snd_MenuBoop,0,false);
		}
	
		startGameBtn.SetNavElements(,,copyBtn,copyBtn);
		cancelBtn.SetNavElements(,,deleteBtn,deleteBtn);
		copyBtn.SetNavElements(deleteBtn,deleteBtn,startGameBtn,startGameBtn);
		deleteBtn.SetNavElements(copyBtn,copyBtn,cancelBtn,cancelBtn);
	}
}

#endregion
#region Copy File Page

copyFileText = [
"FILE A",
"FILE B",
"FILE C",
"FILE D",
"FILE E",
"CANCEL"];

copyFilePage = noone;
function CreateCopyFilePage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	copyFilePage = self.CreatePage(,1);
	
	var cBtnW = 248,
		cBtnH = 32,
		cBtnSpace = 36;
	
	var copyBtn = [];
	for(var i = 0; i < array_length(copyFileText)-1; i++)
	{
		copyBtn[i] = copyFilePage.CreateUIButton(, ww/2 - cBtnW/2, 24 + cBtnSpace*i, cBtnW, cBtnH, copyFileText[i]);
		copyBtn[i].fileIndex = i;
		copyBtn[i].OnClick = function()
		{
			subState = UI_MMSubState.ConfirmCopy;
			self.CreateConfirmCopyPage(selectedFile, other.fileIndex);
			audio_play_sound(snd_MenuBoop,0,false);
		}
		copyBtn[i].PreDraw = DrawSaveFileButton;
		
		if(copyBtn[i].fileIndex == selectedFile)
		{
			copyBtn[i].active = false;
		}
	}
	if(!copyBtn[0].active)
	{
		copyFilePage.SelectElement(copyBtn[1],false);
	}
	
	var cbtn = array_length(copyFileText)-1;
	draw_set_font(fnt_GUI);
	var str = copyFileText[5];
	//var bBtnW = max(string_width(str),48), bBtnH = string_height(str)+1;
	var bBtnW = 56, 
		bBtnH = 11;//9;
	copyBtn[cbtn] = copyFilePage.CreateUIButton(, ww/2 - 96, hh - 32, bBtnW, bBtnH, str);
	copyBtn[cbtn].sprtAlpha = 0.75;
	copyBtn[cbtn].sprtSelectAlpha = 0.85;
	copyBtn[cbtn].OnClick = function()
	{
		subState = UI_MMSubState.FileSelected;
		instance_destroy(copyFilePage);
		audio_play_sound(snd_MenuTick,0,false);
	}
	copyBtn[cbtn].HotKey = function()
	{
		return (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
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
		
		copyBtn[i].SetNavElements(prevB,nextB);
	}
}

#endregion
#region Confirm Copy Page

confirmCopyText = [
"COPYING ",
" TO ",
"ARE YOU SURE?",
"YES",
"NO"];

confirmCopyPage = noone;
function CreateConfirmCopyPage(srcFile, destFile)
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	draw_set_font(fnt_Menu2);
	var str = confirmCopyText[0] + "[c_yellow][["+copyFileText[srcFile]+"][/c]" + confirmCopyText[1] + "[c_yellow][["+copyFileText[destFile]+"][/c]" + "\n\n" + confirmCopyText[2];
	var pnlW = 248,
		pnlH = string_height(str) + 24;
	confirmCopyPage = self.CreatePage();
	var ccPanel = confirmCopyPage.CreateUIPanel(, ww/2 - pnlW/2, hh/2 - pnlH/2, pnlW, pnlH);
	ccPanel.text = str;
	ccPanel.PreDraw = DrawConfirmPanel;
	
	var btnW = 31,
		btnH = 11;
	
	str = confirmCopyText[3];
	var yesBtn = ccPanel.CreateUIButton(, pnlW/2 - 16 - btnW, pnlH - btnH - 4, btnW, btnH, str);
	yesBtn.sprt = sprt_UI_Button2;
	yesBtn.srcFile = srcFile;
	yesBtn.destFile = destFile;
	yesBtn.OnClick = function()
	{
		scr_DeleteGame(other.destFile);
		file_copy(scr_GetFileName(other.srcFile),scr_GetFileName(other.destFile));
		fileTime[other.destFile] = -1;
		
		selectedFile = -1;
		subState = UI_MMSubState.None;
		instance_destroy(copyFilePage);
		instance_destroy(selectedFilePage);
		confirmCopyPage.active = false;
		
		for(var j = 0; j < ds_list_size(fileMenuPage.elements); j++)
		{
			var fmpBtn = fileMenuPage.elements[| j];
			if(fmpBtn.fileIndex == other.destFile)
			{
				fileMenuPage.SelectElement(fmpBtn,false);
			}
		}
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	str = confirmCopyText[4];
	var noBtn = ccPanel.CreateUIButton(, pnlW/2 + 16, pnlH - btnH - 4, btnW, btnH, str);
	noBtn.sprt = sprt_UI_Button2;
	noBtn.OnClick = function()
	{
		subState = UI_MMSubState.FileCopy;
		confirmCopyPage.active = false;
		audio_play_sound(snd_MenuTick,0,false);
	}
	noBtn.HotKey = function()
	{
		return (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
	}
	
	yesBtn.SetNavElements(,,noBtn,noBtn);
	noBtn.SetNavElements(,,yesBtn,yesBtn);
	
	confirmCopyPage.SelectElement(noBtn,false);
}

#endregion
#region Confirm Delete Page

confirmDeleteText = [
"DELETING ",
"ARE YOU SURE?",
"YES",
"NO"];

confirmDeletePage = noone;
function CreateConfirmDeletePage()
{
	var ww = global.resWidth,
		hh = global.resHeight;
	
	draw_set_font(fnt_Menu2);
	var str = confirmDeleteText[0] + "[c_yellow][["+fileMenuText[selectedFile]+"][/c]" + "\n\n" + confirmDeleteText[1];
	var pnlW = 248,
		pnlH = string_height(str) + 24;
	confirmDeletePage = self.CreatePage();
	var cdPanel = confirmDeletePage.CreateUIPanel(, ww/2 - pnlW/2, hh/2 - pnlH/2, pnlW, pnlH);
	cdPanel.text = str;
	cdPanel.PreDraw = DrawConfirmPanel;
	
	var btnW = 31,
		btnH = 11;
	
	str = confirmDeleteText[2];
	var yesBtn = cdPanel.CreateUIButton(, pnlW/2 - 16 - btnW, pnlH - btnH - 4, btnW, btnH, str);
	yesBtn.sprt = sprt_UI_Button2;
	yesBtn.OnClick = function()
	{
		scr_DeleteGame(selectedFile);
		fileTime[selectedFile] = -1;
		selectedFile = -1;
		subState = UI_MMSubState.None;
		instance_destroy(selectedFilePage);
		confirmDeletePage.active = false;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	
	str = confirmDeleteText[3];
	var noBtn = cdPanel.CreateUIButton(, pnlW/2 + 16, pnlH - btnH - 4, btnW, btnH, str);
	noBtn.sprt = sprt_UI_Button2;
	noBtn.OnClick = function()
	{
		subState = UI_MMSubState.FileSelected;
		confirmDeletePage.active = false;
		audio_play_sound(snd_MenuTick,0,false);
	}
	noBtn.HotKey = function()
	{
		return (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
	}
	
	yesBtn.SetNavElements(,,noBtn,noBtn);
	noBtn.SetNavElements(,,yesBtn,yesBtn);
	
	confirmDeletePage.SelectElement(noBtn,false);
}

#endregion

#region DrawSaveFileButton

noDataText = "NO DATA";
energyText = "ENERGY";
timeText = "TIME";
itemsText = "ITEMS";

fileIconFrame = 0;
fileIconFrameCounter = 0;

function DrawSaveFileButton()
{
	//with(other)
	//{
		var _x = self.GetX(),
			_y = self.GetY();
		
		var alph = 0.75,
			btnFrame = 0,
			icoFrame = 0;
		if(self.IsSelected())
		{
			alph = 0.85;
			btnFrame = 1;
			icoFrame = creatorUI.fileIconFrame;
		}
		if((creatorUI.subState == UI_MMSubState.FileCopy || creatorUI.subState == UI_MMSubState.ConfirmCopy) && creatorUI.selectedFile == fileIndex)
		{
			alph = 0.75;
			btnFrame = 2;
		}
		draw_sprite_stretched_ext(sprt_UI_SaveFileBtn,btnFrame,_x,_y,width,height,c_white,alph*alpha);
		
		draw_set_font(fnt_Menu);
		draw_set_align(fa_left,fa_middle);
		scr_DrawOptionText(_x+3, _y + height/2, text, c_white, alpha, 0, c_black, 0);
		
		draw_sprite_ext(sprt_UI_FileIcon, icoFrame, _x+string_width(text)+7, _y+height/2, 1, 1, 0, c_white, alpha);
		
		if(creatorUI.selectedFile != fileIndex || creatorUI.subState == UI_MMSubState.FileCopy || creatorUI.subState == UI_MMSubState.ConfirmCopy || creatorUI.subState == UI_MMSubState.ConfirmDelete)
		{
			var fileEnergyMax = creatorUI.fileEnergyMax[fileIndex],
				fileEnergy = creatorUI.fileEnergy[fileIndex],
				filePercent = creatorUI.filePercent[fileIndex],
				fileTime = creatorUI.fileTime[fileIndex];
			if(fileTime < 0)
			{
				draw_set_font(fnt_GUI);
				draw_set_align(fa_center,fa_middle);
				scr_DrawOptionText(_x+width/2, _y+height/2, creatorUI.noDataText, c_white,1,0,c_black,0);
			}
			else
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small2);
				var str = creatorUI.timeText,
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
					str = creatorUI.itemsText,
					strW = string_width(creatorUI.itemsText),
					strH = string_height(creatorUI.itemsText);
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
					str = creatorUI.energyText,
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
	//}
}
#endregion
#region DrawConfirmPanel
function DrawConfirmPanel()
{
	//with(other)
	//{
		var _x = self.GetX(),
			_y = self.GetY();
		
		var _alpha = self.GetAlpha();
		
		var ww = global.resWidth,
			hh = global.resHeight;
		
		draw_set_color(c_black);
		draw_set_alpha(0.5 * _alpha);
		draw_rectangle(-1,-1,ww+1,hh+1,false);
		draw_set_alpha(0.75 * _alpha);
		draw_rectangle(_x, _y, _x+width, _y+height, false);
		
		var ol_alph = 0.75;
		draw_sprite_stretched_ext(sprt_UI_Button,0, _x,_y, width,1, c_white,ol_alph*_alpha);
		draw_sprite_stretched_ext(sprt_UI_Button,0, _x,_y+height-1, width,1, c_white,ol_alph*_alpha);
		
		var _sx = _x+width/2, _sy = _y+4;
		draw_set_font(fnt_Menu2);
		draw_set_align(fa_center,fa_top);
		draw_set_alpha(_alpha);
		draw_set_color(c_black);
		//draw_text(_sx+1,_sy+1,text);
		draw_text_scribble(_sx+1,_sy+1,text);
		draw_set_color(c_white);
		//draw_text(_sx,_sy,text);
		draw_text_scribble(_sx,_sy,text);
		draw_set_alpha(1);
		
		return true;
	//}
}
#endregion

footerY = 0;
footerText = [
"Move",
"Select",
"Back",
"Cancel"];

footerString[0] = "${MenuMove} - "+footerText[0]+"   ${MenuAccept_0} - "+footerText[1];
footerString[1] = "${MenuMove} - "+footerText[0]+"   ${MenuAccept_0} - "+footerText[1]+"   ${MenuCancel_0} - "+footerText[2];
footerString[2] = "${MenuMove} - "+footerText[0]+"   ${MenuAccept_0} - "+footerText[1]+"   ${MenuCancel_0} - "+footerText[3];
footerScrib = scribble(footerString[0]).starting_format("fnt_GUI_Small2",c_white).align(fa_center,fa_middle);
