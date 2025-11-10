// Feather disable all

////////////////
//            //
//  Keyboard  //
//            //
////////////////

InputIconDefineKeyboard("A", "A");
InputIconDefineKeyboard("B", "B");
InputIconDefineKeyboard("C", "C");
InputIconDefineKeyboard("D", "D");
InputIconDefineKeyboard("E", "E");
InputIconDefineKeyboard("F", "F");
InputIconDefineKeyboard("G", "G");
InputIconDefineKeyboard("H", "H");
InputIconDefineKeyboard("I", "I");
InputIconDefineKeyboard("J", "J");
InputIconDefineKeyboard("K", "K");
InputIconDefineKeyboard("L", "L");
InputIconDefineKeyboard("M", "M");
InputIconDefineKeyboard("N", "N");
InputIconDefineKeyboard("O", "O");
InputIconDefineKeyboard("P", "P");
InputIconDefineKeyboard("Q", "Q");
InputIconDefineKeyboard("R", "R");
InputIconDefineKeyboard("S", "S");
InputIconDefineKeyboard("T", "T");
InputIconDefineKeyboard("U", "U");
InputIconDefineKeyboard("V", "V");
InputIconDefineKeyboard("W", "W");
InputIconDefineKeyboard("X", "X");
InputIconDefineKeyboard("Y", "Y");
InputIconDefineKeyboard("Z", "Z");

InputIconDefineKeyboard("0", "0");
InputIconDefineKeyboard("1", "1");
InputIconDefineKeyboard("2", "2");
InputIconDefineKeyboard("3", "3");
InputIconDefineKeyboard("4", "4");
InputIconDefineKeyboard("5", "5");
InputIconDefineKeyboard("6", "6");
InputIconDefineKeyboard("7", "7");
InputIconDefineKeyboard("8", "8");
InputIconDefineKeyboard("9", "9");

InputIconDefineKeyboard(vk_backtick,   "`");
InputIconDefineKeyboard(vk_hyphen,     "-");
InputIconDefineKeyboard(vk_equals,     "=");
InputIconDefineKeyboard(vk_semicolon,  ";");
InputIconDefineKeyboard(vk_apostrophe, "'");
InputIconDefineKeyboard(vk_comma,      ",");
InputIconDefineKeyboard(vk_period,     ".");
InputIconDefineKeyboard(vk_rbracket,   "]");
InputIconDefineKeyboard(vk_lbracket,   "[");
InputIconDefineKeyboard(vk_fslash,     "/");
InputIconDefineKeyboard(vk_bslash,     "\\");

InputIconDefineKeyboard(vk_scrollock, "Scroll Lock");
InputIconDefineKeyboard(vk_capslock,  "Caps Lock");
InputIconDefineKeyboard(vk_numlock,   "Num Lock");
InputIconDefineKeyboard(vk_lmeta,     "Left Meta");
InputIconDefineKeyboard(vk_rmeta,     "Right Meta");
InputIconDefineKeyboard(vk_clear,     "Clear");
InputIconDefineKeyboard(vk_menu,      "Menu");

InputIconDefineKeyboard(vk_printscreen, "Print Screen");
InputIconDefineKeyboard(vk_pause,       "Pause Break");

InputIconDefineKeyboard(vk_escape,    "Escape");
InputIconDefineKeyboard(vk_backspace, "Backspace");
InputIconDefineKeyboard(vk_space,     "Space");
InputIconDefineKeyboard(vk_enter,     "Enter");

InputIconDefineKeyboard(vk_up,    "Up");
InputIconDefineKeyboard(vk_down,  "Down");
InputIconDefineKeyboard(vk_left,  "Left");
InputIconDefineKeyboard(vk_right, "Right");

InputIconDefineKeyboard(vk_tab,      "Tab");
InputIconDefineKeyboard(vk_ralt,     "Right Alt");
InputIconDefineKeyboard(vk_lalt,     "Left Alt");
InputIconDefineKeyboard(vk_alt,      "Alt");
InputIconDefineKeyboard(vk_rshift,   "Right Shift");
InputIconDefineKeyboard(vk_lshift,   "Left Shift");
InputIconDefineKeyboard(vk_shift,    "Shift");
InputIconDefineKeyboard(vk_rcontrol, "Right Ctrl");
InputIconDefineKeyboard(vk_lcontrol, "Left Ctrl");
InputIconDefineKeyboard(vk_control,  "Ctrl");

InputIconDefineKeyboard(vk_f1,  "F1");
InputIconDefineKeyboard(vk_f2,  "F2");
InputIconDefineKeyboard(vk_f3,  "F3");
InputIconDefineKeyboard(vk_f4,  "F4");
InputIconDefineKeyboard(vk_f5,  "F5");
InputIconDefineKeyboard(vk_f6,  "F6");
InputIconDefineKeyboard(vk_f7,  "F7");
InputIconDefineKeyboard(vk_f8,  "F8");
InputIconDefineKeyboard(vk_f9,  "F9");
InputIconDefineKeyboard(vk_f10, "F10");
InputIconDefineKeyboard(vk_f11, "F11");
InputIconDefineKeyboard(vk_f12, "F12");

InputIconDefineKeyboard(vk_divide,   "Numpad /");
InputIconDefineKeyboard(vk_multiply, "Numpad *");
InputIconDefineKeyboard(vk_subtract, "Numpad -");
InputIconDefineKeyboard(vk_add,      "Numpad +");
InputIconDefineKeyboard(vk_decimal,  "Numpad .");

InputIconDefineKeyboard(vk_numpad0, "Numpad 0");
InputIconDefineKeyboard(vk_numpad1, "Numpad 1");
InputIconDefineKeyboard(vk_numpad2, "Numpad 2");
InputIconDefineKeyboard(vk_numpad3, "Numpad 3");
InputIconDefineKeyboard(vk_numpad4, "Numpad 4");
InputIconDefineKeyboard(vk_numpad5, "Numpad 5");
InputIconDefineKeyboard(vk_numpad6, "Numpad 6");
InputIconDefineKeyboard(vk_numpad7, "Numpad 7");
InputIconDefineKeyboard(vk_numpad8, "Numpad 8");
InputIconDefineKeyboard(vk_numpad9, "Numpad 9");

InputIconDefineKeyboard(vk_delete,   "Delete");
InputIconDefineKeyboard(vk_insert,   "Insert");
InputIconDefineKeyboard(vk_home,     "Home");
InputIconDefineKeyboard(vk_pageup,   "Page up");
InputIconDefineKeyboard(vk_pagedown, "Page down");
InputIconDefineKeyboard(vk_end,      "End");
   
//Name newline character after Enter
InputIconDefineKeyboard(10, "Enter");

//Reset F11 and F12 keycodes on certain platforms
if (INPUT_ON_LINUX || INPUT_ON_MACOS)
{
    InputIconDefineKeyboard(128, "F11");
    InputIconDefineKeyboard(129, "F12");
}

//F13 to F32 on Windows and Web
if (INPUT_ON_WINDOWS || INPUT_ON_WEB)
{
    for(var _i = vk_f1 + 12; _i < vk_f1 + 32; _i++)
    {
        InputIconDefineKeyboard(_i, "F" + string(_i));
    }
}