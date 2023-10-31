/// @description Initialize

screenFade = 0;
menuClosing = false;

surf = surface_create(global.resWidth,global.resHeight);

screen = 0;

header[0] = "CONTROL OPTIONS";
header[1] = "MORE CONTROL OPTIONS";
header[2] = "KEYBOARD BINDINGS";
header[3] = "CONTROLLER BINDINGS";


gpFound = "CONTROLLER BINDINGS";
gpNotFound = "NO CONTROLLER DETECTED";

option = array(
"WEAPON HUD",
"AIM CONTROL",
"AUTO-RUN",
"QUICK-CLIMB",
"MORE OPTIONS",
"KEYBOARD BINDINGS",
"CONTROLLER BINDINGS",
"BACK");

currentOption = array(
global.HUD,
global.aimStyle,
global.autoDash,
global.quickClimb);

currentOptionName[0,0] = "DEFAULT";
currentOptionName[0,1] = "SELECT & ARM";
currentOptionName[0,2] = "BLACKFALCON";

currentOptionName[1,0] = "2 BUTTONS";
currentOptionName[1,1] = "1 BUTTON: GBA";
currentOptionName[1,2] = "1 BUTTON: LOCK";

currentOptionName[2,0] = "DISABLED";
currentOptionName[2,1] = "ENABLED";

currentOptionName[3,0] = "DISABLED";
currentOptionName[3,1] = "ENABLED";

optionTip[0,0] = "Press [Weapon Select] to cycle through available weapons." + "\n" + 
				"Press [Weapon Cancel] to reset selection.";
optionTip[0,1] = "Hold [Weapon Select] to select your offhand weapon." + "\n" +
				"Hold [Arm Weapon] to arm your offhand weapon.";
optionTip[0,2] = "HUD originally designed as an SM patch by \"BlackFalcon\" and \"InsomniaDX\"." + "\n" +
				"Hold [Weapon Select] to choose your weapons." + "\n" +
				"Press [Weapon Slot Switch] to switch between your main and offhand weapon slots.";

optionTip[1,0] = "Press [Aim Up] to aim diagonally upward. Press [Aim Down] to aim diagonally downward.";
optionTip[1,1] = "While holding [Aim], press [Up] or [Down] to aim diagonally upward or downward.";
optionTip[1,2] = "Holding [Aim] locks movement, allowing aiming with directional input.";

optionTip[2,0] = "Always accelerate to max speed when running.";
optionTip[3,0] = "Climb up 1-3 block tall steps by holding forward and pressing [Jump].";

optionTip[4,0] = "More Control Options";
optionTip[5,0] = "Configure Keyboard Bindings";
optionTip[6,0] = "Configure Controller Bindings";
optionTip[7,0] = "Exit Control Options Menu";


advOption = array(
"GRIP CLIMB CONTROL",
"GRAPPLE CONTROL",
"SPIDER BALL CONTROL",
"ACCEL DASH CONTROL",
"BACK");

advCurrentOption = array(
global.gripStyle,
global.grappleStyle,
global.spiderBallStyle,
global.dodgeStyle);

advCurrentOptionName[0,0] = "DEFAULT";
advCurrentOptionName[0,1] = "ADVANCED";
advCurrentOptionName[0,2] = "QUICK";

advCurrentOptionName[1,0] = "DEFAULT";
advCurrentOptionName[1,1] = "ADVANCED";

advCurrentOptionName[2,0] = "TOGGLE";
advCurrentOptionName[2,1] = "HOLD";
advCurrentOptionName[2,2] = "CLASSIC";

advCurrentOptionName[3,0] = "AIMLOCK BUTTON";
advCurrentOptionName[3,1] = "RUN BUTTON";

advOptionTip[0,0] = "Either hold forward and press [Jump] or hold [Up] to climb up when gripping a ledge.";
advOptionTip[0,1] = "Holding forward and pressing [Jump] is the only way to climb when gripping a ledge.";
advOptionTip[0,2] = "Press [Jump] or hold [Up] to climb when gripping a ledge.";

advOptionTip[1,0] = "Hold [Up] or [Down] to reel up or down.";
advOptionTip[1,1] = "Hold [Up] or [Down] without pressing [Left] or [Right] to reel up or down.";

advOptionTip[2,0] = "Press any [Aim] button to activate.";
advOptionTip[2,1] = "Hold any [Aim] button to activate.";
advOptionTip[2,2] = "Press [Down] while morphed to activate, press [Jump] to deactivate.";

advOptionTip[3,0] = "Tap [Aim lock] to Accel Dash";
advOptionTip[3,1] = "Tap [Run] to Accel Dash";

advOptionTip[4,0] = "Previous Control Options";


cNameAim[0] = "AIM UP";
cNameAim[1] = "AIM";

cNameHUD[0] = "WEAPON CANCEL";
cNameHUD[1] = "ARM WEAPON";
cNameHUD[2] = "WEAPON SLOT SWITCH";

controlKey = array(
"UP","DOWN","LEFT","RIGHT",
"JUMP","SHOOT","RUN","AIM UP","AIM DOWN",
"AIM LOCK","QUICK MORPH",
"WEAPON SELECT","WEAPON CANCEL",
"MENU - START","MENU - SELECT","MENU - CANCEL",
"RESET TO DEFAULTS",
"BACK");

for(var i = 0; i < array_length(global.key); i++)
{
	currentControlKey[i] = global.key[i];
}
for(var i = 0; i < array_length(global.key_m); i++)
{
	currentControlKey[i+array_length(global.key)] = global.key_m[i];
}

controlButton = array(
"D-PAD","LEFT STICK","DEAD ZONE",
"JUMP","SHOOT","RUN","AIM UP","AIM DOWN",
"AIM LOCK","QUICK MORPH",
"WEAPON SELECT","WEAPON CANCEL",
"MENU - START","MENU - SELECT","MENU - CANCEL",
"RESET TO DEFAULTS",
"BACK");

currentControlButton = array(global.gp_usePad,global.gp_useStick,global.gp_deadZone);
for(var i = 0; i < array_length(global.gp); i++)
{
	currentControlButton[i+3] = global.gp[i];
}
for(var i = 0; i < array_length(global.gp_m); i++)
{
	currentControlButton[i+3+array_length(global.gp)] = global.gp_m[i];
}

selectedKey = -1;
keySelectDelay = 0;

textInputKey = "INPUT KEY...";
textInputButton = "INPUT BUTTON...";

cButtonToggleName[0] = "DISABLED";
cButtonToggleName[1] = "ENABLED";

cursorFrame = 0;
cursorFrameCounter = 0;

scrollY = -96;


optionPos = 0;
prevOptionPos = 0;
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