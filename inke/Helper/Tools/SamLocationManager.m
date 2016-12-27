//
//  SamLocationManager.m
//  inke
//
//  Created by Sam on 12/12/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface SamLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;

@property (nonatomic, copy) LocationBlock block;




@end

@implementation SamLocationManager

+(instancetype)sharedManager
{
    static SamLocationManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       _manager = [[SamLocationManager alloc] init];
    });
    return _manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _locManager = [[CLLocationManager alloc]init];
        [_locManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locManager.distanceFilter = 100;
        _locManager.delegate = self;
        if (![CLLocationManager locationServicesEnabled]) {
            // start location service
            
        } else {
            CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
            if (status == kCLAuthorizationStatusNotDetermined) {
                [_locManager requestWhenInUseAuthorization];
            }
        }
    }
    return self;
}

-(void)getGPS:(LocationBlock)block
{
    self.block = block;
    [self.locManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(nonnull CLLocation *)newLocation fromLocation:(nonnull CLLocation *)oldLocation
{
 
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    NSString *latitude = [NSString stringWithFormat:@"%lf",coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%lf",coordinate.longitude];
    
    [SamLocationManager sharedManager].latitude = latitude;
    [SamLocationManager sharedManager].longitude = longitude;
    
    self.block(latitude,longitude);
    
    [self.locManager stopUpdatingLocation];
}

@end
