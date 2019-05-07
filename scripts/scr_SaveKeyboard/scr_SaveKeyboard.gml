/// @description scr_SaveKeyboard(newkey,index)
/// @param newkey
/// @param index
var newKey = argument0;

if(argument1 < array_length_1d(global.key))
{
    for(var i = 0; i < array_length_1d(global.key); i++)
    {
        if(global.key[i] == newKey)
        {
            global.key[i] = global.key[argument1];
        }
    }
    global.key[argument1] = newKey;
}
else
{
    var mIndex = argument1-array_length_1d(global.key);

    for(var i = 0; i < array_length_1d(global.key_m); i++)
    {
        if(global.key_m[i] == newKey)
        {
            global.key_m[i] = global.key_m[mIndex];
        }
    }
    global.key_m[mIndex] = newKey;
}

ini_open("settings.ini");
ini_write_real("Keyboard", "up", global.key[0]);
ini_write_real("Keyboard", "down", global.key[1]);
ini_write_real("Keyboard", "left", global.key[2]);
ini_write_real("Keyboard", "right", global.key[3]);
ini_write_real("Keyboard", "jump", global.key[4]);
ini_write_real("Keyboard", "shoot", global.key[5]);
ini_write_real("Keyboard", "dash", global.key[6]);
ini_write_real("Keyboard", "angle up", global.key[7]);
ini_write_real("Keyboard", "angle down", global.key[8]);
ini_write_real("Keyboard", "aim lock", global.key[9]);
ini_write_real("Keyboard", "item select", global.key[10]);
ini_write_real("Keyboard", "item cancel", global.key[11]);
ini_write_real("Keyboard", "pause", global.key[12]);

ini_write_real("Keyboard", "menu select", global.key_m[0]);
ini_write_real("Keyboard", "menu cancel", global.key_m[1]);
ini_write_real("Keyboard", "menu next", global.key_m[2]);
ini_write_real("Keyboard", "menu previous", global.key_m[3]);
ini_close();
