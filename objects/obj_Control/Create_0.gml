/// @description Initialize

ini_open("settings.ini");
	global.HUD = ini_read_real("Controls", "hud style", 0);
	global.aimStyle = ini_read_real("Controls", "aim style", 0);
	global.autoSprint = ini_read_real("Controls", "auto sprint", false);
	global.quickClimb = ini_read_real("Controls", "quick climb", true);

	global.gripStyle = ini_read_real("Controls", "grip control", 0);
	global.grappleStyle = ini_read_real("Controls", "grapple control", 0);
	global.spiderBallStyle = ini_read_real("Controls", "spiderball control", 0);
	global.dodgeStyle = ini_read_real("Controls", "dodge control", 0);
	
	global.grappleAimAssist = ini_read_real("Controls", "grapple aim assist", true);
ini_close();

// --- Keyboard ---
enum KeyboardButton
{
	Up,
	Down,
	Left,
	Right,
	Jump,
	Shoot,
	Sprint,
	AngleUp,
	AngleDown,
	AimLock,
	QuickMorph,
	ItemSelect,
	ItemCancel
}
enum KeyboardButton_Menu
{
	Start,
	Select,
	Cancel
}

//Samus controls
kRight = false;
kLeft = false;
kUp = false;
kDown = false;
kJump = false;
kShoot = false;
kSprint = false;
kAngleUp = false;
kAngleDown = false;
kAimLock = false;
kQuickMorph = false;
//Samus extra HUD controls
kHSelect = false;
kHCancel = false;

//Menu controls
kMRight = false;
kMLeft = false;
kMUp = false;
kMDown = false;
kMSelect = false;
kMCancel = false;

kStart = false;

// --- Gamepad ---
enum GamepadButton
{
	Jump,
	Shoot,
	Sprint,
	AngleUp,
	AngleDown,
	AimLock,
	QuickMorph,
	ItemSelect,
	ItemCancel
}
enum GamepadButton_Menu
{
	Start,
	Select,
	Cancel
}

//Samus controls
gRight = false;
gLeft = false;
gUp = false;
gDown = false;
gJump = false;
gShoot = false;
gSprint = false;
gAngleUp = false;
gAngleDown = false;
gAimLock = false;
gQuickMorph = false;
//Samus extra HUD controls
gHSelect = false;
gHCancel = false;

//Menu controls
gMRight = false;
gMLeft = false;
gMUp = false;
gMDown = false;
gMSelect = false;
gMCancel = false;

gStart = false;

// --- Final ---

//Samus controls
right = false;
left = false;
up = false;
down = false;
jump = false;
shoot = false;
sprint = false;
angleUp = false;
angleDown = false;
aimLock = false;
quickMorph = false;
//Samus extra HUD controls
hSelect = false;
hCancel = false;

//Menu controls
mRight = false;
mLeft = false;
mUp = false;
mDown = false;
mSelect = false;
mCancel = false;

start = false;

global.gpSlot = -1;			//gamepad slot variable
global.gpButtonNum = 19;	//number of gamepad buttons variable

scr_LoadKeyboard();	//load keyboard bindings
scr_LoadGamepad();	//load gamepad bindings
scr_LoadGamePadID();

usingGamePad = (global.gpSlot != -1);

leftClick = false;
rightClick = false;



cursorActive = false;
cursorActiveTimer = 0;

mousePrevX = mouse_x;
mousePrevY = mouse_y;