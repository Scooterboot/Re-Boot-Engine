/// @description Initialize

/*controlPad = "";
controlPad_Text = "${controlPad}";
function InsertControlPad(str)
{
	return string_replace_all(str,controlPad_Text,controlPad);
}
jumpButton = "";
jumpButton_Text = "${jumpButton}";
function InsertJumpButton(str)
{
	return string_replace_all(str,jumpButton,jumpButton_Text);
}
shootButton = "";
shootButton_Text = "${shootButton}";
function InsertShootButton(str)
{
	return string_replace_all(str,shootButton_Text,shootButton);
}
hudSelectButton = "";
hudSelectButton_Text = "${hudSelectButton}";
function InsertHUDSelectButton(str)
{
	return string_replace_all(str,hudSelectButton_Text,hudSelectButton);
}*/

for(var i = 0; i < 13; i++)
{
	textButton[i] = "";
}
textButton_string[0] = "${controlPad}";
textButton_string[1] = "${jumpButton}";
textButton_string[2] = "${shootButton}";
textButton_string[3] = "${dashButton}";
textButton_string[4] = "${angleUpButton}";
textButton_string[5] = "${angleDownButton}";
textButton_string[6] = "${aimLockButton}";
textButton_string[7] = "${quickMorphButton}";
textButton_string[8] = "${itemSelectButton}";
textButton_string[9] = "${itemCancelButton}";
textButton_string[10] = "${menuStartButton}";
textButton_string[11] = "${menuSelectButton}";
textButton_string[12] = "${menuCancelButton}";
function InsertButtonIcons(str)
{
	var str2 = str;
	for(var i = 0; i < array_length(textButton); i++)
	{
		str2 = string_replace_all(str2,textButton_string[i],textButton[i])
	}
	return str2;
}

for(var i = 0; i < 5; i++)
{
	hudIcon[i] = "[sprt_Text_HUDIcon_"+string(i)+"]";
}
hudIconText = "${hudIcon_";
function InsertHUDIcon(str)
{
	var str2 = str;
	for(var i = 0; i < 5; i++)
	{
		str2 = string_replace_all(str2,hudIconText+string(i)+"}",hudIcon[i])
	}
	return str2;
}

function InsertIconsIntoString(str)
{
	var str2 = str;
	str2 = InsertButtonIcons(str2);
	str2 = InsertHUDIcon(str2);
	return str2;
}


function CreateMessageBox(header,description,messageType)
{
	var mbox = instance_create_depth(0,0,-1,obj_MessageBox);
	mbox.header = header;
	mbox.description = description;
	mbox.messageType = messageType;
}

function UI_Button(_x,_y,_width,_height) constructor
{
	x = _x;
	y = _y;
	width = _width;
	height = _height;
}