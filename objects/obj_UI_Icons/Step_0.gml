/// @description 

if(InputPlayerGetDevice() != prevDevice)
{
	self.GetClusterIcons();
	self.GetButtonIcons();
	
	prevDevice = InputPlayerGetDevice();
}
