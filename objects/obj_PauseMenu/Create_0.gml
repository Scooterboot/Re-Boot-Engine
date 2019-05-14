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

statusMove = 0;
statusMovePrev = 1;
statusMoveX = 0;

statusPos = -1;

beamSelect = -1;
suitSelect = -1;
bootsSelect = -1;
miscSelect = -1;

toggleItem = false;

textAnim = 0;

selectorAlpha = 0;
sAlphaNum = 1;

playerOffsetY = 20;

playerStatusSurf = surface_create(global.resWidth,global.resHeight);

playerGlowY = 0;
playerGlowSurf = surface_create(global.resWidth,global.resHeight);
playerGlowSurf2 = surface_create(global.resWidth,global.resHeight);
playerFlashAlpha = 1;

playerGlowInd = -1;
playerGlowIndPrev = -1;

pauseSurf = surface_create(global.resWidth,global.resHeight);

cRight = false;
cLeft = false;
cUp = false;
cDown = false;
cSelect = false;
cCancel = false;
cNext = false;
cPrev = false;
cStart = false;

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rCancel = !cCancel;
rNext = !cNext;
rPrev = !cPrev;
rStart = !cStart;