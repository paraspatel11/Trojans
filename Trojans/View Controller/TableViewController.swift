//
//  TableViewController.swift
//  Trojans
//
//  Created by Xcode User on 2019-11-27.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var tag:Int?
    
    let getData = GetData()
    var timer : Timer!
    
    @IBOutlet var myTable : UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true)
        
        getData.JSONParser()
        
       // getData.JSONParser(id: tag ?? 1)
        
    }
    
    @objc func refreshTable(){
        if(getData.dbData != nil){
            if(getData.dbData!.count > 0){
                myTable.reloadData()
                timer.invalidate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if getData.dbData != nil{
            return getData.dbData!.count
        }
        else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? MyDataTableViewCell ?? MyDataTableViewCell(style: .default, reuseIdentifier: "myCell")
        
        
        
        let rowData = getData.dbData![indexPath.row] as NSDictionary
        
        
        
        
        cell.myName.text = rowData["Name"] as? String
        cell.myDesc.text = rowData["Description"] as? String
        cell.myDistance.text = rowData["Distance"] as? String
       
        let displayStar = rowData["Stars"] as? String
        cell.myStars.image = UIImage(named: displayStar ?? "4star.jpeg")
        
        let displayPrice = rowData["Price"] as? String
        cell.myPrice.image = UIImage(named: displayPrice ?? "2dollar.jpeg")
        
        let displayImage = rowData["Image"] as? String
        cell.myImage.image = UIImage(named: displayImage ?? "Male.jpeg")
       
        /*
 
  
 let imageUrlString = "//cdn.playbuzz.com/cdn/38402fff-32a3-4e78-a532-41f3a54d04b9/cc513a85-8765-48a5-8481-98740cc6ccdc.jpg"
 
 let imageUrl = URL(string: imageUrlString)!
 
 let imageData = try! Data(contentsOf: imageUrl)
 
 let image = UIImage(data: imageData)
 
 
        let displayImage = rowData["Image"] as? String
        cell.myImage.image = UIImage(named: "Male.jpeg")
 */
        return cell
    }

}
