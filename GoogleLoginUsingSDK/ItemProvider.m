//
//  ItemProvider.m
//  SampleActivityViewController
//
//  Created by Gemini-iMac2 on 27/05/15.
//  Copyright (c) 2015 Gemini-iMac2. All rights reserved.
//

#import "ItemProvider.h"
#import <GooglePlus/GooglePlus.h>

@implementation ItemProvider

-(id) initWithPlaceholderItem:(id)placeholderItem {
    return [super initWithPlaceholderItem:placeholderItem];
}

-(id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

-(id) item {
    return @"";
}

-(id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    
    NSString* shareStr = @"This is sample Project";
    
    if([activityType isEqualToString:UIActivityTypeMail]) NSLog(@"Mail");
    
    else if ([activityType isEqualToString:@"com.gemini.googleplus"]) return [self shareBuilder];
    
    return shareStr;
}

-(id<GPPShareBuilder>) shareBuilder {
    
    id <GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance]nativeShareDialog];
    
    [shareBuilder setURLToShare:[NSURL URLWithString:@"https://developers.google.com/+/mobile/ios/share/"]];
    [shareBuilder setPrefillText:@"This is My First Share"];
    
    return shareBuilder;
}
@end
