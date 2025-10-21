// Feather disable all

////////////////
//            //
//  Nintendo  //
//            //
////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face1, "["+sprite_get_name(sprt_UI_NSIcon_ButtonB)+"]"); //"B"); //B
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face2, "["+sprite_get_name(sprt_UI_NSIcon_ButtonA)+"]"); //"A"); //A
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face3, "["+sprite_get_name(sprt_UI_NSIcon_ButtonY)+"]"); //"Y"); //Y
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face4, "["+sprite_get_name(sprt_UI_NSIcon_ButtonX)+"]"); //"X"); //X

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderl,  "["+sprite_get_name(sprt_UI_NSIcon_LBumper)+"]"); //"L" ); //L
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderr,  "["+sprite_get_name(sprt_UI_NSIcon_RBumper)+"]"); //"R" ); //R
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderlb, "["+sprite_get_name(sprt_UI_NSIcon_ZLTrigger)+"]"); //"ZL"); //ZL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderrb, "["+sprite_get_name(sprt_UI_NSIcon_ZRTrigger)+"]"); //"ZR"); //ZR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_select, "["+sprite_get_name(sprt_UI_NSIcon_Minus)+"]"); //"minus"); //Minus
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_start,  "["+sprite_get_name(sprt_UI_NSIcon_Plus)+"]"); //"plus" ); //Plus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padl, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Left)+"]"); //"dpad left" ); //D-pad left
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padr, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Right)+"]"); //"dpad right"); //D-pad right
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padu, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Up)+"]"); //"dpad up"   ); //D-pad up
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padd, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Down)+"]"); //"dpad down" ); //D-pad down

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axislh, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Left)+"]"); //"thumbstick l left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axislh, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Right)+"]"); //"thumbstick l right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axislv, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Up)+"]"); //"thumbstick l up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axislv, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Down)+"]"); //"thumbstick l down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_stickl, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Click)+"]"); //"thumbstick l click");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axisrh, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Left)+"]"); //"thumbstick r left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axisrh, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Right)+"]"); //"thumbstick r right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axisrv, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Up)+"]"); //"thumbstick r up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axisrv, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Down)+"]"); //"thumbstick r down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_stickr, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Click)+"]"); //"thumbstick r click");

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_home,   "["+sprite_get_name(sprt_UI_NSIcon_Home)+"]"); //"home");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_extra1, "["+sprite_get_name(sprt_UI_NSIcon_Capture)+"]"); //"capture");

//Switch 2
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_extra2,  "["+sprite_get_name(sprt_UI_NSIcon_Chat)+"]"); //"C" ); //GameChat
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_paddlel, "["+sprite_get_name(sprt_UI_NSIcon_GripL)+"]"); //"GL"); //Grip Left
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_paddler, "["+sprite_get_name(sprt_UI_NSIcon_GripR)+"]"); //"GR"); //Grip Right



///////////////////
//               //
//  Left JoyCon  //
//               //
///////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face1, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Down)+"]"); //"face south"); //Face South
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face2, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Right)+"]"); //"face east" ); //Face East
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face3, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Left)+"]"); //"face west" ); //Face West
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face4, "["+sprite_get_name(sprt_UI_GPIcon_DPad_Up)+"]"); //"face north"); //Face North

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_shoulderl, "["+sprite_get_name(sprt_UI_NSIcon_SLBumper)+"]"); //"SL"); //SL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_shoulderr, "["+sprite_get_name(sprt_UI_NSIcon_SRBumper)+"]"); //"SR"); //SR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_start, "["+sprite_get_name(sprt_UI_NSIcon_Minus)+"]"); //"minus"); //Minus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, -gp_axislh, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Left)+"]"); //"thumbstick left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_axislh, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Right)+"]"); //"thumbstick right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, -gp_axislv, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Up)+"]"); //"thumbstick up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_axislv, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Down)+"]"); //"thumbstick down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_stickl, "["+sprite_get_name(sprt_UI_GPIcon_LStick_Click)+"]"); //"thumbstick click");

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_select, "["+sprite_get_name(sprt_UI_NSIcon_Capture)+"]"); //"capture"); //Capture



////////////////////
//                //
//  Right JoyCon  //
//                //
////////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face1, "["+sprite_get_name(sprt_UI_NSIcon_ButtonA)+"]"); //"face south"); //Face South
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face2, "["+sprite_get_name(sprt_UI_NSIcon_ButtonX)+"]"); //"face east" ); //Face East
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face3, "["+sprite_get_name(sprt_UI_NSIcon_ButtonB)+"]"); //"face west" ); //Face West
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face4, "["+sprite_get_name(sprt_UI_NSIcon_ButtonY)+"]"); //"face north"); //Face North

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_shoulderl, "["+sprite_get_name(sprt_UI_NSIcon_SLBumper)+"]"); //"SL"); //SL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_shoulderr, "["+sprite_get_name(sprt_UI_NSIcon_SRBumper)+"]"); //"SR"); //SR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_start, "["+sprite_get_name(sprt_UI_NSIcon_Plus)+"]"); //"plus"); //Plus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, -gp_axislh, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Left)+"]"); //"thumbstick left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_axislh, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Right)+"]"); //"thumbstick right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, -gp_axislv, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Up)+"]"); //"thumbstick up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_axislv, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Down)+"]"); //"thumbstick down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_stickl, "["+sprite_get_name(sprt_UI_GPIcon_RStick_Click)+"]"); //"thumbstick click");

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_select, "["+sprite_get_name(sprt_UI_NSIcon_Home)+"]"); //"home"); //Home
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_extra2, "["+sprite_get_name(sprt_UI_NSIcon_Chat)+"]"); //"C"   ); //Switch 2 GameChat