/// @description 

enum UI_ActiveState
{
	Inactive,
	Deactivating,
	Active,
	Activating
}
activeState = UI_ActiveState.Inactive;

screenFade = 0;
screenFadeRate = 0.075;

#region Set Controls
controlGroups = "menu";
InitControlVars(controlGroups);

cClickL = false;
cClickR = false;

moveCounterX = 0;
moveCounterY = 0;
moveCounterMax = 30;

function SetControlVars_Press()
{
	if(activeState == UI_ActiveState.Active)
	{
		SetControlVars(controlGroups);
		
		cClickL = mouse_check_button(mb_left);
		cClickR = mouse_check_button(mb_right);
		
		var select = (cMenuAccept && rMenuAccept) || (cClickL && rClickL),
			cancel = (cMenuCancel && rMenuCancel) || (cClickR && rClickR);
		if((cMenuLeft || cMenuRight) && !select && !cancel)
		{
			moveCounterX = min(moveCounterX + 1, moveCounterMax);
		}
		else
		{
			moveCounterX = 0;
		}
		
		if((cMenuUp || cMenuDown) && !select && !cancel)
		{
			moveCounterY = min(moveCounterY + 1, moveCounterMax);
		}
		else
		{
			moveCounterY = 0;
		}
	}
	else
	{
		InitControlVars(controlGroups);
		
		cClickL = false;
		cClickR = false;
		rClickL = true;
		rClickR = true;
		
		moveCounterX = 0;
		moveCounterY = 0;
	}
}

rClickL = true;
rClickR = true;

function SetControlVars_Release()
{
	if(activeState == UI_ActiveState.Active)
	{
		SetReleaseVars(controlGroups);
		
		rClickL = !cClickL;
		rClickR = !cClickR;
		
		if(moveCounterX >= moveCounterMax)
		{
			moveCounterX -= 5;
		}
		if(moveCounterY >= moveCounterMax)
		{
			moveCounterY -= 5;
		}
	}
}
#endregion

function MoveSelectX(_repeatFlag = true)
{
	if(_repeatFlag && moveCounterX >= moveCounterMax)
	{
		return cMenuRight - cMenuLeft;
	}
	return (cMenuRight && rMenuRight) - (cMenuLeft && rMenuLeft);
}
function MoveSelectY(_repeatFlag = true)
{
	if(_repeatFlag && moveCounterY >= moveCounterMax)
	{
		return cMenuDown - cMenuUp;
	}
	return (cMenuDown && rMenuDown) - (cMenuUp && rMenuUp);
}

function ScrollX()
{
	return ((cMenuScrollRight && rMenuScrollRight) - (cMenuScrollLeft && rMenuScrollLeft));
}
function ScrollY()
{
	return ((cMenuScrollDown && rMenuScrollDown) - (cMenuScrollUp && rMenuScrollUp));
}

currentPage = noone;
pageList = ds_list_create();
function CreatePage(objInd = obj_UI_Page, _alpha = 0)
{
	var pg = instance_create_depth(0, 0, depth, objInd, {creatorUI : id});
	pg.alpha = _alpha;
	ds_list_add(pageList, pg);
	return pg;
}
