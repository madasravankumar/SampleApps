//
//  ViewController.m
//  GoogleLoginUsingSDK
//
//  Created by Gemini-iMac2 on 15/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    
    [self fetchUserProfile:auth];
}

#pragma mark <User Profile>

-(void) fetchUserProfile:(GTMOAuth2Authentication *) oAuthObj {
    
    
    NSString* urlStr = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/me"];
    NSString* oAuthHeaderValue = [NSString stringWithFormat:@"%@ %@",oAuthObj.tokenType,oAuthObj.accessToken];
    
    NSURL* url = [NSURL URLWithString:[urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:oAuthHeaderValue forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
        NSLog(@"Profile Response %@",jsonResponse);
    }];
    
}


-(IBAction)googleLoginbuttonPressed:(id)sender {
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = @"230563829103-n13bkoofth30e03im5pievetfmoftci3.apps.googleusercontent.com";
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[@"https://www.googleapis.com/auth/userinfo.email",@"profile"];
    signIn.delegate = self;
    [signIn authenticate];

}

@end
