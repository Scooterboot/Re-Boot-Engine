// Feather disable all

/// @param value

function __ScribbleJrTrace()
{
    var _string = "ScribbleJr: ";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    SCRIBBLEJR_SHOW_DEBUG_MESSAGE(_string);
}