//
//  UserData.h
//  UriDemoApp
//
//  Created by IVAN MOLERA on 12/2/17.
//  Copyright © 2017 demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

+ (UserData *)sharedInstance;

- (NSString*) getUserEmail;
- (NSString*) getUserPassword;

- (void) saveUserEmail:(NSString*)email;
- (void) saveUserPassword:(NSString*)password;
- (void) saveUserEmail:(NSString*)email andPassword:(NSString*)password;

- (void) removeUserCredentials;
- (BOOL) haveCredentials;

@end
