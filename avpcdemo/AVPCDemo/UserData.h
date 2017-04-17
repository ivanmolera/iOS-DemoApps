//
//  UserData.h
//  AVPCDemo
//
//  Created by IVAN MOLERA on 6/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserData : NSObject

@property(nonatomic, assign) BOOL           userAvailabilityStatus;
@property(nonatomic, strong) NSDate         *lastUserPositionUpdate;
@property(nonatomic, strong) CLLocation     *lastUserPositionRegistered;

+ (UserData *)sharedInstance;

- (NSString*) getUserEmail;
- (NSString*) getUserPassword;

- (void) saveUserEmail:(NSString*)email;
- (void) saveUserPassword:(NSString*)password;
- (void) saveUserEmail:(NSString*)email andPassword:(NSString*)password;

- (void) removeUserCredentials;
- (BOOL) haveCredentials;

@end
