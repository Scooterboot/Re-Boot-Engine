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

function UIBlend() { gpu_set_blendmode_ext_sepalpha(bm_src_alpha,bm_inv_src_alpha,bm_src_alpha,bm_one); }

selectedPanel = noone;
panelList = ds_list_create();

function CreatePanel(_x, _y, _width, _height, _scrollWidth = -1, _scrollHeight = -1, _scrollX = 0, _scrollY = 0)
{
	var pnl = instance_create_depth(_x, _y, depth, obj_UI_Panel);
	
	pnl.width = _width;
	pnl.height = _height;
	
	pnl.scrollWidth = _width;
	pnl.scrollHeight = _height;
	if(_scrollWidth > _width)
	{
		pnl.scrollWidth = _scrollWidth;
	}
	if(_scrollHeight > _height)
	{
		pnl.scrollHeight = _scrollHeight;
	}
	
	pnl.scrollPosX = _scrollX;
	pnl.scrollPosY = _scrollY;
	
	pnl.creator = id;
	
	ds_list_add(panelList, pnl);
	return pnl;
}

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
	UIBlend();
	
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