//
//  KivaToGoAppDelegate.m
//  KivaToGo
//
//  Created by SWP on 3/19/11.
//  Copyright 2011 SWP. All rights reserved.
//

#import "KivaToGoAppDelegate.h"
#import "GANTracker.h"
#import "iKivaConstants.h"

@implementation KivaToGoAppDelegate
@synthesize window=_window;
@synthesize tabBarController = _tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"donationSwitch"] != nil) 
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"donationSwitch"];
    }
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:GOOGLE_ANALYTICS_UID dispatchPeriod:kGANDispatchPeriodSec delegate:nil];
    
    NSError *error;
    [[GANTracker sharedTracker] trackEvent:@"Application_Event" action:@"Launched" label:@"Application_Started" value:1 withError:nil];
    [[GANTracker sharedTracker] trackPageview:@"/applicationDidFinishLaunching" withError:&error];
    
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[GANTracker sharedTracker] trackEvent:@"Application_Event" action:@"Resigned" label:@"Application_Will_Resign_Active" value:-1 withError:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    // Upload Google Analytics records
    UIApplication*    app = [UIApplication sharedApplication];
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task.
        [[GANTracker sharedTracker] dispatch];
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[GANTracker sharedTracker] trackEvent:@"Application_Event" action:@"Resumed" label:@"Application_Resumed" value:1 withError:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[GANTracker sharedTracker] trackEvent:@"Application_Event" action:@"Terminate" label:@"Application_Terminated" value:0 withError:nil];

}

- (void)dealloc
{
    [[GANTracker sharedTracker] stopTracker];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

@end
