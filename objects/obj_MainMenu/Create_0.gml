/// @description Initialize

enum MainScreen
{
	TitleIntro,
	Title,
	FileSelect,
	LoadGame
}
currentScreen = MainScreen.TitleIntro;
targetScreen = currentScreen;

screenFade = 1;

skipIntro = false;

titleFade = 0;
pressStartAnim = 0;
startString = "PRESS START";

titleMusic = noone;

optionPos = 0;
optionSubPos = 0;
selectedFile = -1;

fileIconFrame = 0;
fileIconFrameCounter = 0;

option = array(
"FILE A",
"FILE B",
"FILE C",
"DISPLAY OPTIONS",
"AUDIO OPTIONS",
"CONTROL OPTIONS",
"QUIT TO DESKTOP");

subOption = array(
"START GAME",
"DELETE FILE");

noDataText = "NO DATA";
energyText = "ENERGY";
timeText = "TIME";

fileEnergyMax[0] = -1;
fileEnergyMax[1] = -1;
fileEnergyMax[2] = -1;
fileEnergy[0] = -1;
fileEnergy[1] = -1;
fileEnergy[2] = -1;

filePercent[0] = -1;
filePercent[1] = -1;
filePercent[2] = -1;

fileTime[0] = -1;
fileTime[1] = -1;
fileTime[2] = -1;

cursorFrame = 0;
cursorFrameCounter = 0;

buttonTip = array(
"Move",
"Select",
"Back",
"Cancel");

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