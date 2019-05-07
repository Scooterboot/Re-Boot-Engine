/// @description Initialize

optMenuState = -1;

pause = false;
screenfade = 0;
menu[0] = "DISPLAY OPTIONS";
menu[1] = "AUDIO OPTIONS";
menu[2] = "CONTROL OPTIONS";
menu[3] = "RETURN TO MAIN MENU";
menu[4] = "EXIT TO DESKTOP";

menuPos = 0;

cursorframe = 0;
cursorframecounter = 0;

section = 0;
sectionAnim = 0;

//mX = 0;
//mY = 0;
//mW = sprite_get_width(global.mapArea);
//mH = sprite_get_height(global.mapArea);

cRight = false;
cLeft = false;
cUp = false;
cDown = false;
cSelect = false;
cBack = false;
cStart = false;
cNext = false;
cPrev = false;

rRight = !cRight;
rLeft = !cLeft;
rUp = !cUp;
rDown = !cDown;
rSelect = !cSelect;
rBack = !cBack;
rStart = !cStart;
rNext = !cNext;
rPrev = !cPrev;

itemNav = 0;

beamSelect = -1;
suitSelect = -1;
miscSelect = -1;
bootsSelect = -1;

selectorAlpha = 0;
sAlphaNum = 1;

moveX = 0;
moveY = 0;
lastMoveY = 1;
toggleItem = false;

temp[9] = 0;

secFade = 0;
secStage = false;
secTransitioning = false;

samusScreenPosX = 0;
samusScreenPosY = 0;

samusScreenDesX = 0;
samusScreenDesY = 0;

samusGlowY = 0;
samusGlowSurf = noone;
samusFlashAnimAlpha = 1;

samusGlowInd = -1;
samusGlowIndPrev = -1;

firstFade = 1;