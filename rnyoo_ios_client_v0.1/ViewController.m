//
//  ViewController.m
//  rnyoo_ios_client_v0.1
//
//  Created by iOS Dev 1 on 01/09/15.
//  Copyright (c) 2015 iOS Dev 1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize swipe;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]]];
    /*swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(show)];
    [self.view addGestureRecognizer:swipe];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
