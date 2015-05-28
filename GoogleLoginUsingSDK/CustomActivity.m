//
//  CustomActivity.m
//  SampleActivityViewController
//
//  Created by Gemini-iMac2 on 27/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "CustomActivity.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface CustomActivity ()

@property (strong, nonatomic) id <GPPShareBuilder> shareBuilder;

@end

@implementation CustomActivity

-(NSString *) activityType {
    return @"com.gemini.googleplus";
}
-(NSString *) activityTitle {
    return @"Google +";
}
-(UIImage *) activityImage {
    return [UIImage imageNamed:@"ShareSheetMask"];
}
-(BOOL) canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (NSObject *item in activityItems) {
        if ([item conformsToProtocol:@protocol(GPPShareBuilder)]) {
            self.shareBuilder = (id<GPPShareBuilder>)item;
        }
    }
}

- (void)performActivity {
    [self activityDidFinish:YES];
    if (![self.shareBuilder open]) {
        GTMLoggerError(@"Status: Error (see console).");
    }
}
@end
