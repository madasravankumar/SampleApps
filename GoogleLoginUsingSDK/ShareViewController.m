//
//  ShareViewController.m
//  GoogleLoginUsingSDK
//
//  Created by Gemini-iMac2 on 28/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "ShareViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ItemProvider.h"
#import "CustomActivity.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shareButtonPressed:(id)sender {
    
    ItemProvider* itemObj = [[ItemProvider alloc]init];
    CustomActivity* customAc1 = [[CustomActivity alloc]init];
    
    UIActivityViewController* activityVc = [[UIActivityViewController alloc]initWithActivityItems:[NSArray arrayWithObjects:itemObj, nil] applicationActivities:@[customAc1]];
    activityVc.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVc animated:YES completion:^{
        
    }];
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
