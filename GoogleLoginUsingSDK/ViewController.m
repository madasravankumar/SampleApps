//
//  ViewController.m
//  GoogleLoginUsingSDK
//
//  Created by Gemini-iMac2 on 15/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "GTLLoginendpoint.h"

@interface ViewController ()

@end

@implementation ViewController

-(GTLServiceLoginendpoint *) serviceObject {
    
    static GTLServiceLoginendpoint* _loginService = nil;
    
    if (!_loginService) {
        
        _loginService = [[GTLServiceLoginendpoint alloc]init];
        _loginService.retryEnabled = YES;
        
        [GTMHTTPFetcher setLoggingEnabled:YES];

    }
    return _loginService;
}

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

#pragma mark <Custom App Engine Methods>

-(void) loginRequestWithAuthentication:(GTMOAuth2Authentication *) oAuth withProfileInformation:(NSDictionary *) profileInfo {
    
    GTLLoginendpointLoginRequest* request = [[GTLLoginendpointLoginRequest alloc]init];
    request.email = [oAuth.parameters objectForKey:@"email"];
    
    GTLQueryLoginendpoint* query = [GTLQueryLoginendpoint queryForLoginWithObject:request];
    
    [[self serviceObject] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        if (error) {
            
            NSLog(@"Error %@",[NSString stringWithFormat:@"%@",error]);
        }
        
        NSLog(@"Service ticket: %@",ticket.fetchedObject.JSON);
        
        //GTLLoginendpointLoginResponse* loginResponse = (GTLLoginendpointLoginResponse *) ticket.fetchedObject;
        
    }];
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
        
        [[self serviceObject] setAuthorizer:oAuthObj];
        [self loginRequestWithAuthentication:oAuthObj withProfileInformation:jsonResponse];
        
    }];
    
}


-(IBAction)googleLoginbuttonPressed:(id)sender {
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = @"";
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[@"https://www.googleapis.com/auth/userinfo.email",@"profile"];
    signIn.delegate = self;
    [signIn authenticate];

}

@end
