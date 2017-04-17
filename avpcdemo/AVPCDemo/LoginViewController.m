//
//  LoginViewController.m
//  AVPCDemo
//
//  Created by IVAN MOLERA on 4/1/17.
//  Copyright © 2017 AVPC. All rights reserved.
//

#import "SWRevealViewController.h"
#import "LoginViewController.h"
#import "UIViewController+Alerts.h"
#import "UserData.h"
@import Firebase;

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void) showLoginScreen:(BOOL)animated {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // Reset view controller (this will quickly clear all the views)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SWRevealViewController *mainViewController = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    
    [window setRootViewController:mainViewController];
    
    // Show login screen
    LoginViewController *viewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    
    [window makeKeyAndVisible];
    [window.rootViewController presentViewController:viewController
                                            animated:animated
                                          completion:nil];
}

+ (void) logout {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    if (!error) {
        // Sign-out succeeded
        
        // Remove credentials
        [[UserData sharedInstance] removeUserCredentials];

        [LoginViewController showLoginScreen:YES];
    }
}

- (void) loginWithEmail:(NSString*)email andPassword:(NSString*)password {

    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             
                             [self hideSpinner:^{
                                 if(error) {
                                     NSLog(@"ERROR signing in: %@", error.localizedDescription);
                                     
                                     // TODO: proper handling to localize errors
                                     [self showMessagePrompt:error.localizedDescription];
                                     
                                     return;
                                 }
                                 else {
                                     
                                     // Save credentials
                                     [[UserData sharedInstance] saveUserEmail:_userEmail.text
                                                                  andPassword:_userPassword.text];
                                     
                                     // Dismiss login screen
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }
                             }];
                         }];
}

- (IBAction)doLogin:(id)sender {
    
    // Not an empty email and password
    if(![_userEmail.text isEqualToString:@""] && ![_userPassword.text isEqualToString:@""]) {

        [self showSpinner:^{
            [self loginWithEmail:_userEmail.text
                     andPassword:_userPassword.text];
        }];
    }
    else {
        // Empty email or password
        [self showMessagePrompt:NSLocalizedString(@"EmptyEmailOrPassword", nil)];
    }
}

- (IBAction)sendPasswordResetEmail:(id)sender {

    // Not an empty email
    if(![_userEmail.text isEqualToString:@""]) {

        [self showSpinner:^{
            [[FIRAuth auth] sendPasswordResetWithEmail:_userEmail.text
                                            completion:^(NSError *error) {
                                 
                                 [self hideSpinner:^{
                                     if(error) {
                                         NSLog(@"ERROR sending reset password email: %@", error.localizedDescription);

                                         // TODO: proper handling to localize errors
                                         [self showMessagePrompt:error.localizedDescription];

                                         return;
                                     }
                                     else {
                                         [self showMessagePrompt:NSLocalizedString(@"EmailPasswordSent", nil)];
                                     }
                                 }];
                             }];
        }];
    }
    else {
        // Empty email
        [self showMessagePrompt:NSLocalizedString(@"EmptyEmail", nil)];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
