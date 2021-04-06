/// @description scr_GetButtonSprtIndexXB
/// @param button
function scr_GetButtonSprtIndexXB() {

	var button = argument[0];

	switch(button)
	{
		case gp_face1:
		{
			return 0;
			break;
		}
		case gp_face2:
		{
			return 1;
			break;
		}
		case gp_face3:
		{
			return 2;
			break;
		}
		case gp_face4:
		{
			return 3;
			break;
		}
	
		case gp_shoulderr:
		{
			return 4;
			break;
		}
		case gp_shoulderrb:
		{
			return 5;
			break;
		}
		case gp_shoulderl:
		{
			return 6;
			break;
		}
		case gp_shoulderlb:
		{
			return 7;
			break;
		}
	
		case gp_stickr:
		{
			return 8;
			break;
		}
		case gp_stickl:
		{
			return 9;
			break;
		}
	
		case gp_start:
		{
			return 10;
			break;
		}
		case gp_select:
		{
			return 11;
			break;
		}
	}


}
