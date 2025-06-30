/// @description 

#region Set Controls
cRight = false;
cLeft = false;
cUp = false;
cDown = false;
cSelect = false;
cCancel = false;
cStart = false;

cClickL = false;
cClickR = false;
cScrollUp = false;
cScrollDown = false;

function SetControlVars_Press()
{
	cRight = obj_Control.mRight;
	cLeft = obj_Control.mLeft;
	cUp = obj_Control.mUp;
	cDown = obj_Control.mDown;
	cSelect = obj_Control.mSelect;
	cCancel = obj_Control.mCancel;
	cStart = obj_Control.start;
	
	cClickL = mouse_check_button(mb_left);
	cClickR = mouse_check_button(mb_right);
	cScrollUp = mouse_wheel_up();
	cScrollDown = mouse_wheel_down();
}

rRight = true;
rLeft = true;
rUp = true;
rDown = true;
rSelect = true;
rCancel = true;
rStart = true;

rClickL = true;
rClickR = true;
rScrollUp = true;
rScrollDown = true;

function SetControlVars_Release()
{
	rRight = !cRight;
	rLeft = !cLeft;
	rUp = !cUp;
	rDown = !cDown;
	rSelect = !cSelect;
	rCancel = !cCancel;
	rStart = !cStart;
	
	rClickL = !cClickL;
	rClickR = !cClickR;
	rScrollUp = !cScrollUp;
	rScrollDown = !cScrollDown;
}
#endregion

function ScrollX()
{
	return 0;
}
function ScrollY()
{
	return ((cScrollDown && rScrollDown) - (cScrollUp && rScrollUp));
}

selectedPanel = noone;
panelList = ds_list_create();

function CreatePanel(_x, _y, _width, _height, _scrollWidth = -1, _scrollHeight = -1, _scrollX = 0, _scrollY = 0)
{
	var pnl = instance_create_depth(scr_floor(_x), scr_floor(_y), depth, obj_UI_Panel);
	
	var _w = scr_ceil(_width), _h = scr_ceil(_height),
		_w2 = scr_ceil(_scrollWidth), _h2 = scr_ceil(_scrollHeight);
	pnl.width = _w;
	pnl.height = _h;
	
	pnl.scrollWidth = _w;
	pnl.scrollHeight = _h;
	if(_w2 > _w)
	{
		pnl.scrollWidth = _w2;
	}
	if(_h2 > _h)
	{
		pnl.scrollHeight = _h2;
	}
	
	pnl.scrollPosX = _scrollX;
	pnl.scrollPosY = _scrollY;
	
	pnl.creator = id;
	
	ds_list_add(panelList, pnl);
	return pnl;
}

/*
function UpdateUI()
{
	var pNum = ds_list_size(panelList);
	if(pNum > 0)
	{
		for(var i = 0; i < pNum; i++)
		{
			var _pnl = panelList[| i];
			if(selectedPanel == noone)
			{
				selectedPanel = _pnl;
			}
			
			if(_pnl.active)
			{
				_pnl.UpdatePanel();
			}
		}
	}
}

function DrawUI()
{
	surface_set_target(obj_Display.surfUI);
	bm_set_one();
	
	var pNum = ds_list_size(panelList);
	if(pNum > 0)
	{
		for(var i = 0; i < pNum; i++)
		{
			var _pnl = panelList[| i];
			_pnl.DrawPanel(_pnl.x,_pnl.y);
		}
	}
	
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
}
*/