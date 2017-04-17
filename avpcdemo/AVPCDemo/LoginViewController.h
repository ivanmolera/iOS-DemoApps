//
//  LoginViewController.h
//  AVPCDemo
//
//  Created by IVAN MOLERA on 4/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userEmail;
@property (strong, nonatomic) IBOutlet UITextField *userPassword;

- (void) loginWithEmail:(NSString*)email andPassword:(NSString*)password;
+ (void) logout;
+ (void) showLoginScreen:(BOOL)animated;

@end
