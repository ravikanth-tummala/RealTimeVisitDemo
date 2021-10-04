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
}
class AppUtil {
    
    
    func feature(_ source:locationType,_ loc:CLLocation ) -> Dictionary<String,Any>{
        
        var mainDict:Dictionary<String,Any> = ["type":"Feature"]
        var properties:Dictionary<String,Any> = ["marker-size":"medium","marker-symbol":"circle","LocationManager":source.rawValue]
        var marker_color:String?
        properties["marker-color"] = marker_color
        properties["recorded_at"] = loc.timestamp
        
        if source.hashValue == 0 {
            marker_color = "#ff0000"
        } else if source.hashValue == 1{
            marker_color = "#0032ff"
        } else if source.hashValue == 2{
            marker_color = "#038c44"
        }else {
            marker_color = "##e47509f0"
        }
        
        
        let geometry:Dictionary<String,Any> = ["type":"Point","coordinates":[loc.coordinate.latitude,loc.coordinate.longitude]]
        mainDict["properties"] = properties
        mainDict["geometry"] = geometry
        
        return mainDict
    }
    
}
