#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <Firebase.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
//    [FIRApp configure];
    return YES;
}

@end
