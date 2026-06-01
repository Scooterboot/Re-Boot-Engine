// Feather disable all

/// Deletes the colour formatting tag, meaning it can no longer be used to format text. Calling
/// this function will not change the colour of text that's already being drawn (i.e. it won't
/// change the appearance of text that has already been cached).
/// 
/// @param name

function ScribbleJrDeleteColor(_name)
{
    static _colourDict = __ScribbleJrSystem().__colourDict;
    variable_struct_remove(_colourDict, _name);
}