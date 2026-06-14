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

inputBlockLayer = "input block (main menu)";

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
		if(obj_UI_SettingsMenu.activeState == UI_ActiveState.Inactive)
		{
			obj_UI_SettingsMenu.activeState = UI_ActiveState.Activating;
		}
		
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
			fileBtn[i].eventDraw = method(undefined, DrawSaveFileButton);
			
			if(i == 0)
			{
				BentoSetNavigationWrap(false, true, fileBtn[i]);
			}
			
			BentoAnimPlayBuildIn(12, i*3, fBtnW*0.75, 0, 1, 1, 0,animCur_UI_Basic,false,fileBtn[i]);
		}
		else
		{
			var backFunc = function()
			{
				creatorUI.targetState = UI_MMState.MainMenu;
				
				audio_play_sound(snd_MenuTick,0,false);
			}
			
			fileBtn[i] = new BentoUI_Button(backFunc, 56, 11, fileMenuText[i], this, _mainElement);
			fileBtn[i].sprtAlpha = 0.75;
			fileBtn[i].sprtSelectAlpha = 0.85;
			fileBtn[i].hotKey = fileBtn[i].hotKey_cancel;
			BentoSetOffset(0, 4, fileBtn[i]);
			
			BentoSetNavigationWrap(false, true, fileBtn[i]);
			
			BentoAnimPlayBuildIn(7, i*3, 0,4,1,1, 0,,false,fileBtn[i]);
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
	BentoSetNavigationWrap(true, true, startGameBtn);
	
	var cancelFunc = function()
	{
		creatorUI.subState = UI_MMSubState.None;
		
		audio_play_sound(snd_MenuTick,0,false);
	}
	str = fileOptionText[1];
	var cancelBtn = new BentoUI_Button(cancelFunc, btnW, btnH, str, this, _secElement1);
	cancelBtn.hotKey = cancelBtn.hotKey_cancel;
	BentoSetNavigationWrap(true, true, cancelBtn);
	
	if(file_exists(scr_GetFileName(_fileIndex)))
	{
		BentoSetOffset(116, , _mainElement);
		
		var _secElement2 = new BentoUI_Spacer(_mainElement);
		with(_secElement2)
		{
			BentoLayoutSetSize(btnW, _fileBtn.bentoHeight);
			BentoLayoutSetGutter(0, 1);
			BentoLayoutList(BENTO_AXIS_Y, 0.5, 0.5);
		}
		
		var copyFunc = function()
		{
			creatorUI.subState = UI_MMSubState.FileCopy;
			creatorUI.CreateCopyFileMenu();
			
			audio_play_sound(snd_MenuTick,0,false);
		}
		str = fileOptionText[2];
		var copyBtn = new BentoUI_Button(copyFunc, btnW, btnH, str, this, _secElement2);
		BentoSetNavigationWrap(true, true, copyBtn);
		
		var deleteFunc = function()
		{
			creatorUI.subState = UI_MMSubState.ConfirmDelete;
			creatorUI.CreateConfirmDeleteMenu()
			
			audio_play_sound(snd_MenuBoop,0,false);
		}
		str = fileOptionText[3];
		var deleteBtn = new BentoUI_Button(deleteFunc, btnW, btnH, str, this, _secElement2);
		BentoSetNavigationWrap(true, true, deleteBtn);
	}
}

#endregion
#region Copy File Menu

copyFileText = [
"FILE A",
"FILE B",
"FILE C",
"FILE D",
"FILE E",
"CANCEL"];

copyFileLayer = "copy file menu";
function CreateCopyFileMenu()
{
	BentoLayerSetDrawWhenBackgrounded(false, fileMenuLayer);
	BentoLayerSetDrawWhenBackgrounded(false, selectedFileLayer);
	
	var ww = global.resWidth,
		hh = global.resHeight,
		this = id;
	
	var _layer = BentoLayerCreate(copyFileLayer),
		_root = BentoLayerGetRoot(_layer);
	
	var _mainElement = new BentoUI_Spacer(_root);
	with(_mainElement)
	{
		BentoLayoutSetGutter(0, 4);
		BentoLayoutSetResize(BENTO_RESIZE_INFLATE, BENTO_RESIZE_INFLATE);
		BentoLayoutList(BENTO_AXIS_Y, 0, 0);
		BentoSetPosition(ww/2 - 124, 24);
	}
	
	var copyBtn = [],
		cBtnW = 248,
		cBtnH = 32;
	for(var i = 0; i < array_length(copyFileText); i++)
	{
		if(i < array_length(copyFileText)-1)
		{
			var cBtnFunc = function()
			{
				creatorUI.subState = UI_MMSubState.ConfirmCopy;
				creatorUI.CreateConfirmCopyMenu(creatorUI.selectedFile, fileIndex);
				
				audio_play_sound(snd_MenuBoop,0,false);
			}
			
			copyBtn[i] = new BentoUI_Button(cBtnFunc, cBtnW, cBtnH, copyFileText[i], this, _mainElement);
			copyBtn[i].fileIndex = i;
			copyBtn[i].eventDraw = method(undefined, DrawSaveFileButton);
			
			if(selectedFile == i)
			{
				BentoSetButton(BENTO_BUTTON_NEVER, copyBtn[i]);
			}
			
			if((i == 0 && selectedFile != 0) ||
				(i == 1 && selectedFile == 0))
			{
				BentoSetNavigationWrap(false, true, copyBtn[i]);
			}
		}
		else
		{
			var cancelFunc = function()
			{
				creatorUI.subState = UI_MMSubState.FileSelected;
				BentoLayerDestroy(creatorUI.copyFileLayer);
				BentoLayerSetDrawWhenBackgrounded(true, creatorUI.fileMenuLayer);
				BentoLayerSetDrawWhenBackgrounded(true, creatorUI.selectedFileLayer);
				
				audio_play_sound(snd_MenuTick,0,false);
			}
			
			copyBtn[i] = new BentoUI_Button(cancelFunc, 56, 11, copyFileText[i], this, _mainElement);
			copyBtn[i].sprtAlpha = 0.75;
			copyBtn[i].sprtSelectAlpha = 0.85;
			copyBtn[i].hotKey = copyBtn[i].hotKey_cancel;
			BentoSetOffset(0, 4, copyBtn[i]);
			
			BentoSetNavigationWrap(false, true, copyBtn[i]);
		}
		
		BentoSetNavigationEnable(false, true, copyBtn[i]);
	}
	
	BentoNavigationLinkY(copyBtn[4],copyBtn[5]);
}

#endregion
#region Confirm Copy Menu

confirmCopyText = [
"COPYING ",
" TO ",
"ARE YOU SURE?",
"YES",
"NO"];

confirmCopyLayer = "confirm copy dialog";
function CreateConfirmCopyMenu(srcFile, destFile)
{
	var ww = global.resWidth,
		hh = global.resHeight,
		this = id;
	
	var _layer = BentoLayerCreate(confirmCopyLayer),
		_root = BentoLayerGetRoot(_layer);
	
	draw_set_font(fnt_Menu);
	var str = confirmCopyText[0] + "[c_yellow]("+copyFileText[srcFile]+")[/c]" + confirmCopyText[1] + "[c_yellow]("+copyFileText[destFile]+")[/c]" + "\n\n" + confirmCopyText[2];
	var pnlW = 256,//248,
		pnlH = string_height(str) + 24;
	
	var _mainElement = new BentoUI_ConfirmPanel(pnlW, pnlH, str, this, _root);
	with(_mainElement)
	{
		BentoSetPosition(ww/2 - pnlW/2, hh/2 - pnlH/2);
		BentoSetOrigin(0.5, 0.5);
		BentoLayoutSetGutter(32, 0);
		BentoLayoutList(BENTO_AXIS_X, 0.5, 1);
		BentoLayoutSetPadding(4);
		BentoAnimPlayBuildIn(7,0,0,0,0.75,0.75,0,,false);
	}
	
	var btnW = 31,
		btnH = 11;
	
	var yesFunc = function()
	{
		scr_DeleteGame(destFile);
		file_copy(scr_GetFileName(srcFile),scr_GetFileName(destFile));
		creatorUI.fileTime[destFile] = -1;
		creatorUI.selectedFile = -1;
		
		var _root = BentoLayerGetRoot(creatorUI.fileMenuLayer),
			_mainElement = BentoGetChild(0, _root),
			_childArr = BentoGetChildArray(_mainElement);
		for(var i = 0; i < array_length(_childArr); i++)
		{
			if(variable_struct_exists(_childArr[i], "fileIndex") && _childArr[i].fileIndex == destFile)
			{
				BentoHover(_childArr[i],,creatorUI.fileMenuLayer);
				break;
			}
		}
		
		BentoAnimPlayBuildOut(7, 0, 0, 0, 0.75, 0.75, 0,,panel);
		BentoAnimPlayBuildOut(7, 0, 0, 0, 1, 1, 0,,noBtn);
		BentoAnimPlayBuildOut(7, 0, 0, 0, 1, 1, 0);
		BentoLayerSetUnblockCallback(creatorUI.confirmCopyLayer, method(self, function()
		{
			creatorUI.subState = UI_MMSubState.None;
			BentoLayerDestroy(creatorUI.selectedFileLayer);
			BentoLayerDestroy(creatorUI.copyFileLayer);
			BentoLayerDestroy(creatorUI.confirmCopyLayer);
			BentoLayerSetDrawWhenBackgrounded(true, creatorUI.fileMenuLayer);
			
			var _root = BentoLayerGetRoot(creatorUI.fileMenuLayer),
				_mainElement = BentoGetChild(0, _root),
				_childArr = BentoGetChildArray(_mainElement);
			for(var i = 0; i < array_length(_childArr); i++)
			{
				if(variable_struct_exists(_childArr[i], "fileIndex") && _childArr[i].fileIndex == destFile)
				{
					BentoHover(_childArr[i],,creatorUI.fileMenuLayer);
					break;
				}
			}
		}));
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	str = confirmCopyText[3];
	var yesBtn = new BentoUI_Button(yesFunc, btnW, btnH, str, this, _mainElement);
	yesBtn.sprt = sprt_UI_Button2;
	yesBtn.textOffsetY = 0;
	yesBtn.srcFile = srcFile;
	yesBtn.destFile = destFile;
	BentoAnimPlayBuildIn(7,0,0,0,1,1,0,,false,yesBtn);
	
	var noFunc = function()
	{
		creatorUI.subState = UI_MMSubState.FileCopy;
		
		BentoAnimPlayBuildOut(7, 0, 0, 0, 0.75, 0.75, 0,,panel);
		BentoAnimPlayBuildOut(7, 0, 0, 0, 1, 1, 0,,yesBtn);
		BentoAnimPlayBuildOut(7, 0, 0, 0, 1, 1, 0);
		BentoLayerSetUnblockCallback(creatorUI.confirmCopyLayer, method(creatorUI, function(){ BentoLayerDestroy(confirmCopyLayer); }));
		
		audio_play_sound(snd_MenuTick,0,false);
	}
	str = confirmCopyText[4];
	var noBtn = new BentoUI_Button(noFunc, btnW, btnH, str, this, _mainElement);
	noBtn.sprt = sprt_UI_Button2;
	noBtn.textOffsetY = 0;
	noBtn.hotKey = noBtn.hotKey_cancel;
	BentoAnimPlayBuildIn(7,0,0,0,1,1,0,,false,noBtn);
	BentoHover(noBtn,,confirmCopyLayer);
	
	yesBtn.panel = _mainElement;
	yesBtn.noBtn = noBtn;
	noBtn.panel = _mainElement;
	noBtn.yesBtn = yesBtn;
}

#endregion
#region Confirm Delete Menu

confirmDeleteText = [
"DELETING ",
"ARE YOU SURE?",
"YES",
"NO"];

confirmDeleteLayer = "confirm delete dialog";
function CreateConfirmDeleteMenu()
{
	var ww = global.resWidth,
		hh = global.resHeight,
		this = id;
	
	var _layer = BentoLayerCreate(confirmDeleteLayer),
		_root = BentoLayerGetRoot(_layer);
	
	draw_set_font(fnt_Menu);
	var str = confirmDeleteText[0] + "[c_yellow]("+fileMenuText[selectedFile]+")[/c]" + "\n\n" + confirmDeleteText[1];
	var pnlW = 256,//248,
		pnlH = string_height(str) + 24;
	
	var _mainElement = new BentoUI_ConfirmPanel(pnlW, pnlH, str, this, _root);
	with(_mainElement)
	{
		BentoSetPosition(ww/2 - pnlW/2, hh/2 - pnlH/2);
		BentoSetOrigin(0.5, 0.5);
		BentoLayoutSetGutter(32, 0);
		BentoLayoutList(BENTO_AXIS_X, 0.5, 1);
		BentoLayoutSetPadding(4);
		BentoAnimPlayBuildIn(7,0,0,0,0.75,0.75,0,,false);
	}
	
	var btnW = 31,
		btnH = 11;
	
	var yesFunc = function()
	{
		scr_DeleteGame(creatorUI.selectedFile);
		creatorUI.fileTime[creatorUI.selectedFile] = -1;
		creatorUI.subState = UI_MMSubState.None;
		BentoLayerDestroy(creatorUI.selectedFileLayer);
		
		BentoAnimPlayBuildOut(7, 0, 0, 0, 0.75, 0.75, 0,,panel);
		BentoAnimPlayBuildOut(7, 0, 0, 0, 1, 1, 0,,noBtn);
		BentoAnimPlayBuildOut(7, 0, 0, 0, 1, 1, 0);
		BentoLayerSetUnblockCallback(creatorUI.confirmDeleteLayer, method(creatorUI, function(){ BentoLayerDestroy(confirmDeleteLayer); }));
		
		audio_play_sound(snd_MenuBoop,0,false);
	}
	str = confirmDeleteText[2];
	var yesBtn = new BentoUI_Button(yesFunc, btnW, btnH, str, this, _mainElement);
	yesBtn.sprt = sprt_UI_Button2;
	yesBtn.textOffsetY = 0;
	BentoAnimPlayBuildIn(7,0,0,0,1,1,0,,false,yesBtn);
	
	var noFunc = function()
	{
		creatorUI.subState = UI_MMSubState.FileSelected;
		
		BentoAnimPlayBuildOut(7, 0, 0, 0, 0.75, 0.75, 0,,panel);
		BentoAnimPlayBuildOut(7, 0, 0, 0, 1, 1, 0,,yesBtn);
		BentoAnimPlayBuildOut(7, 0, 0, 0, 1, 1, 0);
		BentoLayerSetUnblockCallback(creatorUI.confirmDeleteLayer, method(creatorUI, function(){ BentoLayerDestroy(confirmDeleteLayer); }));
		
		audio_play_sound(snd_MenuTick,0,false);
	}
	str = confirmDeleteText[3];
	var noBtn = new BentoUI_Button(noFunc, btnW, btnH, str, this, _mainElement);
	noBtn.sprt = sprt_UI_Button2;
	noBtn.textOffsetY = 0;
	noBtn.hotKey = noBtn.hotKey_cancel;
	BentoAnimPlayBuildIn(7,0,0,0,1,1,0,,false,noBtn);
	BentoHover(noBtn,,confirmDeleteLayer);
	
	yesBtn.panel = _mainElement;
	yesBtn.noBtn = noBtn;
	noBtn.panel = _mainElement;
	noBtn.yesBtn = yesBtn;
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
	
	if(creatorUI.selectedFile != fileIndex || creatorUI.subState == UI_MMSubState.FileCopy || creatorUI.subState == UI_MMSubState.ConfirmCopy)
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
					draw_sprite_ext(sprt_HUD_ETank,(statEnergyTanks > j),floor(eX),floor(eY),1,1,0,c_white,alpha);
				}
			}
		}
	}
	
	draw_set_alpha(1);
}
#endregion

headerTextRaw = [
"SELECT FILE DATA",
"DATA COPY MODE"];
headerText = [];

footerTextRaw = [
"${MenuMove} - Move   ${MenuAccept_0} - Select",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Back",
"${MenuMove} - Move   ${MenuAccept_0} - Select   ${MenuCancel_0} - Cancel"];
footerText = [];
