//
//  LoginViewController.h
//  rnyoo_ios_client_v0.1
//
//  Created by iOS Dev 1 on 01/09/15.
//  Copyright (c) 2015 iOS Dev 1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)signin:(id)sender;

@end
