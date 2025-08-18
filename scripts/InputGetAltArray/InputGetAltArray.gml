
function InputGetAltArray(_verbIndex, _playerIndex = 0)
{
	static _playerArray = __InputSystemPlayerArray();
	
	__INPUT_VALIDATE_PLAYER_INDEX
	
	if (not InputGameHasFocus()) return false;
	
	var _device = InputPlayerGetDevice(_playerIndex);
	
	with(_playerArray[_playerIndex])
    {
		if (_device >= 0)
        {
            return __gamepadBindingArray[_verbIndex];
        }
        else if (_device == INPUT_KBM)
        {
            return __kbmBindingArray[_verbIndex];
        }
	}
	
	return [];
}