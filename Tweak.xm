/**
* DisableThings (iOS 11 - iOS 12)
*/
#include "BSPlatform.h"

%hook SBLockScreenViewController

-(bool) _addBatteryChargingViewAndShowBattery {
	return NO;
}
%end

%hook SBDashBoardCombinedListViewController
-(bool) _disableScrolling {
   return YES;
}
%end

%hook SBMainDisplayPolicyAggregator

-(bool) _allowsCapabilityLockScreenCameraWithExplanation:(id*)arg1  {
   return NO;
}
-(bool) _allowsCapabilityLockScreenTodayViewWithExplanation:(id*)arg1  {
   return NO;
}
%end
