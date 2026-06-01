

function UI_Element(_creatorUI, _page, _x, _y, _width, _height, _rawText = []) constructor
{
	creatorUI = _creatorUI;
	page = _page;
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	rawText = [];
	if(is_string(_rawText))
	{
		rawText = [_rawText];
	}
	else if(is_array(_rawText))
	{
		rawText = _rawText;
	}
	
	containerEle = noone;
	nestedEle = ds_list_create();
	selectedEle = noone;
	#region Element Create Functions
	
	
	
	#endregion
	#region Modal functions
	
	function SetModal()
	{
		if(instance_exists(page) && ds_exists(page.modalElements,ds_type_list) && ds_list_find_index(page.modalElements,id) == -1)
		{
			ds_list_add(page.modalElements,id);
		}
	}
	function UnsetModal()
	{
		if(instance_exists(page) && ds_exists(page.modalElements,ds_type_list))
		{
			var pos = ds_list_find_index(page.modalElements,id);
			ds_list_delete(page.modalElements,pos);
		}
	}
	function IsModal()
	{
		return (instance_exists(page) && ds_exists(page.modalElements,ds_type_list) && ds_list_find_index(page.modalElements,id) != -1);
	}
	
	#endregion
	#region IsSelected
	function IsSelected()
	{
		if(instance_exists(containerEle))
		{
			return (containerEle.selectedEle == id && containerEle.IsSelected());
		}
		return (instance_exists(page) && page.selectedEle == id);
	}
	#endregion
	
	scrollPosX = 0;
	scrollPosY = 0;
	#region GetX
	static GetX = function()
	{
		if(containerEle != noone && instance_exists(containerEle))
		{
			return scr_round(containerEle.posX + x - containerEle.scrollPosX);
		}
		if(instance_exists(page))
		{
			return scr_round(page.x + x);
		}
		return -1000;
	}
	#endregion
	posX = GetX();
	#region GetY
	static GetY = function()
	{
		if(containerEle != noone && instance_exists(containerEle))
		{
			return scr_round(containerEle.posY + y - containerEle.scrollPosY);
		}
		if(instance_exists(page))
		{
			return scr_round(page.y + y);
		}
		return -1000;
	}
	#endregion
	posY = GetY();
	
	
}