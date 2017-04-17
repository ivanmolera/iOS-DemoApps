//
//  AppDelegate.m
//  AVPCDemo
//
//  Created by IVAN MOLERA on 4/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import "AppDelegate.h"
#import "UserData.h"
#import "LoginViewController.h"
#import "SWRevealViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // Use Firebase library to configure APIs
    [FIRApp configure];

    [self signIn];

    return YES;
}

- (void) signIn {
    
    if([[UserData sharedInstance] haveCredentials]) {
        FIRAuthCredential *credential = [FIREmailPasswordAuthProvider credentialWithEmail:[[UserData sharedInstance] getUserEmail]
                                                                                 password:[[UserData sharedInstance] getUserPassword]];

        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                      
                                      if(error) {
                                          [self showLoginScreen:NO];
                                      }
                                  }];
    }
    else {
        [self showLoginScreen:NO];
    }
}

- (void) showLoginScreen:(BOOL)animated {

    // Reset view controller (this will quickly clear all the views)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // Show login screen
    LoginViewController *viewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:viewController
                                            animated:animated
                                          completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
