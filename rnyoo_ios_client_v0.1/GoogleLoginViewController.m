//
//  GoogleLoginViewController.m
//  rnyoo_ios_client_v0.1
//
//  Created by Ramesh Kothapalli on 02/09/15.
//  Copyright (c) 2015 iOS Dev 1. All rights reserved.
//

#import "GoogleLoginViewController.h"
#import "MBProgressHUD.h"


NSString *client_id = @"806723916903-j922cfdjanrgl8vo17dlbp84p62rktfg.apps.googleusercontent.com";
NSString *secret = @"xv-DEWo6d3j1oiv0sJSnC3Q1";
NSString *API_KEY = @"AIzaSyDTAO9w-nNW6viNpmuJBnqE1PlBptaBlJc";


NSString *callbakc =  @"http://localhost";;
NSString *scope = @"https://www.googleapis.com/auth/userinfo.email+https://www.googleapis.com/auth/userinfo.profile+https://www.google.com/reader/api/0/subscription";
NSString *visibleactions = @"http://schemas.google.com/AddActivity";

@interface GoogleLoginViewController ()
{
    MBProgressHUD *hud;
    NSMutableData *receivedData;
    NSString *authToken;
    NSString *accessToken;

}
@end

@implementation GoogleLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"Back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnback:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIWebView *webview =[[UIWebView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50)];
    [webview setScalesPageToFit:YES];
    [webview setDelegate:self];
    [self.view addSubview:webview];
    
    
    NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&data-requestvisibleactions=%@",client_id,callbakc,scope,visibleactions];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        hud.frame = CGRectMake(0, 0, 120, 343);
        hud.labelText = @"please wait";
        hud.labelFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //    [indicator startAnimating];
    if ([[[request URL] host] isEqualToString:@"localhost"]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", verifier,client_id,secret,callbakc];
            NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLConnection *theConnection;
            theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];
            
        } else {
            // ERROR!
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    return YES;
}
- (void) btnback :(UIButton *)sender
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSString *response ;
    response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSDictionary *tokenData = [NSJSONSerialization JSONObjectWithData:receivedData
                                                              options:0 error:nil];
    
    if ([tokenData objectForKey:@"refresh_token"]) {
        
        authToken = [tokenData objectForKey:@"refresh_token"];
        accessToken = [tokenData objectForKey:@"access_token"];
        
        
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.frame = CGRectMake(0, 0, 120, 343);
        hud.labelText = @"please wait";
        hud.labelFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
        
        NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/me?key=%@&access_token=%@",API_KEY,[tokenData objectForKey:@"access_token"]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        NSURLConnection *theConnection;
        theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        receivedData = [[NSMutableData alloc] init];
    }
    else if ([tokenData objectForKey:@"id"])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (NSHTTPCookie *cookie in [storage cookies]) {
                [storage deleteCookie:cookie];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(loginsuccesswithGooglePlus:withaccessToken:)])
            {
                [self.delegate loginsuccesswithGooglePlus:tokenData withaccessToken:accessToken];
            }
        }];
    }
    else
    {
        [self btnback:nil];
    }
}
-(IBAction)logout:(id)sender
{
    //    https://accounts.google.com/o/oauth2/revoke?token=
    
    NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/revoke?token=%@",accessToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *theConnection;
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    receivedData = [[NSMutableData alloc] init];
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

@end
