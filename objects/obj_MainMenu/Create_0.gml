/// @description Initialize

enum MainScreen
{
	TitleIntro,
	Title,
	FileSelect
}
currentScreen = MainScreen.TitleIntro;

optionPos = 0;

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