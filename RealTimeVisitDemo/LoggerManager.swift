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
        print("writeLocationToFile \(dict)")
        if dict.isEmpty == false {
            LoggerManager.savelocationServerLogs(dict)
            LoggerManager.savelocationExport(dict)
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
    
    
    static func savelocationExport(_ dict:Dictionary<String,Any>){
        var dataArray = UserDefaults.standard.array(forKey: "savelocationServerLogExport")
            if let _ = dataArray {
                dataArray?.append(dict)
            }else{
                dataArray = [dict]
            }
        UserDefaults.standard.set(dataArray, forKey: "savelocationServerLogExport")
        UserDefaults.standard.synchronize()
    }
    
    
    static func getCurrentTimeStamp()->String{
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: currentDateTime)
    }
    
    
    func showNotification(_ title:String, _ body:String ){
    
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01 \(body)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

