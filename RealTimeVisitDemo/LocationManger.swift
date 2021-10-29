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
    
    func startUpdateLocationManager(_ pauseLocation:Bool,_ clVisit:Bool){
    
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.showsBackgroundLocationIndicator = true
        self.locationManager.activityType = .fitness
        
        if pauseLocation{
            locationManager.pausesLocationUpdatesAutomatically = true
        }
        if clVisit{
            locationManager.startMonitoringVisits()
        }
        locationManager.startUpdatingLocation()
    }
    func stopUpdateLocationManager(){
        locationManager.startMonitoringVisits()
        locationManager.stopUpdatingLocation()
    }
    
    func getauthorizedStaus() -> CLAuthorizationStatus{
        self.locationManager.authorizationStatus
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let location = locations.first else {
            return
        }

        print("didUpdateLocations",location.description)
//        LoggerManager.sharedInstance.showNotification(locationType.didUpdateLocation.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.didUpdateLocation, location))
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
        print("locationManager didVisit")
        guard let location = manager.location else {
            LoggerManager.sharedInstance.showNotification(locationType.didVisit.rawValue, "no location recorded")
            return
        }
        LoggerManager.sharedInstance.showNotification(locationType.didVisit.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.didVisit, location))

    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManager DidPauseLocationUpdates")

        guard let location = manager.location else {
            LoggerManager.sharedInstance.showNotification(locationType.pauseLocation.rawValue, "no location recorded")

            return
        }
        LoggerManager.sharedInstance.showNotification(locationType.pauseLocation.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.pauseLocation, location))
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("locationManager DidResumeLocationUpdates")
        guard let location = manager.location else {
            LoggerManager.sharedInstance.showNotification(locationType.resumeLocation.rawValue, "no location recorded")
            return
        }
        LoggerManager.sharedInstance.showNotification(locationType.resumeLocation.rawValue, location.description)
        LoggerManager.sharedInstance.writeLocationToFile(AppUtil().feature(.resumeLocation, location))
    }
}
