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
        if source == .pauseLocation{
            properties["marker-color"] = "#e8290c"
        }else if source == .didVisit{
            properties["marker-color"] = "#08a310"
        }
        properties["recorded_at"] = "\(loc.timestamp)"
        let geometry:Dictionary<String,Any> = ["type":"Point","coordinates":[loc.coordinate.longitude,loc.coordinate.latitude]]
        mainDict["properties"] = properties
        mainDict["geometry"] = geometry
        
        return mainDict
    }
    
}
