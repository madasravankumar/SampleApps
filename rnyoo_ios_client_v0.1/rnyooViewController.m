//
//  rnyooViewController.m
//  rnyoo_ios_client_v0.1
//
//  Created by iOS Dev 1 on 01/09/15.
//  Copyright (c) 2015 iOS Dev 1. All rights reserved.
//

#import "rnyooViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GoogleLoginViewController.h"

@interface rnyooViewController ()

@end

@implementation rnyooViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Login:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Register:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginWithFacebook:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior =  FBSessionLoginBehaviorWithNoFallbackToWebView;
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // IF USER CANCELLED THE LOGIN
        }
        else
        {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                NSString *strToken = result.token.tokenString;
                
                NSLog(@"%@ strToken",strToken);
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     if(error == nil)
                     {
                         NSLog(@"%@ result",result);
                     }
                 }];
                
            }
        }
    }];

}

- (IBAction)loginWithGoogle:(id)sender {
    
    [self performSegueWithIdentifier:@"GoogleplusLogin" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"GoogleplusLogin"])
    {
        GoogleLoginViewController *obj = segue.destinationViewController;
        obj.delegate  =self;
    }
}

- (void)loginsuccesswithGooglePlus:(NSDictionary*)objDict withaccessToken:(NSString*)accessToken;
{
    NSLog(@"%@ objDict ",objDict.description);
}
@end
