/// @description Initialize

screenFade = 0;
menuClosing = false;

surf = surface_create(global.resWidth,global.resHeight);

header = "AUDIO OPTIONS";

option = array(
"MUSIC VOLUME",
"SOUND VOLUME",
"AMBIANCE VOLUME",
"BACK");

currentOption = array(
global.musicVolume,
global.soundVolume,
global.ambianceVolume);

optionTip[0] = "Music Volume";
optionTip[1] = "Sound Effects Volume" + "\n" + "Jumping, shooting, etc.";
optionTip[2] = "Ambiance Volume" + "\n" + "Rain and other environmental sounds.";
optionTip[3] = "Exit Audio Options Menu";


cursorFrame = 0;
cursorFrameCounter = 0;

optionPos = 0;
movePrev = 0;
moveCounter = 0;
moveCounterX = 0;

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