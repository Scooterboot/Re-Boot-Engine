/// @description Initialize

pause = false;
isPaused = false;
pauseFade = 0;
unpause = true;

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