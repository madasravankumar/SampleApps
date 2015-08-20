//
//  ViewController.m
//  SampleAutoLayout
//
//  Created by Gemini-iMac2 on 23/06/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIButton* button1;
@property (strong, nonatomic) UIButton* button2;
@property (strong, nonatomic) UIImageView* logoImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:102.0f/255.0f blue:204.0f/255.0f alpha:1];
    
    _logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    _logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.logoImageView];
    [self setUpConstraints];
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    // 1. Create a dictionary of views
    /*NSDictionary *viewsDictionary = @{@"redView":self.button1};
    
    // 2. Define the redView Size
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView(100)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[redView(100)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    [self.button1 addConstraints:constraint_H];
    [self.button1 addConstraints:constraint_V];*/
    
    /*NSLayoutConstraint* constraint1 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view  attribute:NSLayoutAttributeWidth multiplier:0 constant:100];
    NSLayoutConstraint* constraint2 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:100];
    NSLayoutConstraint* constraint3 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint* contraint4 = [NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:50];
    
    [self.view addConstraint:constraint1];
    [self.view addConstraint:constraint2];
    [self.view addConstraint:constraint3];
    [self.view addConstraint:contraint4];*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <Constraints>
-(void) setUpConstraints {
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:96]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0 constant:96]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
