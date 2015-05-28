//
//  LinkedInActivity.m
//  GoogleLoginUsingSDK
//
//  Created by Gemini-iMac2 on 28/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "LinkedInActivity.h"

@implementation LinkedInActivity

-(NSString *) activityType {
    return @"com.gemini.linkedin";
}
-(NSString *) activityTitle {
    return @"Linkedin";
}
-(UIImage *) activityImage {
    return [UIImage imageNamed:@"Linkedin"];
}
-(BOOL) canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}
-(void) prepareWithActivityItems:(NSArray *)activityItems {
    NSLog(@"ActivityItems");
}
-(void) performActivity {
    NSLog(@"Perform Activity");
}

@end
