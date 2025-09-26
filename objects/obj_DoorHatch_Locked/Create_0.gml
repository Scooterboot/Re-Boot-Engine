/// @description Initialize
event_inherited();

hatchID = 0;
unlocked = false;
prevUnlocked = false;
UnlockCondition = Condition_ClearRoomEnemies;
unlockAnim = 0;

lockFrame = 4;
lockFrameCounter = 0;
playLockedSnd = false;

mapIconIndex = 4;