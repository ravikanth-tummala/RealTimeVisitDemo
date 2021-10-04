//
//  LogManager.swift
//  Motion
//
//  Created by Roam Device on 17/06/20.
//  Copyright © 2020 GeoSpark. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation

internal class LoggerManager: NSObject {
    
    public static let sharedInstance = LoggerManager()
    
    private static var fileUrl = { () -> URL in
        let dir: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
        return dir.appendingPathComponent("Motion.log")
    }()
    
    func writeLocationToFile(_ dict:Dictionary<String,Any>) {
        if dict.isEmpty == false {
            LoggerManager.showNotification(dict.description)
            LoggerManager.savelocationServerLogs(dict)
            let stringValue =  LoggerManager.getCurrentTimeStamp() + "        " + dict.description + "\n"
            let data = stringValue.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            if FileManager.default.fileExists(atPath: LoggerManager.fileUrl.path) {
                let fileHandle = try! FileHandle(forWritingTo: LoggerManager.fileUrl)
                fileHandle.seekToEndOfFile()
                try! fileHandle.write(data)
                fileHandle.closeFile()
            } else {
                try! data.write(to: LoggerManager.fileUrl)
            }
        }
    }
    
    static func savelocationServerLogs(_ dict:Dictionary<String,Any>){
        let dictValue:Dictionary<String,Any> = ["timeStamp":getCurrentTimeStamp(),"response":dict]
        
        var dataArray = UserDefaults.standard.array(forKey: "savelocationServerLogs")
        if let _ = dataArray {
            dataArray?.append(dictValue)
        }else{
            dataArray = [dictValue]
        }
        UserDefaults.standard.set(dataArray, forKey: "savelocationServerLogs")
        UserDefaults.standard.synchronize()
    }
    
    static func getCurrentTimeStamp()->String{
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: currentDateTime)
    }
    
    
    static func showNotification(_ location:String ){
        
        let content = UNMutableNotificationContent()
        content.title = location.description
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01 \(location)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

