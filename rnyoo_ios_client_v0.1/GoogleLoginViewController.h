//
//  GoogleLoginViewController.h
//  rnyoo_ios_client_v0.1
//
//  Created by Ramesh Kothapalli on 02/09/15.
//  Copyright (c) 2015 iOS Dev 1. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol GPlusDelegate <NSObject>

- (void)loginsuccesswithGooglePlus:(NSDictionary*)objDict withaccessToken:(NSString*)accessToken;
@end

@interface GoogleLoginViewController : UIViewController


@property (nonatomic, strong) id delegate;

@end
