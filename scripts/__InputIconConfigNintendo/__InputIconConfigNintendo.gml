// Feather disable all

////////////////
//            //
//  Nintendo  //
//            //
////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face1, new UISpriteIcon(sprt_UI_NSIcon_FaceButtons,1)); //"B"); //B
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face2, new UISpriteIcon(sprt_UI_NSIcon_FaceButtons,0)); //"A"); //A
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face3, new UISpriteIcon(sprt_UI_NSIcon_FaceButtons,3)); //"Y"); //Y
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face4, new UISpriteIcon(sprt_UI_NSIcon_FaceButtons,2)); //"X"); //X

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderl,  new UISpriteIcon(sprt_UI_NSIcon_Shoulders,0)); //"L" ); //L
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderr,  new UISpriteIcon(sprt_UI_NSIcon_Shoulders,1)); //"R" ); //R
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderlb, new UISpriteIcon(sprt_UI_NSIcon_Shoulders,2)); //"ZL"); //ZL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderrb, new UISpriteIcon(sprt_UI_NSIcon_Shoulders,3)); //"ZR"); //ZR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_select, sprt_UI_NSIcon_Minus); //"minus"); //Minus
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_start,  sprt_UI_NSIcon_Plus); //"plus" ); //Plus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padl, sprt_UI_GPIcon_DPad_Left); //"dpad left" ); //D-pad left
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padr, sprt_UI_GPIcon_DPad_Right); //"dpad right"); //D-pad right
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padu, sprt_UI_GPIcon_DPad_Up); //"dpad up"   ); //D-pad up
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padd, sprt_UI_GPIcon_DPad_Down); //"dpad down" ); //D-pad down

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axislh, sprt_UI_GPIcon_LStick_Left); //"thumbstick l left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axislh, sprt_UI_GPIcon_LStick_Right); //"thumbstick l right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axislv, sprt_UI_GPIcon_LStick_Up); //"thumbstick l up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axislv, sprt_UI_GPIcon_LStick_Down); //"thumbstick l down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_stickl, sprt_UI_GPIcon_LStick_Click); //"thumbstick l click");

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axisrh, sprt_UI_GPIcon_RStick_Left); //"thumbstick r left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axisrh, sprt_UI_GPIcon_RStick_Right); //"thumbstick r right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axisrv, sprt_UI_GPIcon_RStick_Up); //"thumbstick r up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axisrv, sprt_UI_GPIcon_RStick_Down); //"thumbstick r down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_stickr, sprt_UI_GPIcon_RStick_Click); //"thumbstick r click");

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_home,   sprt_UI_NSIcon_Home); //"home");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_extra1, sprt_UI_NSIcon_Capture); //"capture");

//Switch 2
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_extra2,  sprt_UI_NSIcon_Chat); //"C" ); //GameChat
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_paddlel, new UISpriteIcon(sprt_UI_NSIcon_Shoulders,4)); //"GL"); //Grip Left
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_paddler, new UISpriteIcon(sprt_UI_NSIcon_Shoulders,5)); //"GR"); //Grip Right



///////////////////
//               //
//  Left JoyCon  //
//               //
///////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face1, sprt_UI_GPIcon_DPad_Down); //"face south"); //Face South
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face2, sprt_UI_GPIcon_DPad_Right); //"face east" ); //Face East
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face3, sprt_UI_GPIcon_DPad_Left); //"face west" ); //Face West
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face4, sprt_UI_GPIcon_DPad_Up); //"face north"); //Face North

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_shoulderl, new UISpriteIcon(sprt_UI_NSIcon_Shoulders,6)); //"SL"); //SL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_shoulderr, new UISpriteIcon(sprt_UI_NSIcon_Shoulders,7)); //"SR"); //SR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_start, sprt_UI_NSIcon_Minus); //"minus"); //Minus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, -gp_axislh, sprt_UI_GPIcon_LStick_Left); //"thumbstick left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_axislh, sprt_UI_GPIcon_LStick_Right); //"thumbstick right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, -gp_axislv, sprt_UI_GPIcon_LStick_Up); //"thumbstick up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_axislv, sprt_UI_GPIcon_LStick_Down); //"thumbstick down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_stickl, sprt_UI_GPIcon_LStick_Click); //"thumbstick click");

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_select, sprt_UI_NSIcon_Capture); //"capture"); //Capture



////////////////////
//                //
//  Right JoyCon  //
//                //
////////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face1, new UISpriteIcon(sprt_UI_NSIcon_FaceButtons,0)); //"face south"); //Face South
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face2, new UISpriteIcon(sprt_UI_NSIcon_FaceButtons,2)); //"face east" ); //Face East
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face3, new UISpriteIcon(sprt_UI_NSIcon_FaceButtons,1)); //"face west" ); //Face West
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face4, new UISpriteIcon(sprt_UI_NSIcon_FaceButtons,3)); //"face north"); //Face North

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_shoulderl, new UISpriteIcon(sprt_UI_NSIcon_Shoulders,6)); //"SL"); //SL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_shoulderr, new UISpriteIcon(sprt_UI_NSIcon_Shoulders,7)); //"SR"); //SR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_start, sprt_UI_NSIcon_Plus); //"plus"); //Plus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, -gp_axislh, sprt_UI_GPIcon_RStick_Left); //"thumbstick left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_axislh, sprt_UI_GPIcon_RStick_Right); //"thumbstick right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, -gp_axislv, sprt_UI_GPIcon_RStick_Up); //"thumbstick up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_axislv, sprt_UI_GPIcon_RStick_Down); //"thumbstick down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_stickl, sprt_UI_GPIcon_RStick_Click); //"thumbstick click");

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_select, sprt_UI_NSIcon_Home); //"home"); //Home
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_extra2, sprt_UI_NSIcon_Chat); //"C"   ); //Switch 2 GameChat