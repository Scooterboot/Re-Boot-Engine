/// @description 

buttonIconKey = array_create(INPUT_VERB._Length);

buttonIconKey[INPUT_VERB.MenuUp] =			"${MenuUp";//}";
buttonIconKey[INPUT_VERB.MenuDown] =		"${MenuDown";//}";
buttonIconKey[INPUT_VERB.MenuLeft] =		"${MenuLeft";//}";
buttonIconKey[INPUT_VERB.MenuRight] =		"${MenuRight";//}";
buttonIconKey[INPUT_VERB.MenuScrollUp] =	"${MenuScrollUp";//}";
buttonIconKey[INPUT_VERB.MenuScrollDown] =	"${MenuScrollDown";//}";
buttonIconKey[INPUT_VERB.MenuScrollLeft] =	"${MenuScrollLeft";//}";
buttonIconKey[INPUT_VERB.MenuScrollRight] = "${MenuScrollRight";//}";

buttonIconKey[INPUT_VERB.Start] =			"${Start";//}";
buttonIconKey[INPUT_VERB.MenuAccept] =		"${MenuAccept";//}";
buttonIconKey[INPUT_VERB.MenuCancel] =		"${MenuCancel";//}";
buttonIconKey[INPUT_VERB.MenuSecondary] =	"${MenuSecondary";//}";
buttonIconKey[INPUT_VERB.MenuTertiary] =	"${MenuTertiary";//}";
buttonIconKey[INPUT_VERB.MenuR1] =			"${MenuR1";//}";
buttonIconKey[INPUT_VERB.MenuR2] =			"${MenuR2";//}";
buttonIconKey[INPUT_VERB.MenuL1] =			"${MenuL1";//}";
buttonIconKey[INPUT_VERB.MenuL2] =			"${MenuL2";//}";

buttonIconKey[INPUT_VERB.PlayerUp] =	"${PlayerUp";//}";
buttonIconKey[INPUT_VERB.PlayerDown] =	"${PlayerDown";//}";
buttonIconKey[INPUT_VERB.PlayerLeft] =	"${PlayerLeft";//}";
buttonIconKey[INPUT_VERB.PlayerRight] = "${PlayerRight";//}";
	
buttonIconKey[INPUT_VERB.Jump] =		"${Jump";//}";
buttonIconKey[INPUT_VERB.Fire] =		"${Fire";//}";
buttonIconKey[INPUT_VERB.Sprint] =		"${Sprint";//}";
buttonIconKey[INPUT_VERB.Dodge] =		"${Dodge";//}";
buttonIconKey[INPUT_VERB.InstaShield] =	"${InstaShield";//}";
buttonIconKey[INPUT_VERB.Morph] =		"${Morph";//}";
buttonIconKey[INPUT_VERB.BoostBall] =	"${BoostBall";//}";
buttonIconKey[INPUT_VERB.SpiderBall] =	"${SpiderBall";//}";
	
buttonIconKey[INPUT_VERB.AimUp] =		"${AimUp";//}";
buttonIconKey[INPUT_VERB.AimDown] =		"${AimDown";//}";
buttonIconKey[INPUT_VERB.AimLock] =		"${AimLock";//}";
buttonIconKey[INPUT_VERB.ReverseAim] =	"${ReverseAim";//}";
buttonIconKey[INPUT_VERB.Moonwalk] =	"${Moonwalk";//}";
		
buttonIconKey[INPUT_VERB.WeapToggle] =	"${WeapToggle";//}";
		
buttonIconKey[INPUT_VERB.VisorToggle] =	"${VisorToggle";//}";
buttonIconKey[INPUT_VERB.VisorCycle] =	"${VisorCycle";//}";
		
buttonIconKey[INPUT_VERB.RadialUIOpen] =	"${RadialUIOpen";//}";
buttonIconKey[INPUT_VERB.RadialUIUp] =		"${RadialUIUp";//}";
buttonIconKey[INPUT_VERB.RadialUIDown] =	"${RadialUIDown";//}";
buttonIconKey[INPUT_VERB.RadialUILeft] =	"${RadialUILeft";//}";
buttonIconKey[INPUT_VERB.RadialUIRight] =	"${RadialUIRight";//}";
		
buttonIconKey[INPUT_VERB.VisorUse] =	"${VisorUse";//}";
buttonIconKey[INPUT_VERB.VisorUp] =		"${VisorUp";//}";
buttonIconKey[INPUT_VERB.VisorDown] =	"${VisorDown";//}";
buttonIconKey[INPUT_VERB.VisorLeft] =	"${VisorLeft";//}";
buttonIconKey[INPUT_VERB.VisorRight] =	"${VisorRight";//}";

buttonClusterIconKey = array_create(INPUT_CLUSTER._Length);
buttonClusterIconKey[INPUT_CLUSTER.MenuMove] =		"${MenuMove";//}";
buttonClusterIconKey[INPUT_CLUSTER.MenuScroll] =	"${MenuScroll";//}";
buttonClusterIconKey[INPUT_CLUSTER.PlayerMove] =	"${PlayerMove";//}";
buttonClusterIconKey[INPUT_CLUSTER.RadialUIMove] =	"${RadialUIMove";//}";
buttonClusterIconKey[INPUT_CLUSTER.VisorMove] =		"${VisorMove";//}";

#macro _MAX_VERB_ICON_ALTS 2

buttonIcon = array_create(INPUT_VERB._Length);
for(var i = 0; i < INPUT_VERB._Length; i++)
{
	buttonIcon[i] = array_create(_MAX_VERB_ICON_ALTS, undefined);
}

#region GetButtonIcons
function GetButtonIcons()
{
	for(var i = 0; i < INPUT_VERB._Length; i++)
	{
		for(var j = 0; j < _MAX_VERB_ICON_ALTS; j++)
		{
			buttonIcon[i][j] = undefined;
			var icon = InputIconGet(i, j);
			if(!is_undefined(icon))
			{
				if(is_string(icon))
				{
					buttonIcon[i][j] = "[["+icon+"]";
				}
				else
				{
					buttonIcon[i][j] = "["+sprite_get_name(icon)+"]";
				}
			}
		}
	}
	
	// TODO: Condition check for if opening radial has separate binding or uses stick
	for(var j = 0; j < _MAX_VERB_ICON_ALTS; j++)
	{
		buttonIcon[INPUT_VERB.RadialUIOpen][j] = buttonClusterIcon[INPUT_CLUSTER.RadialUIMove][j];
	}
}
#endregion

clusterVerbs = array_create(INPUT_CLUSTER._Length);
clusterVerbs[INPUT_CLUSTER.MenuMove] =		[INPUT_VERB.MenuUp,			INPUT_VERB.MenuRight,		INPUT_VERB.MenuDown,		INPUT_VERB.MenuLeft];
clusterVerbs[INPUT_CLUSTER.MenuScroll] =	[INPUT_VERB.MenuScrollUp,	INPUT_VERB.MenuScrollRight,	INPUT_VERB.MenuScrollDown,	INPUT_VERB.MenuScrollLeft];
clusterVerbs[INPUT_CLUSTER.PlayerMove] =	[INPUT_VERB.PlayerUp,		INPUT_VERB.PlayerRight,		INPUT_VERB.PlayerDown,		INPUT_VERB.PlayerLeft];
clusterVerbs[INPUT_CLUSTER.RadialUIMove] =	[INPUT_VERB.RadialUIUp,		INPUT_VERB.RadialUIRight,	INPUT_VERB.RadialUIDown,	INPUT_VERB.RadialUILeft];
clusterVerbs[INPUT_CLUSTER.VisorMove] =		[INPUT_VERB.VisorUp,		INPUT_VERB.VisorRight,		INPUT_VERB.VisorDown,		INPUT_VERB.VisorLeft];

buttonClusterIcon = array_create(INPUT_CLUSTER._Length);
for(var i = 0; i < INPUT_CLUSTER._Length; i++)
{
	buttonClusterIcon[i] = array_create(_MAX_VERB_ICON_ALTS, undefined);
}

#region GetClusterIcons
function GetClusterIcons()
{
	for(var i = 0; i < INPUT_CLUSTER._Length; i++)
	{
		var _verbs = clusterVerbs[i];
		
		for(var k = 0; k < _MAX_VERB_ICON_ALTS; k++)
		{
			var str = "";
			for(var j = 0; j < array_length(_verbs); j++)
			{
				var icon = InputIconGet(_verbs[j], k);
				if(!is_undefined(icon))
				{
					if(is_string(icon))
					{
						str = str+icon;
					}
					else
					{
						str = str+"["+sprite_get_name(icon)+"]";
					}
					
					if(j < array_length(_verbs)-1)
					{
						str = str+"/";
					}
				}
			}
			
			var str2 = AbbreviateCluster(_verbs, k);
			if(!is_undefined(str2))
			{
				str = str2;
			}
			
			buttonClusterIcon[i][k] = (str != "") ? str : undefined;
		}
	}
}
#endregion
#region AbbreviateCluster
function AbbreviateCluster(_verbs, _alt)
{
	var str = undefined;
	var icon = array_create(4);
	for(var i = 0; i < 4; i++)
	{
		icon[i] = InputIconGet(_verbs[i], _alt);
	}
	
	if (!is_undefined(icon[0]) &&
		!is_undefined(icon[1]) &&
		!is_undefined(icon[2]) &&
		!is_undefined(icon[3]))
	{
		if (icon[0] == sprt_UI_GPIcon_DPad_Up &&
			icon[1] == sprt_UI_GPIcon_DPad_Right &&
			icon[2] == sprt_UI_GPIcon_DPad_Down &&
			icon[3] == sprt_UI_GPIcon_DPad_Left)
		{
			str = "["+sprite_get_name(sprt_UI_GPIcon_DPad)+", 0]";
		}
		
		if (icon[0] == sprt_UI_GPIcon_LStick_Up &&
			icon[1] == sprt_UI_GPIcon_LStick_Right &&
			icon[2] == sprt_UI_GPIcon_LStick_Down &&
			icon[3] == sprt_UI_GPIcon_LStick_Left)
		{
			str = "["+sprite_get_name(sprt_UI_GPIcon_LStick)+", 0]";
		}
		
		if (icon[0] == sprt_UI_GPIcon_RStick_Up &&
			icon[1] == sprt_UI_GPIcon_RStick_Right &&
			icon[2] == sprt_UI_GPIcon_RStick_Down &&
			icon[3] == sprt_UI_GPIcon_RStick_Left)
		{
			str = "["+sprite_get_name(sprt_UI_GPIcon_RStick)+", 0]";
		}
		
		if (icon[0] == "Up" &&
			icon[1] == "Right" &&
			icon[2] == "Down" &&
			icon[3] == "Left")
		{
			str = "[[Arrow Keys]";
		}
	}
	return str;
}
#endregion

#region InsertButtonIcons
function InsertButtonIcons(str)
{
	var _notBound = "[[No binding]";
	
	var str2 = str;
	for(var i = 0; i < INPUT_VERB._Length; i++)
	{
		var str3 = "";
		for(var j = 0; j < _MAX_VERB_ICON_ALTS; j++)
		{
			if(!is_undefined(buttonIcon[i][j]))
			{
				str2 = string_replace_all(str2,buttonIconKey[i]+"_"+string(j)+"}", buttonIcon[i][j]);
				
				if(j > 0 && str3 != "")
				{
					str3 = str3+" / ";
				}
				str3 = str3+buttonIcon[i][j];
			}
			else if(j > 0 && !is_undefined(buttonIcon[i][0]))
			{
				str2 = string_replace_all(str2,buttonIconKey[i]+"_"+string(j)+"}", buttonIcon[i][0]);
			}
			else
			{
				str2 = string_replace_all(str2,buttonIconKey[i]+"_"+string(j)+"}", _notBound);
				if(str3 == "" && j >= _MAX_VERB_ICON_ALTS-1)
				{
					str3 = _notBound;
				}
			}
		}
		
		str2 = string_replace_all(str2,buttonIconKey[i]+"}", str3);
	}
	
	for(var i = 0; i < INPUT_CLUSTER._Length; i++)
	{
		var str3 = "";
		for(var j = 0; j < _MAX_VERB_ICON_ALTS; j++)
		{
			if(!is_undefined(buttonClusterIcon[i][j]))
			{
				str2 = string_replace_all(str2,buttonClusterIconKey[i]+"_"+string(j)+"}", buttonClusterIcon[i][j]);
				
				if(j > 0 && str3 != "")
				{
					str3 = str3+" / ";
				}
				str3 = str3+buttonClusterIcon[i][j];
			}
			else if(j > 0 && !is_undefined(buttonClusterIcon[i][0]))
			{
				str2 = string_replace_all(str2,buttonClusterIconKey[i]+"_"+string(j)+"}", buttonClusterIcon[i][0]);
			}
			else
			{
				str2 = string_replace_all(str2,buttonClusterIconKey[i]+"_"+string(j)+"}", _notBound);
				if(str3 == "" && j >= _MAX_VERB_ICON_ALTS-1)
				{
					str3 = _notBound;
				}
			}
		}
		
		str2 = string_replace_all(str2,buttonClusterIconKey[i]+"}", str3);
	}
	
	return str2;
}
#endregion

function InsertIconsIntoString(str)
{
	var str2 = str;
	str2 = InsertButtonIcons(str2);
	return str2;
}


/*
for(var i = 0; i < 13; i++)
{
	textButton[i] = "";
}
textButton_string[0] = "${controlPad}";
textButton_string[1] = "${jumpButton}";
textButton_string[2] = "${shootButton}";
textButton_string[3] = "${sprintButton}";
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
	var mbox = instance_create_depth(0,0,1,obj_MessageBox);
	mbox.header = header;
	mbox.description = description;
	mbox.messageType = messageType;
}*/