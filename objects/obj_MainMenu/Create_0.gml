/// @description Initialize
event_inherited();
enum MainScreen
{
	TitleIntro,
	Title,
	FileSelect,
	FileCopy,
	LoadGame
}
currentScreen = MainScreen.TitleIntro;
targetScreen = currentScreen;

screenFade = 1;

skipIntro = false;

titleFade = 0;
pressStartAnim = 0;
startString = "PRESS START";

optionPos = 0;
optionSubPos = 0;
selectedFile = -1;
copyFile = -1;

fileIconFrame = 0;
fileIconFrameCounter = 0;

option = [
"FILE A",
"FILE B",
"FILE C",
"DISPLAY OPTIONS",
"AUDIO OPTIONS",
"CONTROL OPTIONS",
"QUIT TO DESKTOP"];

copyOption = [
"FILE A",
"FILE B",
"FILE C",
"CANCEL"];

confirmPos = 0;
confirmText = ["ARE YOU SURE?", "NO", "YES"];
confirmQuitDT = false;
confirmCopy = false;
confirmCopyText = ["COPY","TO"];
confirmDelete = false;
confirmDeleteText = "DELETE";

subOption = [
"START GAME",
"COPY FILE",
"DELETE FILE"];

noDataText = "NO DATA";
energyText = "ENERGY";
timeText = "TIME";
itemsText = "ITEMS";

fileEnergyMax[0] = -1;
fileEnergyMax[1] = -1;
fileEnergyMax[2] = -1;
fileEnergy[0] = -1;
fileEnergy[1] = -1;
fileEnergy[2] = -1;

itemList = ds_list_create();

filePercent[0] = -1;
filePercent[1] = -1;
filePercent[2] = -1;

fileTime[0] = -1;
fileTime[1] = -1;
fileTime[2] = -1;

cursorFrame = 0;
cursorFrameCounter = 0;

moveCounter = 0;

buttonTip = [
"Move",
"Select",
"Back",
"Cancel"];

buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1]+"   ${menuCancelButton} - "+buttonTip[2];
buttonTipScrib = scribble(buttonTipString);
buttonTipScrib.starting_format("fnt_GUI_Small2",c_white);
buttonTipScrib.align(fa_center,fa_middle);

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

controlGroups = "menu";
InitControlVars(controlGroups);