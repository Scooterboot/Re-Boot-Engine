// Feather disable all

/// Sets the default preprocessor. Any future calls to the extended functions (`ScribbleJrExt`
/// etc.) will use this preprocessor as the default. Calling `ScribbleJrResetPreprocesor()` will
/// reset the current preprocessor to the default preprocessor set by this function.
/// 
/// N.B. Any text elements that have already cached will **not** be updated.
/// 
/// @param [method=SCRIBBLEJR_NO_PREPROCESS]

function ScribbleJrSetPreprocesorDefault(_method = SCRIBBLEJR_NO_PREPROCESS)
{
    static _system = __ScribbleJrSystem();
    
    if ((_method != undefined) && (not script_exists(_method)))
    {
        __ScribbleJrError("Preprocessor functions must be stored in scripts in global scope");
    }
    
    with(_system)
    {
        if (__preprocessorDefault != SCRIBBLEJR_NO_PREPROCESS)
        {
            __preprocessorDefault     = _method;
            __preprocessorDefaultName = string(_method);
            
            if (__preprocessorUsingDefault)
            {
                __preprocessorMethod = __preprocessorDefault;
                __preprocessorName   = __preprocessorDefaultName;
            }
        }
    }
}