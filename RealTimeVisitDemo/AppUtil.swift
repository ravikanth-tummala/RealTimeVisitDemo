//
//  AppUtil.swift
//  RealTimeVisitDemo
//
//  Created by GeoSpark on 04/10/21.
//

import Foundation
import CoreLocation

enum locationType:String {
    case didUpdateLocation
    case didVisit
    case pauseLocation
    case resumeLocation
    case didExit

}
class AppUtil {
    
    
    func feature(_ source:locationType,_ loc:CLLocation ) -> Dictionary<String,Any>{
        
        var mainDict:Dictionary<String,Any> = ["type":"Feature"]
        var properties:Dictionary<String,Any> = ["marker-size":"medium","marker-symbol":"circle","LocationManager":source.rawValue]
        let appState = UserDefaults.standard.string(forKey:"AppState")
        
        if appState == "T"{
            properties["marker-color"] = "#e8290c"
        }else{
            properties["marker-color"] = "#1b05e6"
        }
        properties["AppState"] = appState
        properties["recorded_at"] = "\(loc.timestamp)"
 
        let geometry:Dictionary<String,Any> = ["type":"Point","coordinates":[loc.coordinate.longitude,loc.coordinate.latitude]]
        mainDict["properties"] = properties
        mainDict["geometry"] = geometry
        
        return mainDict
    }
    
    
}
