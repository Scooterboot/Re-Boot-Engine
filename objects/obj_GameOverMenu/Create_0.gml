/// @description Initialize
event_inherited();

screenFade = 1.15;

optionPos = 0;
optionSelected = -1;

gameOverText = "GAME OVER";

option[0] = "RESTART FROM LAST SAVE";
option[1] = "QUIT TO MAIN MENU";
option[2] = "QUIT TO DESKTOP";

confirmPos = 0;
confirmText = ["ARE YOU SURE?", "NO", "YES"];
confirmQuitMM = -1;
confirmQuitDT = -1;

cursorFrame = 0;
cursorFrameCounter = 0;


buttonTip = [
"Move",
"Select",
"Cancel"];

buttonTipString = "${controlPad} - "+buttonTip[0]+"   ${menuSelectButton} - "+buttonTip[1];//+"   ${menuCancelButton} - "+buttonTip[2];
buttonTipScrib = scribble(buttonTipString);
buttonTipScrib.starting_format("fnt_GUI_Small2",c_white);
buttonTipScrib.align(fa_center,fa_middle);


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

controlGroups = "menu";
InitControlVars(controlGroups);
