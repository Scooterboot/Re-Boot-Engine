// Feather disable all

/// Sets the current preprocessor. This will affect all future calls to extended Scribble Jr.
/// functions (e.g. `ScribbleJrExt()`).
/// 
/// @param method

function ScribbleJrSetPreprocesor(_method)
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
            
            __preprocessorOnce = false;
        }
    }
}