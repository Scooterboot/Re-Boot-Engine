// Feather disable all

/// Returns the default font. If ScribbleJrSetDefaultFont() has never been called, this function
/// will return Scribble Jr.'s fallback font <ScribbleJrDefaultFont>.
/// 
/// @param name

function ScribbleJrGetDefaultFont()
{
    static _system = __ScribbleJrSystem();
    return _system.__defaultFont;
}