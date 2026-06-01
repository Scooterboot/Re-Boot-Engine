// Feather disable all

/// Sets the current preprocessor but only temporarily. The preprocessor set by this function will
/// affect the next calls to an extended Scribble Jr. function (e.g. `ScribbleJrExt()`). After that
/// function has been called, the preprocessor will be set to the default preprocessor.
/// 
/// @param method

function ScribbleJrSetPreprocesorOnce(_method)
{
    static _system = __ScribbleJrSystem();
    
    if ((_method != undefined) && (not script_exists(_method)))
    {
        __ScribbleJrError("Preprocessor functions must be stored in scripts in global scope");
    }
    
    with(_system)
    {
        if (__preprocessorMethod != _method)
        {
            __preprocessorUsingDefault = false;
            
            __preprocessorMethod = _method;
            __preprocessorName   = string(_method);
            
            __preprocessorOnce = true;
        }
    }
}