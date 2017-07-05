//
//  WTLocation.m
//  HiBeacons
//
//  Created by Wat Wongtanuwat on 10/29/14.
//  Copyright (c) 2014 Nick Toumpelis. All rights reserved.
//

#import "WTLocation.h"
#import "WTMacro.h"

#if WATLOG_DEBUG_ENABLE
#define WatLog( s, ... ) NSLog( @"WatLog <%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define CLog( s, ... ) [self callLog:[NSString stringWithFormat:(s), ##__VA_ARGS__]];
#else
#define WatLog( s, ... )
#define CLog( s, ... )
#endif

static NSString * const kUUID = @"A3670C83-767A-4953-8454-ADCF165DFF36";
static NSString * const kIdentifier = @"SomeIdentifier";

@interface WTLocation ()

@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

//@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) NSArray *detectedBeacons;
@property (nonatomic, weak) UISwitch *monitoringSwitch;
@property (nonatomic, weak) UISwitch *advertisingSwitch;
@property (nonatomic, weak) UISwitch *rangingSwitch;
@property (nonatomic, unsafe_unretained) void *operationContext;

@property (nonatomic, weak) UILabel *lastLogLabel;
@property (nonatomic, assign) NSUInteger numberOfBeaconFounded;

@end


@interface WTLocation()
//location
@property (nonatomic, readonly) BOOL deferringUpdates;
@end


@implementation WTLocation

+ (instancetype)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (instancetype)init
{
    if (self = [super init]) {
        [self createLocationManager];
        _deferringUpdates = YES;
    }
    return self;
}

- (void)createLocationManager
{
    if (!self.locationManager) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        self.locationManager = locationManager;
    }
}

- (void)openSettingApp
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }else if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"5.0")){
        
    }
}

- (BOOL)isHaveWhenInUseAuthorization
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
            return YES;
        }
    }else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.2")){
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusAuthorized) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isHaveAlwaysAuthorization
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
            return YES;
        }
    }else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.2")){
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusAuthorized) {
            return YES;
        }
    }
    return NO;
}

- (void)checkLocationAccessForMonitoring {
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusDenied ||
            authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Missing"
                                                            message:@"Required Location Access(Always) missing. Click Settings to update Location Access."
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"Cancel", nil];
            [alert show];
            self.monitoringSwitch.on = NO;
            return;
        }
        [self.locationManager requestAlwaysAuthorization];
    }
}

#pragma mark - delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([self.locationDelegate respondsToSelector:@selector(locationManager:didChangeAuthorizationStatus:)]){
        [self.locationDelegate locationManager:manager didChangeAuthorizationStatus:status];
    }
    
}

@end

#pragma mark -

@implementation WTLocation(location)

// call this before do any call to location service
- (BOOL)isLocationServicesEnabled
{
    BOOL locationServicesEnabled = [CLLocationManager locationServicesEnabled];
    return locationServicesEnabled;
}

- (CLActivityType)currentActivityType
{
    return self.locationManager.activityType;
}

- (void)changeActivityType:(CLActivityType)activityType
{
    self.locationManager.activityType = activityType;
}

- (void)startStandardUpdates
{
    //request??
    
    // Create the location manager if this object does not
    // already have one.
    if (self.locationManager == nil)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
//    self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopStandardUpdates
{
    [self.locationManager stopUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (self.locationManager == nil)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopSignificantChangeUpdates
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

//Note: When a user disables the Background App Refresh setting either globally or for your app, the significant-change location service doesn’t relaunch your app. Further, while Background App Refresh is off an app doesn’t receive significant-change or region monitoring events even when it's in the foreground.

- (BOOL)isDeferredLocationUpdatesAvailable
{
    BOOL deferredLocationUpdatesAvailable = [CLLocationManager deferredLocationUpdatesAvailable];
    return deferredLocationUpdatesAvailable;
}

- (void)disallowDeferredLocationUpdates
{
    [self.locationManager  disallowDeferredLocationUpdates];
}

#pragma mark - CLLocationManagerDelegate Location Delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if(oldLocation){
        [self locationManager:manager didUpdateLocations:@[oldLocation,newLocation]];
    }else{
        [self locationManager:manager didUpdateLocations:@[newLocation]];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
    
    
    if (!self.deferringUpdates) {
//        CLLocationDistance distance = self.hike.goal - self.hike.distance;
//        NSTimeInterval time = [self.nextAudible timeIntervalSinceNow];
//        [self.locationManager allowDeferredLocationUpdatesUntilTraveled:distance
//                                                           timeout:time];
//        self.deferringUpdates = YES;
    }
    
    [self.locationDelegate respondsToSelector:@selector(locationManager:didUpdateLocations:)];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}

// will call after allowDeferredLocationUpdatesUntilTraveled:timeout:
// of after disallowDeferredLocationUpdates or stopUpdatingLocation
- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error
{
    
}


////

//- (void)locationManager:(CLLocationManager *)manager
//      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
//{
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
//{
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
//              withError:(NSError *)error
//{
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//         didEnterRegion:(CLRegion *)region
//{
//    
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//          didExitRegion:(CLRegion *)region
//{
//    
//}

//- (void)locationManager:(CLLocationManager *)manager
//monitoringDidFailForRegion:(CLRegion *)region
//{
//    
//}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}

//- (void)locationManager:(CLLocationManager *)manager
//didStartMonitoringForRegion:(CLRegion *)region
//{
//    
//}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    
}

@end

#pragma mark -

@interface WTLocation(heading)

@end

@implementation WTLocation(heading)

- (BOOL)isHeadingAvailable
{
    BOOL headingAvailable = [CLLocationManager headingAvailable];
    return headingAvailable;
}

- (void)startHeadingEvents {
    if (!self.locationManager) {
        CLLocationManager* theManager = [[CLLocationManager alloc] init];
        
        // Retain the object in a property.
        self.locationManager = theManager;
        self.locationManager.delegate = self;
    }
    
    // Start location services to get the true heading.
    self.locationManager.distanceFilter = 1000;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager startUpdatingLocation];
    
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        self.locationManager.headingFilter = 5;
        [self.locationManager startUpdatingHeading];
    }
}

#pragma mark - CLLocationManagerDelegate Heading Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
//    self.currentHeading = theHeading;
//    [self updateHeadingDisplays];
}


- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

@end

#pragma mark -
//In iOS 7.0 and later, always call the isMonitoringAvailableForClass: and authorizationStatus class methods of CLLocationManager before attempting to monitor regions. (In OS X v10.8 and later and in previous versions of iOS, use the regionMonitoringAvailable class instead.) The isMonitoringAvailableForClass: method tells you whether the underlying hardware supports region monitoring for the specified class at all. If that method returns NO, your app can’t use region monitoring on the device. If it returns YES, call the authorizationStatus method to determine whether the app is currently authorized to use location services. If the authorization status is kCLAuthorizationStatusAuthorized, your app can receive boundary crossing notifications for any regions it registered. If the authorization status is set to any other value, the app doesn’t receive those notifications.
//
//Note: Even when an app isn’t authorized to use region monitoring, it can still register regions for use later. If the user subsequently grants authorization to the app, monitoring for those regions will begin and will generate subsequent boundary crossing notifications. If you don’t want regions to remain installed while your app is not authorized, you can use the locationManager:didChangeAuthorizationStatus: delegate method to detect changes in your app’s status and remove regions as appropriate.
//Finally, if your app needs to process location updates in the background, be sure to check the backgroundRefreshStatus property of the UIApplication class. You can use the value of this property to determine if doing so is possible and to warn the user if it is not. Note that the system doesn’t wake your app for region notifications when the Background App Refresh setting is disabled globally or specifically for your app.


@implementation WTLocation(GeographicalRegions)

-(BOOL)isMonitoringAvailableForCircularRegion
{
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus == kCLAuthorizationStatusAuthorized) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)backgroundRefreshStatus
{
    UIBackgroundRefreshStatus backgroundRefreshStatus = [[UIApplication sharedApplication] backgroundRefreshStatus];
    if (backgroundRefreshStatus == UIBackgroundRefreshStatusAvailable) {
        return YES;
    }
    return NO;
}

- (void)registerRegionWithCircularOverlay:(MKCircle*)overlay andIdentifier:(NSString*)identifier {
    
    // If the overlay's radius is too large, registration fails automatically,
    // so clamp the radius to the max value.
    CLLocationDegrees radius = overlay.radius;
    if (radius > self.locationManager.maximumRegionMonitoringDistance) {
        radius = self.locationManager.maximumRegionMonitoringDistance;
    }
    
    // Create the geographic region to be monitored.
    CLCircularRegion *geoRegion = [[CLCircularRegion alloc]
                                   initWithCenter:overlay.coordinate
                                   radius:radius
                                   identifier:identifier];
    [self.locationManager startMonitoringForRegion:geoRegion];
}

#pragma mark - delegate

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    
}

@end




#pragma mark -

@implementation WTLocation(ss)

#pragma mark - Common
- (void)createBeaconRegion
{
    if (self.beaconRegion)
        return;
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
}

- (void)createLocationManager
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//        
//        [self getCurrentLocation:nil];
    }
}

#pragma mark - Beacon ranging

#pragma mark - Beacon region monitoring

- (void)turnOnMonitoring
{
    CLog(@"Turning on monitoring...");
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        CLog(@"Couldn't turn on region monitoring: Region monitoring is not available for CLBeaconRegion class.");
        self.monitoringSwitch.on = NO;
        return;
    }
    
//    [self createBeaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    CLog(@"Monitoring turned on for region: %@.", self.beaconRegion);
}

- (void)stopMonitoringForBeacons
{
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    
    CLog(@"Turned off monitoring");
}

#pragma mark - CLLocationManagerDelegate Location Delegate

#pragma mark - CLLocationManagerDelegate Beacon Delegate ios7

//- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
//{
//    [self.locationManager requestStateForRegion:self.beaconRegion];
//}
//
//- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
//{
//    switch (state) {
//        case CLRegionStateInside:
//            [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
//            
//            break;
//        case CLRegionStateOutside:
//        case CLRegionStateUnknown:
//        default:
//            // stop ranging beacons, etc
//            NSLog(@"Region unknown");
//    }
//}
//
//- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
//{
//    if ([beacons count] > 0) {
//        // Handle your found beacons here
//    }
//}

/*
 *  locationManager:didDetermineState:forRegion:
 *
 *  Discussion:
 *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
 *    a call to requestStateForRegion:.
 */
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
}

/*
 *  locationManager:didRangeBeacons:inRegion:
 *
 *  Discussion:
 *    Invoked when a new set of beacons are available in the specified region.
 *    beacons is an array of CLBeacon objects.
 *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
 *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
 *    by the device.
 */
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    
}

/*
 *  locationManager:rangingBeaconsDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error
{
    
}

/*
 *  locationManager:didEnterRegion:
 *
 *  Discussion:
 *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    
}

/*
 *  locationManager:didExitRegion:
 *
 *  Discussion:
 *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
 *    CLLocationManager instance with a non-nil delegate that implements this method.
 */
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    
}

/*
 *  locationManager:monitoringDidFailForRegion:withError:
 *
 *  Discussion:
 *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{
    
}

/*
 *  locationManager:didStartMonitoringForRegion:
 *
 *  Discussion:
 *    Invoked when a monitoring for a region started successfully.
 */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

@end

#pragma mark -

@interface WTLocation(advertise)

@end

@implementation WTLocation(advertise)

- (CBPeripheralManager *)peripheralManager
{
    if (!self.peripheralManager)
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    return self.peripheralManager;
}

- (CLBeaconRegion *)beaconRegionWithProximityUUID:(NSUUID *)proximityUUID  identifier:(NSString *)identifier
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    identifier:identifier];
    return beaconRegion;
}

- (CLBeaconRegion *)beaconRegionWithProximityUUID:(NSUUID *)proximityUUID major:(CLBeaconMajorValue)major identifier:(NSString *)identifier
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    major:major identifier:identifier];
    return beaconRegion;
}

- (CLBeaconRegion *)beaconRegionWithProximityUUID:(NSUUID *)proximityUUID major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier
{
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:proximityUUID
                                    major:major minor:minor identifier:identifier];
    return beaconRegion;
}

- (BOOL)advertiseBeaconRegionWithData:(NSDictionary *)dataDictionary
{
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"39ED98FF-2900-441A-802F-9C398FC199D2"];
    NSString *identifier = @"com.mycompany.myregion";
    
    self.advertiseBeaconRegion = [self beaconRegionWithProximityUUID:proximityUUID identifier:identifier];
    
    return [self advertiseBeaconRegionWithBeacon:self.advertiseBeaconRegion];
}

- (BOOL)advertiseBeaconRegionWithBeacon:(CLBeaconRegion *)beaconRegion
{
    return [self startAdvertisingBeacon];
}

- (BOOL)startAdvertisingBeacon
{
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        CLog(@"Peripheral manager is off.");
        return NO;
    }
    
    NSDictionary *beaconPeripheralData =
    [self.advertiseBeaconRegion peripheralDataWithMeasuredPower:nil];
    
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    
    CLog(@"Turning on advertising for region: %@.", self.advertiseBeaconRegion);
    
    return YES;
}

- (void)stopAdvertisingBeacon
{
    [self.peripheralManager stopAdvertising];
    
    CLog(@"Turned off advertising.");
}

#pragma mark - delegate @required

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

#pragma mark - delegate @optional

- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict
{
    
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    
}

@end

#pragma mark -

//#import "NATViewController.h"
//
////static NSString * const kUUID = @"00000000-0000-0000-0000-000000000000";
//static NSString * const kUUID = @"A3670C83-767A-4953-8454-ADCF165DFF36";
//static NSString * const kIdentifier = @"SomeIdentifier";
//
//static NSString * const kOperationCellIdentifier = @"OperationCell";
//static NSString * const kBeaconCellIdentifier = @"BeaconCell";
//
//static NSString * const kMonitoringOperationTitle = @"Monitoring";
//static NSString * const kAdvertisingOperationTitle = @"Advertising";
//static NSString * const kRangingOperationTitle = @"Ranging";
//static NSUInteger const kNumberOfSections = 2;
//static NSUInteger const kNumberOfAvailableOperations = 3;
//static CGFloat const kOperationCellHeight = 44;
//static CGFloat const kBeaconCellHeight = 52;
//static NSString * const kBeaconSectionTitle = @"Looking for beacons...";
//static CGPoint const kActivityIndicatorPosition = (CGPoint){205, 12};
//static NSString * const kBeaconsHeaderViewIdentifier = @"BeaconsHeader";
//
//static void * const kMonitoringOperationContext = (void *)&kMonitoringOperationContext;
//static void * const kRangingOperationContext = (void *)&kRangingOperationContext;
//
//typedef NS_ENUM(NSUInteger, NTSectionType) {
//    NTOperationsSection,
//    NTDetectedBeaconsSection
//};
//
//typedef NS_ENUM(NSUInteger, NTOperationsRow) {
//    NTMonitoringRow,
//    NTAdvertisingRow,
//    NTRangingRow
//};
//
//@interface NATViewController ()
//
//@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
//@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
//@property (nonatomic, strong) NSArray *detectedBeacons;
//@property (nonatomic, weak) UISwitch *monitoringSwitch;
//@property (nonatomic, weak) UISwitch *advertisingSwitch;
//@property (nonatomic, weak) UISwitch *rangingSwitch;
//@property (nonatomic, unsafe_unretained) void *operationContext;
//
//@property (nonatomic, weak) UILabel *lastLogLabel;
//@property (nonatomic, assign) NSUInteger numberOfBeaconFounded;
//
//@end
//
//@implementation NATViewController
//
//- (void)callLog:(NSString *)string{
//    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"hh:mm:ss"];//You can set your required format here
//    NSString *dt = [formatter stringFromDate:date];
//    NSString *strDateTaken=dt;
//    
//    NSString *logString = [NSString stringWithFormat:@"%@ %@",strDateTaken,string];
//    NSLog(@"%@",logString);
//    
//    float margin = 5;
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.text = logString;
//    label.numberOfLines = 0;
//    CGRect frame = [logString boundingRectWithSize:CGSizeMake(300, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
//    label.frame = CGRectMake(10, CGRectGetMaxY(self.lastLogLabel.frame)+margin, frame.size.width, frame.size.height);
//    
//    [self.logScrollView addSubview:label];
//    
//    self.logScrollView.contentSize = CGSizeMake(320, CGRectGetMaxY(label.frame)+10);
//    
//    //    NSLog(@"%@",NSStringFromCGPoint(self.logScrollView.contentOffset));
//    //    NSLog(@"%@",NSStringFromCGPoint(CGPointMake(0, CGRectGetMaxY(self.lastLogLabel.frame)-self.logScrollView.frame.size.height)));
//    
//    if(self.logScrollView.contentOffset.y
//       >
//       CGPointMake(0, CGRectGetMaxY(self.lastLogLabel.frame)-self.logScrollView.frame.size.height - 200).y
//       ){
//        [self.logScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(label.frame)-self.logScrollView.frame.size.height) animated:YES];
//    }
//    
//    self.lastLogLabel = label;
//}
//
//#pragma mark - Index path management
//- (NSArray *)indexPathsOfRemovedBeacons:(NSArray *)beacons
//{
//    NSMutableArray *indexPaths = nil;
//    
//    NSUInteger row = 0;
//    for (CLBeacon *existingBeacon in self.detectedBeacons) {
//        BOOL stillExists = NO;
//        for (CLBeacon *beacon in beacons) {
//            if ((existingBeacon.major.integerValue == beacon.major.integerValue) &&
//                (existingBeacon.minor.integerValue == beacon.minor.integerValue)) {
//                stillExists = YES;
//                break;
//            }
//        }
//        if (!stillExists) {
//            if (!indexPaths)
//                indexPaths = [NSMutableArray new];
//            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:NTDetectedBeaconsSection]];
//        }
//        row++;
//    }
//    
//    return indexPaths;
//}
//
//- (NSArray *)indexPathsOfInsertedBeacons:(NSArray *)beacons
//{
//    NSMutableArray *indexPaths = nil;
//    
//    NSUInteger row = 0;
//    for (CLBeacon *beacon in beacons) {
//        BOOL isNewBeacon = YES;
//        for (CLBeacon *existingBeacon in self.detectedBeacons) {
//            if ((existingBeacon.major.integerValue == beacon.major.integerValue) &&
//                (existingBeacon.minor.integerValue == beacon.minor.integerValue)) {
//                isNewBeacon = NO;
//                break;
//            }
//        }
//        if (isNewBeacon) {
//            if (!indexPaths)
//                indexPaths = [NSMutableArray new];
//            [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:NTDetectedBeaconsSection]];
//        }
//        row++;
//    }
//    
//    return indexPaths;
//}
//
//- (NSArray *)indexPathsForBeacons:(NSArray *)beacons
//{
//    NSMutableArray *indexPaths = [NSMutableArray new];
//    for (NSUInteger row = 0; row < beacons.count; row++) {
//        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:NTDetectedBeaconsSection]];
//    }
//    
//    return indexPaths;
//}
//
//- (NSIndexSet *)insertedSections
//{
//    if (self.rangingSwitch.on && [self.beaconTableView numberOfSections] == kNumberOfSections - 1) {
//        return [NSIndexSet indexSetWithIndex:1];
//    } else {
//        return nil;
//    }
//}
//
//- (NSIndexSet *)deletedSections
//{
//    if (!self.rangingSwitch.on && [self.beaconTableView numberOfSections] == kNumberOfSections) {
//        return [NSIndexSet indexSetWithIndex:1];
//    } else {
//        return nil;
//    }
//}
//
//- (NSArray *)filteredBeacons:(NSArray *)beacons
//{
//    // Filters duplicate beacons out; this may happen temporarily if the originating device changes its Bluetooth id
//    NSMutableArray *mutableBeacons = [beacons mutableCopy];
//    
//    NSMutableSet *lookup = [[NSMutableSet alloc] init];
//    for (int index = 0; index < [beacons count]; index++) {
//        CLBeacon *curr = [beacons objectAtIndex:index];
//        NSString *identifier = [NSString stringWithFormat:@"%@/%@", curr.major, curr.minor];
//        
//        // this is very fast constant time lookup in a hash table
//        if ([lookup containsObject:identifier]) {
//            [mutableBeacons removeObjectAtIndex:index];
//        } else {
//            [lookup addObject:identifier];
//        }
//    }
//    
//    return [mutableBeacons copy];
//}
//
//#pragma mark - Table view functionality
//- (NSString *)detailsStringForBeacon:(CLBeacon *)beacon
//{
//    NSString *proximity;
//    switch (beacon.proximity) {
//        case CLProximityNear:
//            proximity = @"Near";
//            break;
//        case CLProximityImmediate:
//            proximity = @"Immediate";
//            break;
//        case CLProximityFar:
//            proximity = @"Far";
//            break;
//        case CLProximityUnknown:
//        default:
//            proximity = @"Unknown";
//            break;
//    }
//    
//    NSString *format = @"%@, %@ • %@ • %f • %li";
//    return [NSString stringWithFormat:format, beacon.major, beacon.minor, proximity, beacon.accuracy, beacon.rssi];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = nil;
//    switch (indexPath.section) {
//        case NTOperationsSection: {
//            cell = [tableView dequeueReusableCellWithIdentifier:kOperationCellIdentifier];
//            switch (indexPath.row) {
//                case NTMonitoringRow:
//                    cell.textLabel.text = kMonitoringOperationTitle;
//                    self.monitoringSwitch = (UISwitch *)cell.accessoryView;
//                    [self.monitoringSwitch addTarget:self
//                                              action:@selector(changeMonitoringState:)
//                                    forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                case NTAdvertisingRow:
//                    cell.textLabel.text = kAdvertisingOperationTitle;
//                    self.advertisingSwitch = (UISwitch *)cell.accessoryView;
//                    [self.advertisingSwitch addTarget:self
//                                               action:@selector(changeAdvertisingState:)
//                                     forControlEvents:UIControlEventValueChanged];
//                    break;
//                case NTRangingRow:
//                default:
//                    cell.textLabel.text = kRangingOperationTitle;
//                    self.rangingSwitch = (UISwitch *)cell.accessoryView;
//                    [self.rangingSwitch addTarget:self
//                                           action:@selector(changeRangingState:)
//                                 forControlEvents:UIControlEventValueChanged];
//                    break;
//            }
//        }
//            break;
//        case NTDetectedBeaconsSection:
//        default: {
//            CLBeacon *beacon = self.detectedBeacons[indexPath.row];
//            
//            cell = [tableView dequeueReusableCellWithIdentifier:kBeaconCellIdentifier];
//            
//            if (!cell)
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                              reuseIdentifier:kBeaconCellIdentifier];
//            
//            cell.textLabel.text = beacon.proximityUUID.UUIDString;
//            cell.detailTextLabel.text = [self detailsStringForBeacon:beacon];
//            cell.detailTextLabel.textColor = [UIColor grayColor];
//        }
//            break;
//    }
//    
//    return cell;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (self.rangingSwitch.on) {
//        return kNumberOfSections;       // All sections visible
//    } else {
//        return kNumberOfSections - 1;   // Beacons section not visible
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    switch (section) {
//        case NTOperationsSection:
//            return kNumberOfAvailableOperations;
//        case NTDetectedBeaconsSection:
//        default:
//            return self.detectedBeacons.count;
//    }
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    switch (section) {
//        case NTOperationsSection:
//            return nil;
//        case NTDetectedBeaconsSection:
//        default:
//            return kBeaconSectionTitle;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    switch (indexPath.section) {
//        case NTOperationsSection:
//            return kOperationCellHeight;
//        case NTDetectedBeaconsSection:
//        default:
//            return kBeaconCellHeight;
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView *headerView =
//    [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kBeaconsHeaderViewIdentifier];
//    
//    // Adds an activity indicator view to the section header
//    UIActivityIndicatorView *indicatorView =
//    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [headerView addSubview:indicatorView];
//    
//    indicatorView.frame = (CGRect){kActivityIndicatorPosition, indicatorView.frame.size};
//    
//    [indicatorView startAnimating];
//    
//    return headerView;
//}
//
//#pragma mark - Common
//- (void)createBeaconRegion
//{
//    if (self.beaconRegion)
//        return;
//    
//    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
//    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:kIdentifier];
//    self.beaconRegion.notifyEntryStateOnDisplay = YES;
//}
//
//- (void)createLocationManager
//{
//    if (!self.locationManager) {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = self;
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//        
//        [self getCurrentLocation:nil];
//    }
//}
//
//#pragma mark - Beacon ranging
//- (void)changeRangingState:sender
//{
//    UISwitch *theSwitch = (UISwitch *)sender;
//    if (theSwitch.on) {
//        [self startRangingForBeacons];
//    } else {
//        [self stopRangingForBeacons];
//    }
//}
//
//- (void)startRangingForBeacons
//{
//    self.operationContext = kRangingOperationContext;
//    
//    [self createLocationManager];
//    
//    [self checkLocationAccessForRanging];
//    
//    self.detectedBeacons = [NSArray array];
//    [self turnOnRanging];
//}
//
//- (void)turnOnRanging
//{
//    CLog(@"Turning on ranging...");
//    
//    if (![CLLocationManager isRangingAvailable]) {
//        CLog(@"Couldn't turn on ranging: Ranging is not available.");
//        self.rangingSwitch.on = NO;
//        return;
//    }
//    
//    if (self.locationManager.rangedRegions.count > 0) {
//        CLog(@"Didn't turn on ranging: Ranging already on.");
//        return;
//    }
//    
//    [self createBeaconRegion];
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
//    
//    CLog(@"Ranging turned on for region: %@.", self.beaconRegion);
//}
//
//- (void)stopRangingForBeacons
//{
//    if (self.locationManager.rangedRegions.count == 0) {
//        CLog(@"Didn't turn off ranging: Ranging already off.");
//        return;
//    }
//    
//    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
//    
//    NSIndexSet *deletedSections = [self deletedSections];
//    self.detectedBeacons = [NSArray array];
//    
//    [self.beaconTableView beginUpdates];
//    if (deletedSections)
//        [self.beaconTableView deleteSections:deletedSections withRowAnimation:UITableViewRowAnimationFade];
//    [self.beaconTableView endUpdates];
//    
//    CLog(@"Turned off ranging.");
//}
//
//#pragma mark - Beacon region monitoring
//- (void)changeMonitoringState:sender
//{
//    UISwitch *theSwitch = (UISwitch *)sender;
//    if (theSwitch.on) {
//        [self startMonitoringForBeacons];
//    } else {
//        [self stopMonitoringForBeacons];
//    }
//}
//
//- (void)startMonitoringForBeacons
//{
//    self.operationContext = kMonitoringOperationContext;
//    
//    [self createLocationManager];
//    
//    [self checkLocationAccessForMonitoring];
//    
//    [self turnOnMonitoring];
//}
//
//- (void)turnOnMonitoring
//{
//    CLog(@"Turning on monitoring...");
//    
//    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
//        CLog(@"Couldn't turn on region monitoring: Region monitoring is not available for CLBeaconRegion class.");
//        self.monitoringSwitch.on = NO;
//        return;
//    }
//    
//    [self createBeaconRegion];
//    [self.locationManager startMonitoringForRegion:self.beaconRegion];
//    
//    CLog(@"Monitoring turned on for region: %@.", self.beaconRegion);
//}
//
//- (void)stopMonitoringForBeacons
//{
//    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
//    
//    CLog(@"Turned off monitoring");
//}
//
//#pragma mark - Location manager delegate methods
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if (![CLLocationManager locationServicesEnabled]) {
//        if (self.operationContext == kMonitoringOperationContext) {
//            CLog(@"Couldn't turn on monitoring: Location services are not enabled.");
//            self.monitoringSwitch.on = NO;
//            return;
//        } else {
//            CLog(@"Couldn't turn on ranging: Location services are not enabled.");
//            self.rangingSwitch.on = NO;
//            return;
//        }
//    }
//    
//    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
//    switch (authorizationStatus) {
//        case kCLAuthorizationStatusAuthorizedAlways:
//            if (self.operationContext == kMonitoringOperationContext) {
//                self.monitoringSwitch.on = YES;
//            } else {
//                self.rangingSwitch.on = YES;
//            }
//            return;
//            
//        case kCLAuthorizationStatusAuthorizedWhenInUse:
//            if (self.operationContext == kMonitoringOperationContext) {
//                CLog(@"Couldn't turn on monitoring: Required Location Access(Always) missing.");
//                self.monitoringSwitch.on = NO;
//            } else {
//                self.rangingSwitch.on = YES;
//            }
//            return;
//            
//        default:
//            if (self.operationContext == kMonitoringOperationContext) {
//                CLog(@"Couldn't turn on monitoring: Required Location Access(Always) missing.");
//                self.monitoringSwitch.on = NO;
//                return;
//            } else {
//                CLog(@"Couldn't turn on monitoring: Required Location Access(WhenInUse) missing.");
//                self.rangingSwitch.on = NO;
//                return;
//            }
//            break;
//    }
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//        didRangeBeacons:(NSArray *)beacons
//               inRegion:(CLBeaconRegion *)region {
//    NSArray *filteredBeacons = [self filteredBeacons:beacons];
//    
//    if (filteredBeacons.count == 0) {
//        if(self.numberOfBeaconFounded != filteredBeacons.count){
//            CLog(@"No beacons found nearby.");
//        }
//    } else {
//        if(self.numberOfBeaconFounded != filteredBeacons.count){
//            CLog(@"Found %lu %@.", (unsigned long)[filteredBeacons count],
//                 [filteredBeacons count] > 1 ? @"beacons" : @"beacon");
//        }
//    }
//    self.numberOfBeaconFounded = filteredBeacons.count;
//    
//    NSIndexSet *insertedSections = [self insertedSections];
//    NSIndexSet *deletedSections = [self deletedSections];
//    NSArray *deletedRows = [self indexPathsOfRemovedBeacons:filteredBeacons];
//    NSArray *insertedRows = [self indexPathsOfInsertedBeacons:filteredBeacons];
//    NSArray *reloadedRows = nil;
//    if (!deletedRows && !insertedRows)
//        reloadedRows = [self indexPathsForBeacons:filteredBeacons];
//    
//    self.detectedBeacons = filteredBeacons;
//    
//    [self.beaconTableView beginUpdates];
//    if (insertedSections)
//        [self.beaconTableView insertSections:insertedSections withRowAnimation:UITableViewRowAnimationFade];
//    if (deletedSections)
//        [self.beaconTableView deleteSections:deletedSections withRowAnimation:UITableViewRowAnimationFade];
//    if (insertedRows)
//        [self.beaconTableView insertRowsAtIndexPaths:insertedRows withRowAnimation:UITableViewRowAnimationFade];
//    if (deletedRows)
//        [self.beaconTableView deleteRowsAtIndexPaths:deletedRows withRowAnimation:UITableViewRowAnimationFade];
//    if (reloadedRows)
//        [self.beaconTableView reloadRowsAtIndexPaths:reloadedRows withRowAnimation:UITableViewRowAnimationNone];
//    [self.beaconTableView endUpdates];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
//{
//    CLog(@"Entered region: %@", region);
//    
//    //    [self sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region];
//    
//    [self sendInRangeLocalNotificationForBeaconRegion:(CLBeaconRegion *)region];
//    
//    CLog(@"Entered Location: %@",[self getCurrentLatLongFromLocation:manager.location]);
//}
//
//- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
//{
//    CLog(@"Exited region: %@", region);
//    
//    [self sendOutRangeLocalNotificationForBeaconRegion:(CLBeaconRegion *)region];
//    
//    CLog(@"Exited Location: %@",[self getCurrentLatLongFromLocation:manager.location]);
//    
//    self.currentLocationLabel.text = [self getCurrentLatLongFromLocation:manager.location];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
//{
//    NSString *stateString = nil;
//    switch (state) {
//        case CLRegionStateInside:
//            stateString = @"inside";
//            break;
//        case CLRegionStateOutside:
//            stateString = @"outside";
//            break;
//        case CLRegionStateUnknown:
//            stateString = @"unknown";
//            break;
//    }
//    CLog(@"State changed to %@ for region %@.", stateString, region);
//}
//
//#pragma mark - Local notifications
//- (void)sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region
//{
//    UILocalNotification *notification = [UILocalNotification new];
//    
//    // Notification details
//    notification.alertBody = [NSString stringWithFormat:@"Entered beacon region for UUID: %@",
//                              region.proximityUUID.UUIDString];   // Major and minor are not available at the monitoring stage
//    notification.alertAction = NSLocalizedString(@"View Details", nil);
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//}
//
//#pragma mark - Beacon advertising
//- (void)changeAdvertisingState:sender
//{
//    UISwitch *theSwitch = (UISwitch *)sender;
//    if (theSwitch.on) {
//        [self startAdvertisingBeacon];
//    } else {
//        [self stopAdvertisingBeacon];
//    }
//}
//
//- (void)startAdvertisingBeacon
//{
//    CLog(@"Turning on advertising...");
//    
//    [self createBeaconRegion];
//    
//    if (!self.peripheralManager)
//        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
//    
//    [self turnOnAdvertising];
//}
//
//- (void)turnOnAdvertising
//{
//    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
//        CLog(@"Peripheral manager is off.");
//        self.advertisingSwitch.on = NO;
//        return;
//    }
//    
//    time_t t;
//    srand((unsigned) time(&t));
//    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.beaconRegion.proximityUUID
//                                                                     major:rand()
//                                                                     minor:rand()
//                                                                identifier:self.beaconRegion.identifier];
//    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
//    [self.peripheralManager startAdvertising:beaconPeripheralData];
//    
//    CLog(@"Turning on advertising for region: %@.", region);
//}
//
//- (void)stopAdvertisingBeacon
//{
//    [self.peripheralManager stopAdvertising];
//    
//    CLog(@"Turned off advertising.");
//}
//
//#pragma mark - Beacon advertising delegate methods
//- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheralManager error:(NSError *)error
//{
//    if (error) {
//        CLog(@"Couldn't turn on advertising: %@", error);
//        self.advertisingSwitch.on = NO;
//        return;
//    }
//    
//    if (peripheralManager.isAdvertising) {
//        CLog(@"Turned on advertising.");
//        self.advertisingSwitch.on = YES;
//    }
//}
//
//- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
//{
//    if (peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
//        CLog(@"Peripheral manager is off.");
//        self.advertisingSwitch.on = NO;
//        return;
//    }
//    
//    CLog(@"Peripheral manager is on.");
//    [self turnOnAdvertising];
//}
//
//#pragma mark - Location access methods (iOS8/Xcode6)
//- (void)checkLocationAccessForRanging {
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager requestWhenInUseAuthorization];
//    }
//}
//
//- (void)checkLocationAccessForMonitoring {
//    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
//        if (authorizationStatus == kCLAuthorizationStatusDenied ||
//            authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Missing"
//                                                            message:@"Required Location Access(Always) missing. Click Settings to update Location Access."
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Settings"
//                                                  otherButtonTitles:@"Cancel", nil];
//            [alert show];
//            self.monitoringSwitch.on = NO;
//            return;
//        }
//        [self.locationManager requestAlwaysAuthorization];
//    }
//}
//
//#pragma mark - Alert view delegate methods
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    }
//}
//
//#pragma mark - location service
//
//- (NSString *)getCurrentLatLongFromLocation:(CLLocation *)location
//{
//    NSString *latitude = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
//    NSString *longitude = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
//    return [NSString stringWithFormat:@"%@,%@",latitude,longitude];
//}
//
//- (void)openMapApp:(CLLocation*)location
//{
//    //    @"http://maps.apple.com/?q.";
//}
//
//- (void)displayRegionCenteredOnMapItem:(CLLocation*)location {
//    
//    MKMapItem *from = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:location.coordinate addressDictionary:nil]];
//    
//    CLLocation* fromLocation = from.placemark.location;
//    
//    // Create a region centered on the starting point with a 10km span
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(fromLocation.coordinate, 10000, 10000);
//    
//    // Open the item in Maps, specifying the map region to display.
//    [MKMapItem openMapsWithItems:[NSArray arrayWithObject:from]
//                   launchOptions:[NSDictionary dictionaryWithObjectsAndKeys:
//                                  [NSValue valueWithMKCoordinate:region.center], MKLaunchOptionsMapCenterKey,
//                                  [NSValue valueWithMKCoordinateSpan:region.span], MKLaunchOptionsMapSpanKey, nil]];
//}
//
//- (IBAction)openMapLocation:(id)sender {
//    
//    [self createLocationManager];
//    
//    //    [self checkLocationAccessForRanging];
//    
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    CLog(@"getLocation");
//    [self.locationManager startUpdatingLocation];
//}
//
//- (IBAction)getCurrentLocation:(id)sender {
//    
//    [self createLocationManager];
//    
//    //    [self checkLocationAccessForRanging];
//    
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    CLog(@"getLocation");
//    [self.locationManager startUpdatingLocation];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//    
//    if (currentLocation != nil) {
//        //        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        //        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//        NSString *latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//        NSString *longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        //        self.currentLocationLabel.text = [self getCurrentLatLongFromLocation:currentLocation];
//        //        CLog(@"%@,%@",longitude,latitude)
//    }
//}
//
//#pragma mark - in range & out range
//
//- (void)sendInRangeLocalNotificationForBeaconRegion:(CLBeaconRegion *)region
//{
//    UILocalNotification *notification = [UILocalNotification new];
//    
//    // Notification details
//    notification.alertBody = [NSString stringWithFormat:@"Entered beacon region for UUID: %@",
//                              region.proximityUUID.UUIDString];   // Major and minor are not available at the monitoring stage
//    notification.alertAction = @"View Details";
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//}
//
//- (void)sendOutRangeLocalNotificationForBeaconRegion:(CLBeaconRegion *)region
//{
//    UILocalNotification *notification = [UILocalNotification new];
//    
//    // Notification details
//    notification.alertBody = [NSString stringWithFormat:@"Exit beacon region for UUID: %@",
//                              region.proximityUUID.UUIDString];   // Major and minor are not available at the monitoring stage
//    notification.alertAction = @"View Details";
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//}
