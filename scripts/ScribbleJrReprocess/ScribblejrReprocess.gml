// Feather disable all

/// Reprocesses all Scribble Jr. text elements. If any text elements have changed the string that
/// they are displaying then the text element will be regenerated. This is useful to update text
/// based on changing game state.
/// 
/// N.B. This function is very slow. You should only call this function when there has been a
///      significant change in fundamental game state, such as the player changed what type of
///      gamepad they're using. Do not use this function to rapdily update Scribble Jr. text
///      elements.

function ScribbleJrReprocess()
{
    static _system        = __ScribbleJrSystem();
    static _elementsArray = __ScribbleJrSystem().__elementsArray;
    
    var _oldPreprocessorMethod = _system.__preprocessorMethod;
    
    var _i = 0;
    repeat(array_length(_elementsArray)) //We add elements to the cache during this sweep - make sure we don't process new elements
    {
        var _element = _elementsArray[_i];
        
        if (is_instanceof(_element, __ScribbleJrClassExt)
        ||  is_instanceof(_element, __ScribbleJrClassExtFit)
        ||  is_instanceof(_element, __ScribbleJrClassExtShrink))
        {
            with(_element)
            {
                var _wrapperRef = __wrapper;
                if ((_wrapperRef != undefined) && weak_ref_alive(_wrapperRef))
                {
                    var _newString = __preprocessorMethod(__stringOriginal);
                    if (_newString != _element.__string)
                    {
                        __wrapper = undefined;
                        
                        _system.__preprocessorMethod = __preprocessorMethod;
                        
                        //TODO - We're processing the string twice (once to keep, and another time in the constructor)
                        if (is_instanceof(self, __ScribbleJrClassExt))
                        {
                            var _newElement = new __ScribbleJrClassExt(__key, __stringOriginal, __hAlign, __vAlign, __font, __scale);
                        }
                        else if (is_instanceof(self, __ScribbleJrClassExtFit))
                        {
                            var _newElement = new __ScribbleJrClassExtFit(__key, __stringOriginal, __hAlign, __vAlign, __font, __scale, __maxWidth, __maxHeight);
                        }
                        else if (is_instanceof(self, __ScribbleJrClassExtShrink))
                        {
                            var _newElement = new __ScribbleJrClassExtShrink(__key, __stringOriginal, __hAlign, __vAlign, __font, __scale, __maxWidth, __maxHeight);
                        }
                        else
                        {
                            __ScribbleJrError($"Could not recreate text element, unrecognised instanceof ({instanceof(self)})");
                        }
                        
                        _newElement.__wrapper = _wrapperRef;
                        _wrapperRef.ref.__element = _newElement;
                        
                        //TODO - Handle this in the element constructor
                        array_push(_elementsArray, _newElement);
                    }
                }
            }
        }
        
        ++_i;
    }
    
    _system.__preprocessorMethod = _oldPreprocessorMethod;
}