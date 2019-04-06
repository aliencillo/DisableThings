/**
* DisableThings (iOS 11 - iOS 12)
*/
// #include "BSPlatform.h"
#import "Headers.h"

%hook NSObject
@interface NSObject (customObject)
- (BOOL)isSettingOn:(NSString *)keyStr;
@end


%new
- (BOOL)isSettingOn:(NSString *)keyStr
{
  const char *keyStrC = [keyStr cStringUsingEncoding:NSUTF8StringEncoding];
  CFPreferencesAppSynchronize(CFSTR("pro.aliencillo.disablethingsprefs"));
  CFPropertyListRef value = CFPreferencesCopyAppValue(CFStringCreateWithCString(NULL, keyStrC, kCFStringEncodingUTF8), CFSTR("pro.aliencillo.disablethingsprefs"));

  NSString *valueString = [NSString stringWithFormat:@"%@", value];
  NSString *noVal = @"0";

  if ([valueString isEqualToString:noVal])
  {
    return NO;
  }
  else
  {
    return YES;
  }
}
%end

// lock screen battery
%hook SBLockScreenViewController

-(bool) _addBatteryChargingViewAndShowBattery {
	return NO;
}
%end

// lock screen scroll
%hook SBDashBoardCombinedListViewController
-(bool) _disableScrolling {
  NSObject *object = [[NSObject alloc] init];
  BOOL isSettingOn = [object isSettingOn:@"lockscreenhscrolling"];

  if (isSettingOn)
  {
    
    return YES;
  }
  else
  {
    return %orig;
  }
   
}
%end

// lock screen camera & today
%hook SBMainDisplayPolicyAggregator

-(bool) _allowsCapabilityLockScreenCameraWithExplanation:(id*)arg1  {
  NSObject *object = [[NSObject alloc] init];
  BOOL isSettingOn = [object isSettingOn:@"lockscreencamera"];

  if (isSettingOn)
  {
    
    return NO;
  }
  else
  {
    return %orig;
  }
   
}
-(bool) _allowsCapabilityLockScreenTodayViewWithExplanation:(id*)arg1  {
  NSObject *object = [[NSObject alloc] init];
  BOOL isSettingOn = [object isSettingOn:@"lockscreentoday"];

  if (isSettingOn)
  {
    
    return NO;
  }
  else
  {
    return %orig;
  }
 
}
%end

// lock screen page indicators
%hook SBDashBoardPageControl

- (id)initWithFrame:(struct CGRect)arg1
{
  NSObject *object = [[NSObject alloc] init];
  BOOL isSettingOn = [object isSettingOn:@"sblspageindicator"];

  if (isSettingOn)
  {
    [self removeFromSuperview];
    return nil;
  }
  else
  {
    return %orig;
  }
}
%end
// press home to unlock
%hook SBUICallToActionLabel

-(void)layoutSubviews
{
  %orig;

  NSObject *object = [[NSObject alloc] init];
  BOOL isSettingOn = [object isSettingOn:@"calltoaction"];

  if (isSettingOn)
  {
    [self removeFromSuperview];
  }
}

%end

%hook SBDashBoardTeachableMomentsContainerView

-(void)_layoutCallToActionLabel
{

  NSObject *object = [[NSObject alloc] init];
  BOOL isSettingOn = [object isSettingOn:@"calltoaction"];

  if (!isSettingOn)
  {
    %orig;
  }
}
%end