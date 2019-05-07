var gp_index = 0;
for(gp_index = gp_face1; gp_index < gp_face1+global.gpButtonNum; gp_index++)
{
    if(gamepad_button_check(global.gpSlot, gp_index))
    {
        break;
    }
}
return gp_index;
