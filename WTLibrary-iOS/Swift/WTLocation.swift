//
//  WTLocation.swift
//  Pods
//
//  Created by iMac on 2/9/16.
//
//

import Foundation
import CoreLocation

// UUID for an estimote beacon : B9407F30-F5F8-466E-AFF9-25556B57FE6D
//NSLocationWhenInUseUsageDescription key specified in your Info.plist
//NSLocationAlwaysUsageDescription key specified in your Info.plist

public class WTLocation: NSObject, CLLocationManagerDelegate {
    
    public lazy var locationManager = CLLocationManager()
    public var delegate: CLLocationManagerDelegate?
    public var deferringUpdates: Bool = false
    
    public override init() {
    }
    
    //MARK: -
    
    public func openSettingApp() {
        if #available(iOS 8.0, *) {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    
    //MARK: -
    
    public func isServiceEnabled() -> Bool {
        let serviceEnabled = CLLocationManager.locationServicesEnabled()
        return serviceEnabled
    }
    
    public func requestWhenInUseAuthorization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestAlwaysAuthorization() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    public func isAuthorizationNotDetemined() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.notDetermined {
            return true
        } else {
            return false
        }
    }
    
    public func isAuthorization() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse || authorizationStatus == CLAuthorizationStatus.authorizedAlways {
            return true
        } else {
            return false
        }
    }
    
    public func isAuthorizationWhenInUse() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse {
            return true
        } else {
            return false
        }
    }
    
    public func isAuthorizationAlways() -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == CLAuthorizationStatus.authorizedAlways {
            return true
        } else {
            return false
        }
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        delegate?.locationManager?(manager, didChangeAuthorization: status)
    }
    
//MARK: -
    
    public func startStandardUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // Set a movement threshold for new events.
        locationManager.distanceFilter = 500; // meters
        locationManager.startUpdatingLocation()
    }
    
    public func stopStandardUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    public func startSignificantChangeUpdates() {
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func stopSignificantChangeUpdates() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        let location = locations.last!
//        let eventDate = location.timestamp
//        let howRecent = eventDate.timeIntervalSinceNow
//        if (abs(howRecent) < 15.0) {
//            // If the event is recent, do something with it.
//            NSLog(@"latitude %+.6f, longitude %+.6f\n",
//                location.coordinate.latitude,
//                location.coordinate.longitude);
            
            delegate?.locationManager?(manager, didUpdateLocations: locations)
//        }
    }
    
    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    //MARK: -
    
    public func isDeferredLocationUpdatesAvailable() -> Bool {
        let deferredLocationUpdatesAvailable = CLLocationManager.deferredLocationUpdatesAvailable()
        return deferredLocationUpdatesAvailable
    }
    
    public func allowDeferredLocationUpdatesUntilTraveled(_ distance: CLLocationDistance, timeout: TimeInterval) {
        if !self.deferringUpdates {
            locationManager.allowDeferredLocationUpdates(untilTraveled: distance, timeout: timeout)
            self.deferringUpdates = true
        }
    }
    
    public func disallowDeferredLocationUpdates() {
        locationManager.disallowDeferredLocationUpdates()
        self.deferringUpdates = false
    }
    
    public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
        self.deferringUpdates = false
        delegate?.locationManager?(manager, didFinishDeferredUpdatesWithError: error)
    }
    
    //MARK: -
    
//    /*
//    *  locationManager:didUpdateHeading:
//    *
//    *  Discussion:
//    *    Invoked when a new heading is available.
//    */
//    @available(iOS 3.0, *)
//    optional public func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
//    
//    /*
//    *  locationManagerShouldDisplayHeadingCalibration:
//    *
//    *  Discussion:
//    *    Invoked when a new heading is available. Return YES to display heading calibration info. The display
//    *    will remain until heading is calibrated, unless dismissed early via dismissHeadingCalibrationDisplay.
//    */
//    @available(iOS 3.0, *)
//    optional public func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool
//    
//    /*
//    *  locationManager:didDetermineState:forRegion:
//    *
//    *  Discussion:
//    *    Invoked when there's a state transition for a monitored region or in response to a request for state via a
//    *    a call to requestStateForRegion:.
//    */
//    @available(iOS 7.0, *)
//    optional public func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion)
//    
//    /*
//    *  locationManager:didRangeBeacons:inRegion:
//    *
//    *  Discussion:
//    *    Invoked when a new set of beacons are available in the specified region.
//    *    beacons is an array of CLBeacon objects.
//    *    If beacons is empty, it may be assumed no beacons that match the specified region are nearby.
//    *    Similarly if a specific beacon no longer appears in beacons, it may be assumed the beacon is no longer received
//    *    by the device.
//    */
//    @available(iOS 7.0, *)
//    optional public func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)
//    
//    /*
//    *  locationManager:rangingBeaconsDidFailForRegion:withError:
//    *
//    *  Discussion:
//    *    Invoked when an error has occurred ranging beacons in a region. Error types are defined in "CLError.h".
//    */
//    @available(iOS 7.0, *)
//    optional public func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError)
//    
//    /*
//    *  locationManager:didEnterRegion:
//    *
//    *  Discussion:
//    *    Invoked when the user enters a monitored region.  This callback will be invoked for every allocated
//    *    CLLocationManager instance with a non-nil delegate that implements this method.
//    */
//    @available(iOS 4.0, *)
//    optional public func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion)
//    
//    /*
//    *  locationManager:didExitRegion:
//    *
//    *  Discussion:
//    *    Invoked when the user exits a monitored region.  This callback will be invoked for every allocated
//    *    CLLocationManager instance with a non-nil delegate that implements this method.
//    */
//    @available(iOS 4.0, *)
//    optional public func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion)
//    
//    /*
//    *  locationManager:didFailWithError:
//    *
//    *  Discussion:
//    *    Invoked when an error has occurred. Error types are defined in "CLError.h".
//    */
//    @available(iOS 2.0, *)
//    optional public func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
//    
//    /*
//    *  locationManager:monitoringDidFailForRegion:withError:
//    *
//    *  Discussion:
//    *    Invoked when a region monitoring error has occurred. Error types are defined in "CLError.h".
//    */
//    @available(iOS 4.0, *)
//    optional public func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError)
//    
//    
//    /*
//    *  locationManager:didStartMonitoringForRegion:
//    *
//    *  Discussion:
//    *    Invoked when a monitoring for a region started successfully.
//    */
//    @available(iOS 5.0, *)
//    optional public func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion)
//    
//    /*
//    *  locationManager:didVisit:
//    *
//    *  Discussion:
//    *    Invoked when the CLLocationManager determines that the device has visited
//    *    a location, if visit monitoring is currently started (possibly from a
//    *    prior launch).
//    */
//    @available(iOS 8.0, *)
//    optional public func locationManager(manager: CLLocationManager, didVisit visit: CLVisit)
}
