/*
function gp_anybutton(slotOverride = undefined)
{
	var slot = slotOverride == undefined ? global.gamepadIndex : slotOverride;
	if(array_length(global.gamepad) > 0)
	{
		for(var gp_index = gp_face1; gp_index < gp_face1+global.gpButtonCount[slot]; gp_index++)
		{
			if(gamepad_button_check(global.gamepad[slot], gp_index))
			{
				return gp_index;
			}
		}
	}
	return -1;
}
*/