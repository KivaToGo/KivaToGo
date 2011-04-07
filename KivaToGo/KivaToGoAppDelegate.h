//
//  KivaToGoAppDelegate.h
//  KivaToGo
//
//  Created by SWP on 3/19/11.
//  Copyright 2011 SWP. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KivaToGoAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate> {
    UIWindow *_window;
    UITabBarController *_tabBarController;
    UIBackgroundTaskIdentifier bgTask;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
