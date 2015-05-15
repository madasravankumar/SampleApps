//
//  ViewController.m
//  SampleGoogleLogin
//
//  Created by Gemini-iMac2 on 15/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)googleSignIn:(id)sender {
    
    Class nibClass = NSClassFromString(@"GoogleSignInViewController");
   
    UIViewController *controller =
    [[nibClass alloc] initWithNibName:nil bundle:nil];
    
    UINavigationController* navCont = [[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.navigationController presentViewController:navCont animated:YES completion:nil];
}

@end
