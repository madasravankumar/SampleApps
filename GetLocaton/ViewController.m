//
//  ViewController.m
//  GetLocaton
//
//  Created by apple on 19/07/15.
//  Copyright (c) 2015 globalnest. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLGeocoder* geoCoder;
@property (strong, nonatomic) CLPlacemark* placeMark;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (![CLLocationManager locationServicesEnabled]) {
        // location services is disabled, alert user
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DisabledTitle", @"DisabledTitle")
                                                                        message:NSLocalizedString(@"DisabledMessage", @"DisabledMessage")
                                                                       delegate:nil
                                                              cancelButtonTitle:NSLocalizedString(@"OKButtonTitle", @"OKButtonTitle")
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }else {
        self.locationManager = [[CLLocationManager alloc]init];
        self.geoCoder = [[CLGeocoder alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = 10.00;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation* location = locations.lastObject;
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            self.placeMark = [placemarks lastObject];
            NSLog(@"Address: %@ %@ %@ %@", self.placeMark.subThoroughfare,self.placeMark.thoroughfare,self.placeMark.locality,self.placeMark.country);
        } else {
            NSLog(@"Error While Finding Address%@", error.debugDescription);
        }
        [self.locationManager stopUpdatingLocation];
    } ];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    //
    NSLog(@"Error: %@", error);
    if ([error code] != kCLErrorLocationUnknown) {
       // [self stopUpdatingLocationWithMessage:NSLocalizedString(@"Error", @"Error")];
    }
}

@end
