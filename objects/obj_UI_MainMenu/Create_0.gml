/// @description 
event_inherited();
screenFade = 1;

cleanUp = true;

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

inputBlockLayer = "input block";

#region Main Menu

mainMenuText = [
"START GAME",
"SETTINGS",
"QUIT GAME"];

mainMenuLayer = "main menu";
function CreateMainMenu()
{
	var ww = global.resWidth,
		hh = global.resHeight,
		this = id;
	
	var _layer = BentoLayerCreate(mainMenuLayer),
		_root = BentoLayerGetRoot(_layer);
	
	var _mainElement = new BentoUI_Spacer(_root);
	with(_mainElement)
	{
		BentoLayoutSetGutter(0, 1);
		BentoLayoutSetResize(BENTO_RESIZE_INFLATE, BENTO_RESIZE_INFLATE);
		BentoLayoutList(BENTO_AXIS_Y, 0.5, 0);
		BentoSetPosition(0, hh/2 + 48);
	}
	
	var btn = [],
		btnFunc = [],
		btnW = 104,
		btnH = 11;
	
	btnFunc[0] = function()
	{
		creatorUI.targetState = UI_MMState.FileMenu;
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btnFunc[1] = function()
	{
		//if(obj_UI_SettingsMenu.activeState == UI_ActiveState.Inactive)
		//{
		//	obj_UI_SettingsMenu.activeState = UI_ActiveState.Activating;
		//}
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	btnFunc[2] = function()
	{
		instance_deactivate_all(false);
		game_end();
	}
	
	for(var i = 0; i < array_length(mainMenuText); i++)
	{
		btn[i] = new BentoUI_Button(btnFunc[i], btnW, btnH, mainMenuText[i], this, _mainElement);
		btn[i].sprtAlpha = 0.75;
		btn[i].sprtSelectAlpha = 0.85;
		
		BentoAnimPlayBuildIn(7,2*i, 0,4,1,1, 0,,false,btn[i]);
	}
	BentoSetNavigationWrap(false, true, btn[0]);
	BentoSetNavigationWrap(false, true, btn[2]);
}

#endregion
#region File Menu

fileMenuText = [
"FILE A",
"FILE B",
"FILE C",
"FILE D",
"FILE E",
"BACK"];

fileMenuLayer = "file menu";
function CreateFileMenu()
{
	BentoLayerSetDrawWhenBackgrounded(false, mainMenuLayer);
	
	var ww = global.resWidth,
		hh = global.resHeight,
		this = id;
	
	var _layer = BentoLayerCreate(fileMenuLayer),
		_root = BentoLayerGetRoot(_layer);
	
	var _mainElement = new BentoUI_Spacer(_root);
	with(_mainElement)
	{
		BentoLayoutSetGutter(0, 4);
		BentoLayoutSetResize(BENTO_RESIZE_INFLATE, BENTO_RESIZE_INFLATE);
		BentoLayoutList(BENTO_AXIS_Y, 0, 0);
		BentoSetPosition(ww/2 - 124, 24);
	}
	
	var fileBtn = [],
		fBtnW = 248,
		fBtnH = 32;
	
	for(var i = 0; i < array_length(fileMenuText); i++)
	{
		if(i < array_length(fileMenuText)-1)
		{
			var fBtnFunc = function()
			{
				creatorUI.subState = UI_MMSubState.FileSelected;
				creatorUI.selectedFile = fileIndex;
				creatorUI.CreateSelectedFileMenu(self, fileIndex);
			
				audio_play_sound(snd_MenuTick,0,false);
			}
			
			fileBtn[i] = new BentoUI_Button(fBtnFunc, fBtnW, fBtnH, fileMenuText[i], this, _mainElement);
			fileBtn[i].fileIndex = i;
			fileBtn[i].eventDraw = method(fileBtn[i], DrawSaveFileButton);
			
			if(i == 0)
			{
				BentoSetNavigationWrap(false, true, fileBtn[i]);
			}
			
			BentoAnimPlayBuildIn(20, i*4, fBtnW, 0, 1, 1, 0,animCur_UI_FileBtn,false,fileBtn[i]);
		}
		else
		{
			var backFunc = function()
			{
				if(creatorUI.targetState == UI_MMState.FileMenu && creatorUI.subState == UI_MMSubState.None)
				{
					creatorUI.targetState = UI_MMState.MainMenu;
					audio_play_sound(snd_MenuTick,0,false);
				}
			}
			
			fileBtn[i] = new BentoUI_Button(backFunc, 56, 11, fileMenuText[i], this, _mainElement);
			fileBtn[i].sprtAlpha = 0.75;
			fileBtn[i].sprtSelectAlpha = 0.85;
			fileBtn[i].hotKey = fileBtn[i].hotKey_cancel;
			BentoSetOffset(0, 4, fileBtn[i]);
			
			BentoSetNavigationWrap(false, true, fileBtn[i]);
			
			BentoAnimPlayBuildIn(7,4*i, 0,4,1,1, 0,,false,fileBtn[i]);
		}
		
		BentoSetNavigationEnable(false, true, fileBtn[i]);
	}
	
	BentoNavigationLinkY(fileBtn[4],fileBtn[5]);
}

#endregion
#region Selected File Menu

fileOptionText = [
"START GAME",
"CANCEL",
"COPY FILE",
"DELETE FILE"];

selectedFileLayer = "selected file menu";
function CreateSelectedFileMenu(_fileBtn, _fileIndex)
{
	var ww = global.resWidth,
		hh = global.resHeight,
		this = id;
	
	var _layer = BentoLayerCreate(selectedFileLayer),
		_root = BentoLayerGetRoot(_layer);
	
	var btnW = 78,
		btnH = 11;
	
	var _mainElement = new BentoUI_Spacer(_root);
	with(_mainElement)
	{
		BentoLayoutSetSize(_fileBtn.bentoWidth, _fileBtn.bentoHeight);
		BentoSetPosition(_fileBtn.bentoLeft, _fileBtn.bentoTop);
		BentoLayoutSetGutter(2, 0);
		BentoLayoutList(BENTO_AXIS_X, 0.5, 0.5);
	}
	
	var _secElement1 = new BentoUI_Spacer(_mainElement);
	with(_secElement1)
	{
		BentoLayoutSetSize(btnW, _fileBtn.bentoHeight);
		BentoLayoutSetGutter(0, 2);
		BentoLayoutList(BENTO_AXIS_Y, 0.5, 0.5);
	}
	
	var startFunc = function()
	{
		creatorUI.targetState = UI_MMState.LoadGame;
		audio_play_sound(snd_MenuShwsh,0,false);
	}
	var str = fileOptionText[0];
	var startGameBtn = new BentoUI_Button(startFunc, btnW, btnH, str, this, _secElement1);
	
	var cancelFunc = function()
	{
		if(creatorUI.subState == UI_MMSubState.FileSelected)
		{
			creatorUI.subState = UI_MMSubState.None;
			creatorUI.selectedFile = -1;
			audio_play_sound(snd_MenuTick,0,false);
		}
	}
	str = fileOptionText[1];
	var cancelBtn = new BentoUI_Button(cancelFunc, btnW, btnH, str, this, _secElement1);
	cancelBtn.hotKey = cancelBtn.hotKey_cancel;
	
	//startGameBtn.SetNavElements(cancelBtn,cancelBtn);
	//cancelBtn.SetNavElements(startGameBtn,startGameBtn);
	
	if(file_exists(scr_GetFileName(_fileIndex)))
	{
		//startGameBtn.x = scr_floor(fBtnW/2 - 52);
		//cancelBtn.x = scr_floor(fBtnW/2 - 52);
		BentoSetOffset(116, , _mainElement);
		
		var _secElement2 = new BentoUI_Spacer(_mainElement);
		with(_secElement2)
		{
			BentoLayoutSetSize(btnW, _fileBtn.bentoHeight);
			BentoLayoutSetGutter(0, 1);
			BentoLayoutList(BENTO_AXIS_Y, 0.5, 0.5);
		}
		
		str = fileOptionText[2];
		var copyBtn = new BentoUI_Button(, btnW, btnH, str, this, _secElement2);
		//var copyBtn = sfPanel.CreateUIButton(fBtnW/2 + 28, fBtnH/2 - 12, btnW, btnH, str);
		//copyBtn.OnClick = method(copyBtn, function()
		//{
		//	creatorUI.subState = UI_MMSubState.FileCopy;
		//	creatorUI.CreateCopyFilePage();
		//	creatorUI.copyFilePage.UpdatePage();
		//	audio_play_sound(snd_MenuTick,0,false);
		//});
		
		str = fileOptionText[3];
		var deleteBtn = new BentoUI_Button(, btnW, btnH, str, this, _secElement2);
		//var deleteBtn = sfPanel.CreateUIButton(fBtnW/2 + 28, fBtnH/2 + 1, btnW, btnH, str);
		//deleteBtn.OnClick = method(deleteBtn, function()
		//{
		//	creatorUI.subState = UI_MMSubState.ConfirmDelete;
		//	creatorUI.CreateConfirmDeletePage();
		//	audio_play_sound(snd_MenuBoop,0,false);
		//});
	
		//startGameBtn.SetNavElements(,,copyBtn,copyBtn);
		//cancelBtn.SetNavElements(,,deleteBtn,deleteBtn);
		//copyBtn.SetNavElements(deleteBtn,deleteBtn,startGameBtn,startGameBtn);
		//deleteBtn.SetNavElements(copyBtn,copyBtn,cancelBtn,cancelBtn);
	}
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
	var _x = bentoLeft,
		_y = bentoTop,
		width = bentoWidth,
		height = bentoHeight,
		alpha = image_alpha,
		_text = getText();
	
	var alph = 0.75,
		btnFrame = 0,
		icoFrame = 0;
	if(BentoCursorGetHover() || creatorUI.selectedFile == fileIndex)
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
	
	draw_set_alpha(alpha);
	draw_set_font(fnt_Menu);
	draw_set_align(fa_left,fa_middle);
	draw_text_shadow(scr_round(_x+3), scr_round(_y+height/2), _text);
	
	draw_sprite_ext(sprt_UI_FileIcon, icoFrame, scr_round(_x+string_width(_text)+7), scr_round(_y+height/2), 1, 1, 0, c_white, alpha);
	
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
			draw_text_shadow(scr_round(_x+width/2), scr_round(_y+height/2), creatorUI.noDataText);
		}
		else
		{
			draw_set_align(fa_center,fa_top);
			draw_set_font(fnt_GUI_Small);
			var str = creatorUI.timeText,
				strW = string_width(str);
			draw_text_shadow(scr_round(_x+width-strW/2-22), scr_round(_y+height/2-9), str);
			
			var minute = scr_floor(fileTime / 60);
			var hour = scr_floor(minute / 60);
			while(minute >= 60)
			{
				minute -= 60;
			}
			var tStr = string_format(hour,2,0)+":"+string_format(minute,2,0);
			tStr = string_replace_all(tStr," ","0");
			draw_set_font(fnt_Menu);
			draw_text_shadow(scr_round(_x+width-strW/2-21), scr_round(_y+height/2-1), tStr);
		}
		if(filePercent >= 0)
		{
			draw_set_align(fa_center,fa_top);
			draw_set_font(fnt_GUI_Small);
			var px = scr_round(_x+width/2+52),
				str = creatorUI.itemsText,
				strW = string_width(creatorUI.itemsText),
				strH = string_height(creatorUI.itemsText);
			draw_text_shadow(px, scr_round(_y+height/2-9), str);
			
			var percent = scr_floor(filePercent);
			var pStr = string_format(percent,2,0)+"%";
			pStr = string_replace_all(pStr," ","0");
			draw_set_font(fnt_Menu);
			draw_text_shadow(px, scr_round(_y+height/2-1), pStr);
		}
		if(fileEnergyMax >= 0)
		{
			draw_set_align(fa_center,fa_top);
			draw_set_font(fnt_GUI_Small);
			var tx = _x+width/2-17,
				ty = _y+height/2-7,
				str = creatorUI.energyText,
				strW = string_width(str),
				strH = string_height(str);
			draw_text_shadow(scr_round(tx-(strW/2)-2), scr_round(ty-1), str);
			
			draw_set_font(fnt_Menu);
			str = string(fileEnergy);
			str = string_char_at(str,string_length(str)-1)+string_char_at(str,string_length(str));
			draw_text_shadow(scr_round(tx-(strW/2)-2), scr_round(ty+strH-4), str);
			
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
	
	draw_set_alpha(1);
}
#endregion

updateText = true;

headerTextRaw = [
"SELECT FILE DATA",
"DATA COPY MODE"];
headerText = [];

footerTextRaw = [
"${MenuMove} - Move   ${MenuAccept_0} - Select",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Back",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Cancel"];
footerText = [];

/*event_inherited();
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
*/
#region Main Menu Page
/*
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
	
	mainMenuPage = self.CreatePage(,0);
	
	var btn = [],
		btnW = 104,
		btnH = 11;//9;
	for(var i = 0; i < array_length(mainMenuText); i++)
	{
		var str = mainMenuText[i];
		btn[i] = mainMenuPage.CreateUIButton(ww/2 - btnW/2, hh/2 + 48 + 12*i, btnW, btnH, str);
		btn[i].sprtAlpha = 0.75;
		btn[i].sprtSelectAlpha = 0.85;
	}
	
	btn[0].SetNavElements(btn[2],btn[1]);
	btn[0].OnClick = method(btn[0], function()
	{
		creatorUI.targetState = UI_MMState.FileMenu;
		audio_play_sound(snd_MenuBoop,0,false);
	});
	
	btn[1].SetNavElements(btn[0],btn[2]);
	btn[1].OnClick = method(btn[1], function()
	{
		if(obj_UI_SettingsMenu.activeState == UI_ActiveState.Inactive)
		{
			obj_UI_SettingsMenu.activeState = UI_ActiveState.Activating;
		}
		
		audio_play_sound(snd_MenuBoop,0,false);
	});
	
	btn[2].SetNavElements(btn[1],btn[0]);
	btn[2].OnClick = method(btn[2], function()
	{
		instance_deactivate_all(false);
		game_end();
	});
}
*/
#endregion
#region File Menu Page
/*
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
	fileMenuPage = self.CreatePage();
	
	var fBtnSprt = sprt_UI_SaveFileBtn,
		fBtnW = 248,
		fBtnH = 32,
		fBtnSpace = fBtnH+4;
	
	var fileBtn = [];
	for(var i = 0; i < array_length(fileMenuText)-1; i++)
	{
		fileBtn[i] = fileMenuPage.CreateUIButton(ww/2 - fBtnW/2, 24 + fBtnSpace*i, fBtnW, fBtnH, fileMenuText[i]);
		fileBtn[i].fileIndex = i;
		fileBtn[i].OnClick = method(fileBtn[i], function()
		{
			creatorUI.subState = UI_MMSubState.FileSelected;
			creatorUI.selectedFile = fileIndex;
			creatorUI.CreateSelectedFilePage(posY, fileIndex);
			
			audio_play_sound(snd_MenuTick,0,false);
		});
		fileBtn[i].PreDraw = method(fileBtn[i], DrawSaveFileButton);
	}
	
	draw_set_font(fnt_GUI);
	var str = fileMenuText[5];
	//var bBtnW = max(string_width(str),48), bBtnH = string_height(str)+1;
	var bBtnW = 56, 
		bBtnH = 11;//9;
	var backBtn = fileMenuPage.CreateUIButton(ww/2 - 96, hh - 32, bBtnW, bBtnH, str);
	backBtn.sprtAlpha = 0.75;
	backBtn.sprtSelectAlpha = 0.85;
	backBtn.OnClick = method(backBtn, function()
	{
		creatorUI.targetState = UI_MMState.MainMenu;
		audio_play_sound(snd_MenuTick,0,false);
	});
	backBtn.HotKey = backBtn.HotKey_Cancel;
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
*/
#endregion
#region Selected File Page
/*
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
	
	selectedFilePage = self.CreatePage();
	var sfPanel = selectedFilePage.CreateUIPanel(ww/2-fBtnW/2, _yoffset, fBtnW, fBtnH)
	sfPanel.fileIndex = _fileIndex;
	
	draw_set_font(fnt_GUI);
	var btnW = 78,//72;
		btnH = 11;//9;
	
	var str = fileOptionText[0];
	var startGameBtn = sfPanel.CreateUIButton(fBtnW/2 - btnW/2, fBtnH/2 - 12, btnW, btnH, str);
	startGameBtn.OnClick = method(startGameBtn, function()
	{
		creatorUI.targetState = UI_MMState.LoadGame;
		audio_play_sound(snd_MenuShwsh,0,false);
	});
	
	str = fileOptionText[1];
	var cancelBtn = sfPanel.CreateUIButton(fBtnW/2 - btnW/2, fBtnH/2 + 1, btnW, btnH, str);
	cancelBtn.OnClick = method(cancelBtn, function()
	{
		creatorUI.subState = UI_MMSubState.None;
		creatorUI.selectedFile = -1;
		instance_destroy(creatorUI.selectedFilePage);
		audio_play_sound(snd_MenuTick,0,false);
	});
	cancelBtn.HotKey = cancelBtn.HotKey_Cancel;
	
	startGameBtn.SetNavElements(cancelBtn,cancelBtn);
	cancelBtn.SetNavElements(startGameBtn,startGameBtn);
	
	if(file_exists(scr_GetFileName(_fileIndex)))
	{
		startGameBtn.x = scr_floor(fBtnW/2 - 52);
		cancelBtn.x = scr_floor(fBtnW/2 - 52);
		
		str = fileOptionText[2];
		var copyBtn = sfPanel.CreateUIButton(fBtnW/2 + 28, fBtnH/2 - 12, btnW, btnH, str);
		copyBtn.OnClick = method(copyBtn, function()
		{
			creatorUI.subState = UI_MMSubState.FileCopy;
			creatorUI.CreateCopyFilePage();
			creatorUI.copyFilePage.UpdatePage();
			audio_play_sound(snd_MenuTick,0,false);
		});
		
		str = fileOptionText[3];
		var deleteBtn = sfPanel.CreateUIButton(fBtnW/2 + 28, fBtnH/2 + 1, btnW, btnH, str);
		deleteBtn.OnClick = method(deleteBtn, function()
		{
			creatorUI.subState = UI_MMSubState.ConfirmDelete;
			creatorUI.CreateConfirmDeletePage();
			audio_play_sound(snd_MenuBoop,0,false);
		});
	
		startGameBtn.SetNavElements(,,copyBtn,copyBtn);
		cancelBtn.SetNavElements(,,deleteBtn,deleteBtn);
		copyBtn.SetNavElements(deleteBtn,deleteBtn,startGameBtn,startGameBtn);
		deleteBtn.SetNavElements(copyBtn,copyBtn,cancelBtn,cancelBtn);
	}
}
*/
#endregion
#region Copy File Page
/*
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
	copyFilePage = self.CreatePage();
	
	var cBtnW = 248,
		cBtnH = 32,
		cBtnSpace = 36;
	
	var copyBtn = [];
	for(var i = 0; i < array_length(copyFileText)-1; i++)
	{
		copyBtn[i] = copyFilePage.CreateUIButton(ww/2 - cBtnW/2, 24 + cBtnSpace*i, cBtnW, cBtnH, copyFileText[i]);
		copyBtn[i].fileIndex = i;
		copyBtn[i].OnClick = method(copyBtn[i], function()
		{
			creatorUI.subState = UI_MMSubState.ConfirmCopy;
			creatorUI.CreateConfirmCopyPage(creatorUI.selectedFile, fileIndex);
			audio_play_sound(snd_MenuBoop,0,false);
		});
		copyBtn[i].PreDraw = method(copyBtn[i], DrawSaveFileButton);
		
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
	copyBtn[cbtn] = copyFilePage.CreateUIButton(ww/2 - 96, hh - 32, bBtnW, bBtnH, str);
	copyBtn[cbtn].sprtAlpha = 0.75;
	copyBtn[cbtn].sprtSelectAlpha = 0.85;
	copyBtn[cbtn].OnClick = method(copyBtn[cbtn], function()
	{
		creatorUI.subState = UI_MMSubState.FileSelected;
		instance_destroy(creatorUI.copyFilePage);
		audio_play_sound(snd_MenuTick,0,false);
	});
	copyBtn[cbtn].HotKey = copyBtn[cbtn].HotKey_Cancel;
	
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
*/
#endregion
#region Confirm Copy Page
/*
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
	
	draw_set_font(fnt_Menu);
	var str = confirmCopyText[0] + "[c_yellow]("+copyFileText[srcFile]+")[/c]" + confirmCopyText[1] + "[c_yellow]("+copyFileText[destFile]+")[/c]" + "\n\n" + confirmCopyText[2];
	var pnlW = 256,//248,
		pnlH = string_height(str) + 24;
	confirmCopyPage = self.CreatePage(,0);
	var ccPanel = confirmCopyPage.CreateUIPanel(ww/2 - pnlW/2, hh/2 - pnlH/2, pnlW, pnlH, str);
	ccPanel.PreDraw = method(ccPanel, DrawConfirmPanel);
	
	var btnW = 31,
		btnH = 11;
	
	str = confirmCopyText[3];
	var yesBtn = ccPanel.CreateUIButton(pnlW/2 - 16 - btnW, pnlH - btnH - 4, btnW, btnH, str);
	yesBtn.sprt = sprt_UI_Button2;
	yesBtn.srcFile = srcFile;
	yesBtn.destFile = destFile;
	yesBtn.OnClick = method(yesBtn, function()
	{
		scr_DeleteGame(destFile);
		file_copy(scr_GetFileName(srcFile),scr_GetFileName(destFile));
		creatorUI.fileTime[destFile] = -1;
		
		creatorUI.selectedFile = -1;
		creatorUI.subState = UI_MMSubState.None;
		instance_destroy(creatorUI.copyFilePage);
		instance_destroy(creatorUI.selectedFilePage);
		creatorUI.confirmCopyPage.active = false;
		
		for(var j = 0; j < array_length(creatorUI.fileMenuPage.elements); j++)
		{
			var fmpBtn = creatorUI.fileMenuPage.elements[j];
			if(fmpBtn.fileIndex == destFile)
			{
				creatorUI.fileMenuPage.SelectElement(fmpBtn,false);
			}
		}
		
		audio_play_sound(snd_MenuBoop,0,false);
	});
	
	str = confirmCopyText[4];
	var noBtn = ccPanel.CreateUIButton(pnlW/2 + 16, pnlH - btnH - 4, btnW, btnH, str);
	noBtn.sprt = sprt_UI_Button2;
	noBtn.OnClick = method(noBtn, function()
	{
		creatorUI.subState = UI_MMSubState.FileCopy;
		creatorUI.confirmCopyPage.active = false;
		audio_play_sound(snd_MenuTick,0,false);
	});
	noBtn.HotKey = noBtn.HotKey_Cancel;
	
	yesBtn.SetNavElements(,,noBtn,noBtn);
	noBtn.SetNavElements(,,yesBtn,yesBtn);
	
	confirmCopyPage.SelectElement(noBtn,false);
}
*/
#endregion
#region Confirm Delete Page
/*
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
	
	draw_set_font(fnt_Menu);
	var str = confirmDeleteText[0] + "[c_yellow]("+fileMenuText[selectedFile]+")[/c]" + "\n\n" + confirmDeleteText[1];
	var pnlW = 256,//248,
		pnlH = string_height(str) + 24;
	confirmDeletePage = self.CreatePage(,0);
	var cdPanel = confirmDeletePage.CreateUIPanel(ww/2 - pnlW/2, hh/2 - pnlH/2, pnlW, pnlH, str);
	cdPanel.PreDraw = method(cdPanel, DrawConfirmPanel);
	
	var btnW = 31,
		btnH = 11;
	
	str = confirmDeleteText[2];
	var yesBtn = cdPanel.CreateUIButton(pnlW/2 - 16 - btnW, pnlH - btnH - 4, btnW, btnH, str);
	yesBtn.sprt = sprt_UI_Button2;
	yesBtn.OnClick = method(yesBtn, function()
	{
		scr_DeleteGame(creatorUI.selectedFile);
		creatorUI.fileTime[creatorUI.selectedFile] = -1;
		creatorUI.selectedFile = -1;
		creatorUI.subState = UI_MMSubState.None;
		instance_destroy(creatorUI.selectedFilePage);
		creatorUI.confirmDeletePage.active = false;
		audio_play_sound(snd_MenuBoop,0,false);
	});
	
	str = confirmDeleteText[3];
	var noBtn = cdPanel.CreateUIButton(pnlW/2 + 16, pnlH - btnH - 4, btnW, btnH, str);
	noBtn.sprt = sprt_UI_Button2;
	noBtn.OnClick = method(noBtn, function()
	{
		creatorUI.subState = UI_MMSubState.FileSelected;
		creatorUI.confirmDeletePage.active = false;
		audio_play_sound(snd_MenuTick,0,false);
	});
	noBtn.HotKey = noBtn.HotKey_Cancel;
	
	yesBtn.SetNavElements(,,noBtn,noBtn);
	noBtn.SetNavElements(,,yesBtn,yesBtn);
	
	confirmDeletePage.SelectElement(noBtn,false);
}
*/
#endregion

#region DrawSaveFileButton
/*
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
		var _x = posX,
			_y = posY,
			_text = self.GetText();
		
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
		draw_text_shadow(scr_round(_x+3), scr_round(_y+height/2), _text);
		
		draw_sprite_ext(sprt_UI_FileIcon, icoFrame, scr_round(_x+string_width(_text)+7), scr_round(_y+height/2), 1, 1, 0, c_white, alpha);
		
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
				draw_text_shadow(scr_round(_x+width/2), scr_round(_y+height/2), creatorUI.noDataText);
			}
			else
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small);
				var str = creatorUI.timeText,
					strW = string_width(str);
				draw_text_shadow(scr_round(_x+width-strW/2-22), scr_round(_y+height/2-9), str);
				
				var minute = scr_floor(fileTime / 60);
				var hour = scr_floor(minute / 60);
				while(minute >= 60)
				{
					minute -= 60;
				}
				var tStr = string_format(hour,2,0)+":"+string_format(minute,2,0);
				tStr = string_replace_all(tStr," ","0");
				draw_set_font(fnt_Menu);
				draw_text_shadow(scr_round(_x+width-strW/2-21), scr_round(_y+height/2-1), tStr);
			}
			if(filePercent >= 0)
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small);
				var px = scr_round(_x+width/2+52),
					str = creatorUI.itemsText,
					strW = string_width(creatorUI.itemsText),
					strH = string_height(creatorUI.itemsText);
				draw_text_shadow(px, scr_round(_y+height/2-9), str);
				
				var percent = scr_floor(filePercent);
				var pStr = string_format(percent,2,0)+"%";
				pStr = string_replace_all(pStr," ","0");
				draw_set_font(fnt_Menu);
				draw_text_shadow(px, scr_round(_y+height/2-1), pStr);
			}
			if(fileEnergyMax >= 0)
			{
				draw_set_align(fa_center,fa_top);
				draw_set_font(fnt_GUI_Small);
				var tx = _x+width/2-17,
					ty = _y+height/2-7,
					str = creatorUI.energyText,
					strW = string_width(str),
					strH = string_height(str);
				draw_text_shadow(scr_round(tx-(strW/2)-2), scr_round(ty-1), str);
			
				draw_set_font(fnt_Menu);
				str = string(fileEnergy);
				str = string_char_at(str,string_length(str)-1)+string_char_at(str,string_length(str));
				draw_text_shadow(scr_round(tx-(strW/2)-2), scr_round(ty+strH-4), str);
			
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
}*/
#endregion
#region DrawConfirmPanel
/*function DrawConfirmPanel()
{
	var _x = posX,
		_y = posY;
	
	var _alpha = alpha;
	
	var ww = global.resWidth,
		hh = global.resHeight;
	
	draw_set_color(c_black);
	draw_set_alpha(0.5 * _alpha);
	draw_rectangle(-1,-1,ww+1,hh+1,false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	
	draw_sprite_stretched_ext(sprt_UI_MessageBox,0, _x,_y, width,height, c_white,_alpha);
	
	textAlignY = fa_top;
	textFont = fnt_Menu;
	useScribDeluxe = true;
	self.DrawText(textColor);
	
	return true;
}*/
#endregion
/*
updateText = true;

headerTextRaw = [
"SELECT FILE DATA",
"DATA COPY MODE"];
headerText = [];

footerTextRaw = [
"${MenuMove} - Move   ${MenuAccept_0} - Select",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Back",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Cancel"];
footerText = [];
*/