//
//  LocationManger.swift
//  RealTimeVisitDemo
//
//  Created by GeoSpark on 30/09/21.
//

import Foundation
import CoreLocation



class UserLocationManger : NSObject, CLLocationManagerDelegate{
    
    static let shared = UserLocationManger()
    private let locationManager  = CLLocationManager()
    var currentLocation : CLLocation?
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdateLocationManager(_ pauseLocation:Bool = false,_ clVisit:Bool = false){
    
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = 10
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.showsBackgroundLocationIndicator = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.activityType = .fitness
        self.locationManager.startMonitoringVisits()
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
    }
    func stopUpdateLocationManager(){
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopMonitoringVisits()
        locationManager.stopUpdatingLocation()
    }
    
    func getauthorizedStaus() -> CLAuthorizationStatus{
        self.locationManager.authorizationStatus
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let location = locations.first else {
            return
        }

        self.createGeofence(location.coordinate)
        print("didUpdateLocations",location.description)
        LoggerManager.sharedInstance.showNotification(locationType.didUpdateLocation.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.didUpdateLocation, location))
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
        print("locationManager didVisit")
        guard let location = manager.location else {
            LoggerManager.sharedInstance.showNotification(locationType.didVisit.rawValue, "no location recorded")
            return
        }
        self.createGeofence(location.coordinate)
        LoggerManager.sharedInstance.showNotification(locationType.didVisit.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.didVisit, location))

    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManager DidPauseLocationUpdates")

        guard let location = manager.location else {
            LoggerManager.sharedInstance.showNotification(locationType.pauseLocation.rawValue, "no location recorded")

            return
        }
        self.createGeofence(location.coordinate)
        LoggerManager.sharedInstance.showNotification(locationType.pauseLocation.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.pauseLocation, location))
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("locationManager DidResumeLocationUpdates")
        guard let location = manager.location else {
            LoggerManager.sharedInstance.showNotification(locationType.resumeLocation.rawValue, "no location recorded")
            return
        }
        self.createGeofence(location.coordinate)
        LoggerManager.sharedInstance.showNotification(locationType.resumeLocation.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.resumeLocation, location))
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let location = manager.location else {
            LoggerManager.sharedInstance.showNotification(locationType.didExit.rawValue, "no location recorded")
            return
        }
        self.createGeofence(location.coordinate)
        LoggerManager.sharedInstance.showNotification(locationType.didExit.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.resumeLocation, location))

    }
    private func createGeofence(_ locationCoordinate:CLLocationCoordinate2D){
        let region = CLCircularRegion(center: locationCoordinate, radius: 100, identifier: "locationCoordinate")
        region.notifyOnExit = true
        locationManager.startMonitoring(for: region)
    }
    
    private func clearGeofence(){
        locationManager.monitoredRegions.forEach { region in
            locationManager.stopMonitoring(for: region)
        }
    }
}
