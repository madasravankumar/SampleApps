//
//  GoogleSignInViewController.m
//  SampleGoogleLogin
//
//  Created by Gemini-iMac2 on 15/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "GoogleSignInViewController.h"

NSString* client_Id = @"";
NSString* secret_Id = @"";
NSString* redirect_Url = @"http://localhost";
NSString* access_token = nil;


@interface GoogleSignInViewController ()<UIWebViewDelegate>


@end

@implementation GoogleSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* scope = @"https://www.googleapis.com/auth/plus.login+email";
    
    NSString* urlStr = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&state=SampleLogin&include_granted_scopes=true",client_Id,redirect_Url,scope];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];

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

#pragma mark <UIWebViewDelegate> Methods

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    if ([[[request URL]host]isEqualToString:@"localhost"]) {
        
        NSLog(@"Host: %@",[request.URL host]);
        
        NSString* code = nil;
        NSArray* urlParams = [[[request URL]query] componentsSeparatedByString:@"&"];
        
        NSLog(@"Qurey: %@",[request.URL query]);
        
        for (NSString* parms in urlParams) {
            
            NSArray* keyValue = [parms componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            
            if ([key isEqualToString:@"code"]) {
                code = [keyValue objectAtIndex:1];
                NSLog(@"Code %@",code);
                break;
            }
        }
        
        if (code) {
            
            NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", code,client_Id,secret_Id,redirect_Url];
            NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/token"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                
                if (data) {
               
                    id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
                    
                    if (!connectionError) {
                        
                        NSLog(@"Access Token response %@",jsonResponse);
                        [self fetchUserProfile:jsonResponse];
                    }
                }else {
                    
                    if (connectionError) {
                        
                        NSDictionary* errorDict = [connectionError userInfo];
                        NSString* errorMessage = [errorDict objectForKey:@"NSLocalizedDescription"];
                        
                        [[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",errorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                    }
                }
            }];
        }
    }
    return YES;
}

#pragma mark <User Profile>

-(void) fetchUserProfile:(id) authDict {
    
    
    NSString* urlStr = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/me"];
    NSString* oAuthHeaderValue = [NSString stringWithFormat:@"%@ %@",[authDict objectForKey:@"token_type"],[authDict objectForKey:@"access_token"]];
    
    NSURL* url = [NSURL URLWithString:[urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:oAuthHeaderValue forHTTPHeaderField:@"Authorization"];
     
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
        NSLog(@"Profile Response %@",jsonResponse);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }];
    
}


#pragma mark <Refresh Token>

-(void) getNewAccessTokenUsingRefreshToken {
    
    NSString *data = [NSString stringWithFormat:@"refresh_token=&client_id=%@&client_secret=%@&grant_type=refresh_token",client_Id,secret_Id];
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/token"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data) {
        
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
            if (!connectionError) {
                NSLog(@"Refresh Token: %@",jsonResponse);
            }
        }else {
            
            if (connectionError) {
                
            }
        }
    }];
}
@end
