/// @description Initialize
// --- Keyboard ---
enum KeyboardButton
{
	Up,
	Down,
	Left,
	Right,
	Jump,
	Shoot,
	Dash,
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
kDash = false;
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
	Dash,
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
gDash = false;
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
dash = false;
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


scr_LoadGamePadID();

usingGamePad = (global.gpSlot != -1);

leftClick = false;
rightClick = false;



cursorActive = false;
cursorActiveTimer = 0;

mousePrevX = mouse_x;
mousePrevY = mouse_y;