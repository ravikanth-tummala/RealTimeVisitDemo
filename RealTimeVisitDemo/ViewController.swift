//
//  ViewController.swift
//  RealTimeVisitDemo
//
//  Created by GeoSpark on 30/09/21.
//

import UIKit

let clvisit = "clvisitSwitch"
let pauseLocation = "pauseLocation"
let starTracking = "starTracking"


class ViewController: UIViewController {

    @IBOutlet weak var clvisitSwitch: UISwitch!
    @IBOutlet weak var pauseLocationSwitch: UISwitch!
    @IBOutlet weak var startTrackingBtn: UIButton!
    @IBOutlet weak var stopTrackingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let clVisitValue =  UserDefaults.standard.bool(forKey: clvisit)
//        let pauseLocationValue =  UserDefaults.standard.bool(forKey: clvisit)
//
//        if clVisitValue{
//            self.clvisitSwitch.isOn = true
//        }
//        if pauseLocationValue{
//            self.pauseLocationSwitch.isOn = true
//        }
        if UserDefaults.standard.bool(forKey: starTracking){
            UserLocationManger.shared.startUpdateLocationManager()
            self.stopTrackingBtn.isHidden = false
            self.startTrackingBtn.isHidden = true
        }else{
            self.stopTrackingBtn.isHidden = true
            self.startTrackingBtn.isHidden = false
        }
    }

    @IBAction func startTracking(_ sender: Any) {
//        UserDefaults.standard.set(clvisitSwitch.isOn, forKey: clvisit)
//        UserDefaults.standard.set(pauseLocationSwitch.isOn, forKey: pauseLocation)
//        UserDefaults.standard.set(true, forKey: starTracking)
        self.startTrackingBtn.isHidden = true
        self.stopTrackingBtn.isHidden = false

        UserLocationManger.shared.startUpdateLocationManager()
        
    }
    
    @IBAction func stopTracking(_ sender: Any) {
        self.startTrackingBtn.isHidden = false
        self.stopTrackingBtn.isHidden = true
        UserDefaults.standard.set(false, forKey: starTracking)
        UserLocationManger.shared.stopUpdateLocationManager()

    }
}

