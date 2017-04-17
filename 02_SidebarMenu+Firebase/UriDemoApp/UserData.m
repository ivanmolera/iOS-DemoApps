//
//  UserData.m
//  UriDemoApp
//
//  Created by IVAN MOLERA on 12/2/17.
//  Copyright © 2017 demo. All rights reserved.
//

#import "UserData.h"
#import "LoginViewController.h"

@implementation UserData

+ (UserData *)sharedInstance {
    static UserData *sharedInstance = nil;
    
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (UserData *)init {
    if ((self = [super init])) {
        // TODO:
    }
    return self;
}

- (NSString*) getUserEmail {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"];
}

- (NSString*) getUserPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPassword"];
}

- (void) saveUserEmail:(NSString*)email {
    [[NSUserDefaults standardUserDefaults] setObject:email
                                              forKey:@"UserEmail"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) saveUserPassword:(NSString*)password {
    [[NSUserDefaults standardUserDefaults] setObject:password
                                              forKey:@"UserPassword"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) saveUserEmail:(NSString*)email andPassword:(NSString*)password {
    [[NSUserDefaults standardUserDefaults] setObject:email
                                              forKey:@"UserEmail"];
    
    [[NSUserDefaults standardUserDefaults] setObject:password
                                              forKey:@"UserPassword"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) removeUserCredentials {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserEmail"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) haveCredentials {
    
    NSString *email     = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserEmail"];
    NSString *password  = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPassword"];
    
    if((email != nil && ![email isEqualToString:@""]) &&
       (password != nil && ![password isEqualToString:@""])) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
