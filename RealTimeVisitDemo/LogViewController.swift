//
//  LogViewController.swift
//  RealTimeVisitDemo
//
//  Created by GeoSpark on 30/09/21.
//

import UIKit

class LogViewController: UIViewController{
    
    var dataCount:[Dictionary<String,Any>] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "LogTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "LogTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
//        // set estimatedRowHeight to whatever is the fallBack rowHeight
        self.tableView.estimatedRowHeight = 44.0
        

        serverLogs()
        
    }
    
    @IBAction func ExportBtn(_ sender: Any) {
        
        var dataArray: [Dictionary<String,Any>] = []
        dataArray = UserDefaults.standard.array(forKey: "savelocationServerLogExport") as? [Dictionary<String,Any>] ?? []
        
        guard dataArray != nil else {
            return
        }
        let dict:Dictionary<String,Any> = ["type":"FeatureCollection","features":dataArray]
        print(dataArray)
        saveToJsonFile(dict)
        self.getJsonFile()
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        serverLogs()
    }
    
    
    func saveToJsonFile(_ dict:Dictionary<String,Any>) {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("location.json")
        // Transform array into data and save it into file
        do {
            let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    func getJsonFile(){
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent("location.json")
        let vc = UIActivityViewController(activityItems: [fileUrl], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    func serverLogs(){
        var dataArray: [Any] = []
        
        dataArray = UserDefaults.standard.array(forKey: "savelocationServerLogs") ?? []
        if dataArray.count != 0 && dataArray != nil{
            dataCount = dataArray as! [Dictionary<String,Any>]
            DispatchQueue.main.async {
                self.dataCount = self.dataCount.reversed()
                self.tableView.reloadData()
            }
        }
    }
    
}

extension LogViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogTableViewCell") as? LogTableViewCell
        
        let dic:Dictionary<String,Any> = dataCount[indexPath.row]
        cell?.secondLabel.text = (dic["response"] as! Dictionary<String,Any>).description
        cell?.firstLabel?.text = (dic["timeStamp"] as! String)
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    
}


