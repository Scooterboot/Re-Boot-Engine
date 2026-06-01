// Feather disable all

/// Sets whether per-character wrapping is enabled for ScribbleJrFit() and ScribbleJrFitExt().
/// Per-character text wrapping is useful for Chinese, Japanese and Korean text where splitting
/// on spaces is impractical.
/// 
/// @param state

function ScribbleJrSetCharacterWrap(_state)
{
    static _system = __ScribbleJrSystem();
    _system.__perCharacterWrap = _state;
}