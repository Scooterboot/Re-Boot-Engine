// Feather disable all



// Icon data to return when a binding is empty
InputIconDefineEmpty("empty");

// Icon data to return when a binding is unsupported on the target device
InputIconDefineUnsupported("unsupported");



////////////////////////////
//                        //
//  Unknown Gamepad Type  //
//                        //
////////////////////////////

// Icon data to return when a gamepad type is unrecognised or unsupported

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_face1, "["+sprite_get_name(sprt_UI_GPIcon_Button1)+"]"); //"face south");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_face2, "["+sprite_get_name(sprt_UI_GPIcon_Button2)+"]"); //"face east" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_face3, "["+sprite_get_name(sprt_UI_GPIcon_Button3)+"]"); //"face west" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_face4, "["+sprite_get_name(sprt_UI_GPIcon_Button4)+"]"); //"face north");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_shoulderl,  "["+sprite_get_name(sprt_UI_GPIcon_LBumper)+"]"); //"shoulder l");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_shoulderr,  "["+sprite_get_name(sprt_UI_GPIcon_RBumper)+"]"); //"shoulder r");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_shoulderlb, "["+sprite_get_name(sprt_UI_GPIcon_LTrigger)+"]"); //"trigger l" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_shoulderrb, "["+sprite_get_name(sprt_UI_GPIcon_RTrigger)+"]"); //"trigger r" );

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_select, "["+sprite_get_name(sprt_UI_GPIcon_Select)+"]"); //"select");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_start,  "["+sprite_get_name(sprt_UI_GPIcon_Start)+"]"); //"start" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_home,   "["+sprite_get_name(sprt_UI_GPIcon_Home)+"]"); //"home"  );

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_padl, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Left)+"]"); //"dpad left" ); 
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_padr, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Right)+"]"); //"dpad right"); 
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_padu, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Up)+"]"); //"dpad up"   ); 
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_padd, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Down)+"]"); //"dpad down" ); 

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, -gp_axislh, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Left)+"]"); //"thumbstick l left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_axislh, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Right)+"]"); //"thumbstick l right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, -gp_axislv, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Up)+"]"); //"thumbstick l up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_axislv, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Down)+"]"); //"thumbstick l down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_stickl, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Click)+"]"); //"thumbstick l click");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, -gp_axisrh, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Left)+"]"); //"thumbstick r left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_axisrh, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Right)+"]"); //"thumbstick r right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, -gp_axisrv, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Up)+"]"); //"thumbstick r up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_axisrv, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Down)+"]"); //"thumbstick r down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN,  gp_stickr, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Click)+"]"); //"thumbstick r click");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_paddler,  "["+sprite_get_name(sprt_UI_GPIcon_ButtonP1)+"]"); //"paddle r" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_paddlel,  "["+sprite_get_name(sprt_UI_GPIcon_ButtonP2)+"]"); //"paddle l" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_paddlerb, "["+sprite_get_name(sprt_UI_GPIcon_ButtonP3)+"]"); //"paddle rb");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_paddlelb, "["+sprite_get_name(sprt_UI_GPIcon_ButtonP4)+"]"); //"paddle lb");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra1, "["+sprite_get_name(sprt_UI_GPIcon_Button5)+"]"); //"extra 1");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra2, "["+sprite_get_name(sprt_UI_GPIcon_Button6)+"]"); //"extra 2");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra3, "["+sprite_get_name(sprt_UI_GPIcon_Button7)+"]"); //"extra 3");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra4, "["+sprite_get_name(sprt_UI_GPIcon_Button8)+"]"); //"extra 4");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra5, "["+sprite_get_name(sprt_UI_GPIcon_Button9)+"]"); //"extra 5");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_extra6, "["+sprite_get_name(sprt_UI_GPIcon_Button10)+"]"); //"extra 6");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_UNKNOWN, gp_touchpadbutton, "["+sprite_get_name(sprt_UI_GPIcon_TouchPad)+"]"); //"touchpad");