//
//  AppDelegate.h
//  UriDemoApp
//
//  Created by IVAN MOLERA on 7/2/17.
//  Copyright © 2017 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

