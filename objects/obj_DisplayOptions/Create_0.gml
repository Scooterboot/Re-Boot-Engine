/// @description Initialize

screenFade = 0;
menuClosing = false;

header[0] = "SCREEN OPTIONS";
header[1] = "HUD OPTIONS";
header[2] = "ENVIRONMENT OPTIONS";

option = array(
"WINDOW MODE",
"DISPLAY SCALE",
"V-SYNC",
"UPSCALING MODE",
"HUD DISPLAY",
"HUD MINIMAP",
"WATER DISTORTION",
"BACK");

currentOption = array(
global.fullScreen,
global.screenScale,
global.vsync,
global.upscale,
global.hudDisplay,
global.hudMap,
global.waterDistortion);

currentOptionName[0,0] = "WINDOWED";
currentOptionName[0,1] = "FULLSCREEN";

currentOptionName[1,0] = "STRETCH";
currentOptionName[1,1] = string(global.screenScale)+"x";

currentOptionName[2,0] = "DISABLED";
currentOptionName[2,1] = "ENABLED";

currentOptionName[3,0] = "DISABLED";
currentOptionName[3,1] = "LINEAR";
currentOptionName[3,2] = "HQ4X";
currentOptionName[3,3] = "5XBR A";
currentOptionName[3,4] = "5XBR B";
currentOptionName[3,5] = "5XBR C";
currentOptionName[3,6] = "SCANLINES";

currentOptionName[4,0] = "HIDE";
currentOptionName[4,1] = "SHOW";

currentOptionName[5,0] = "HIDE";
currentOptionName[5,1] = "SHOW";

currentOptionName[6,0] = "DISABLED";
currentOptionName[6,1] = "ENABLED";

optionTip[0] = "Switch between Full Screen and Windowed Mode.";
optionTip[1] = "Sets the size of the Game Window, preserving the aspect ratio.";
optionTip[2] = "Vertical Sync" + "\n" + "Eliminates tearing (might be slow).";
optionTip[3] = "Experimental" + "\n" + "Choose between a variety of upscaling modes that smooth out rough pixel edges.";
optionTip[4] = "Show or hide the Heads-Up Display during gameplay.";
optionTip[5] = "Show or hide the minimap.";
optionTip[6] = "Water distorts the environment (might be slow).";
optionTip[7] = "Exit Display Options Menu";


cursorFrame = 0;
cursorFrameCounter = 0;

optionPos = 0;
movePrev = 0;
moveCounter = 0;
moveCounterX = 0;

scrollY = -64;

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