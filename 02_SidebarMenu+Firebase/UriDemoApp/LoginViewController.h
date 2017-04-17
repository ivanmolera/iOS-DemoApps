//
//  LoginViewController.h
//  UriDemoApp
//
//  Created by IVAN MOLERA on 12/2/17.
//  Copyright © 2017 demo. All rights reserved.
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
