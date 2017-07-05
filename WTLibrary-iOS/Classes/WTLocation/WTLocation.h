//
//  WTLocation.h
//  HiBeacons
//
//  Created by Wat Wongtanuwat on 10/29/14.
//  Copyright (c) 2014 Nick Toumpelis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTLocation_VERSION 0x00010000


// UUID for an estimote beacon : B9407F30-F5F8-466E-AFF9-25556B57FE6D


@import CoreLocation;
@import CoreBluetooth;
@import MapKit;

//NSLocationWhenInUseUsageDescription key specified in your Info.plist
//NSLocationAlwaysUsageDescription key specified in your Info.plist
@interface WTLocation : NSObject<CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

//@property (nonatomic, weak) IBOutlet UITableView *beaconTableView;
//
//@property (nonatomic, weak) IBOutlet UIScrollView *logScrollView;
//@property (nonatomic, weak) IBOutlet UILabel *currentLocationLabel;


@property (nonatomic, weak) id<CLLocationManagerDelegate> locationDelegate;

+ (instancetype)sharedManager;

- (void)openSettingApp;
- (void)requestWhenInUseAuthorization;
- (void)requestAlwaysAuthorization;

@end


@protocol MyProtocol <NSObject>

@end



#import <CoreLocation/CoreLocation.h>

//UIRequiredDeviceCapabilities relevant to location services
//location-services string if you require location services in general.
//gps string if your app requires the accuracy offered only by GPS hardware.
@interface WTLocation(location)<CLLocationManagerDelegate>

- (BOOL)isLocationServicesEnabled;

- (CLActivityType)currentActivityType;
- (void)changeActivityType:(CLActivityType)activityType;

- (void)startStandardUpdates;
- (void)stopStandardUpdates;

- (void)startSignificantChangeUpdates;
- (void)stopSignificantChangeUpdates;

// background
- (BOOL)isDeferredLocationUpdatesAvailable;

@end


//Devices with a magnetometer can report the direction in which a device is pointing, also known as its heading.
//Devices with GPS hardware can report the direction in which a device is moving, also known as its course. (use location.course)

//UIRequiredDeviceCapabilities relevant to location services
//magnetometer—Include this string if your app requires heading information.
//gps—Include this string if your app requires course-related information.
//In both cases, also include the location-services string.
@interface WTLocation(heading)<CLLocationManagerDelegate>

@end

@interface WTLocation(GeographicalRegions)<CLLocationManagerDelegate>

@end

@interface WTLocation(monitor)<CLLocationManagerDelegate, CBPeripheralManagerDelegate>

//@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
//@property (nonatomic, strong) CLBeaconRegion *advertiseBeaconRegion;

@end

@interface WTLocation(range)<CLLocationManagerDelegate, CBPeripheralManagerDelegate>

//@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
//@property (nonatomic, strong) CLBeaconRegion *advertiseBeaconRegion;

@end

#define kWTLocationProximityUUID @"kWTLocationProximityUUID"
#define kWTLocationIdentifier @"kWTLocationIdentifier"
#define kWTLocationMajorValue @"kWTLocationMajorValue"
#define kWTLocationMinorValue @"kWTLocationMinorValue"

#import <CoreBluetooth/CoreBluetooth.h>
@interface WTLocation(advertise)<CLLocationManagerDelegate, CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CLBeaconRegion *advertiseBeaconRegion;




@end

@protocol aaaaa <NSObject>



@end
