/// @description Update text stuff

/*var moveKeys = scr_CorrectKeyboardString(global.key[0])+","+scr_CorrectKeyboardString(global.key[2])+","+scr_CorrectKeyboardString(global.key[1])+","+scr_CorrectKeyboardString(global.key[3]);
if(global.key[0] == vk_up && global.key[1] == vk_down && global.key[2] == vk_left && global.key[3] == vk_right)
{
	moveKeys = "Arrow keys";
}
textButton[0] = "[["+moveKeys+"]";
for(var i = 1; i < array_length(textButton)-3; i++)
{
	textButton[i] = "[["+scr_CorrectKeyboardString(global.key[i+3])+"]";
}
for(var i = 10; i < 13; i++)
{
	textButton[i] = "[["+scr_CorrectKeyboardString(global.key_m[i-10])+"]";
}
if(obj_Control.usingGamePad)
{
	var controlPad = "[sprt_Text_DPad] / [sprt_Text_LStick]";
	if(!global.gp_useStick)
	{
		controlPad = "[sprt_Text_DPad]";
	}
	else if(!global.gp_usePad)
	{
		controlPad = "[sprt_Text_LStick]";
	}
	textButton[0] = controlPad;
	for(var i = 1; i < array_length(textButton)-3; i++)
	{
		textButton[i] = "[sprt_Text_XBButton_"+string(scr_GetButtonSprtIndexXB(global.gp[i-1]))+"]";
	}
	for(var i = 10; i < 13; i++)
	{
		textButton[i] = "[sprt_Text_XBButton_"+string(scr_GetButtonSprtIndexXB(global.gp_m[i-10]))+"]";
	}
}*/