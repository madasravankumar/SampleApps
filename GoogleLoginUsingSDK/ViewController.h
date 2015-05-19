//
//  ViewController.h
//  GoogleLoginUsingSDK
//
//  Created by Gemini-iMac2 on 15/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@interface ViewController : UIViewController<GPPSignInDelegate>

@property (retain, nonatomic) IBOutlet UIButton *signInButton;

-(IBAction)googleLoginbuttonPressed:(id)sender;

@end

