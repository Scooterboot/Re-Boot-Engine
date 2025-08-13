/// @description Initialize
event_inherited();

ini_open("settings.ini");
skipDisc = ini_read_real("misc", "disclaimer understood", false);
ini_close();

screenFade = 0;//1.15;

optionPos = 0;
optionSelected = -1;

disclaimer[0] = "This project was created for entertainment and educational purposes.";
disclaimer[1] = "Due to the nature of this project, I ask that you do not advertise" + "\n" + 
				"it in any form, in any place, unless given permission.";
disclaimer[2] = "The 'Metroid' IP is owned by Nintendo, and given Nintendo's actions" + "\n" + 
				"against fan projects in the past, they may shut this project down.";
disclaimer[3] = "If you are a journalist, Youtuber, or what-have-you," + "\n" + 
				"I ask that you please DO NOT share articles, videos, or any piece of" + "\n" + 
				"media concerning this project anywhere, without permission," + "\n" + 
				"so that this project may go as unnoticed as can be.";
disclaimer[4] = "Thank you for reading and (hopefully) understanding.";

option[0] = "Sure, whatever";
option[1] = "I understand (don't show again)";

cursorFrame = 0;
cursorFrameCounter = 0;

revealText = array_create(6,0);
revealCounter = 0;


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
