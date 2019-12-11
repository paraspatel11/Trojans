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
        
       // let displayImage = rowData["Image"] as? String
       // cell.myImage.image = UIImage(named: displayImage ?? "Male.jpeg")
       
        let imageUrl = rowData["imageUrl"] as? String ?? "https://interactive-examples.mdn.mozilla.net/media/examples/grapefruit-slice-332-332.jpg"
        
        
        NKPlaceholderImage(image: UIImage(named: "Male.jpeg"), imageView: cell.myImage, imgUrl: imageUrl) { (image) in }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let row = indexPath.row
        let rowData = (self.getData.dbData?[row])! as NSDictionary
        
      
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.selectedRestaurant = indexPath.row
        mainDelegate.restName = (rowData["Name"] as? String)!
        mainDelegate.restDesc = (rowData["Description"] as? String)!
        mainDelegate.restDist = (rowData["Distance"] as? String)!
        mainDelegate.restLat = (rowData["latCoord"] as? String)!
        mainDelegate.restLong = (rowData["longCoord"] as? String)!
        
        
        self.performSegue(withIdentifier: "ChooseSegueToView", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let map = UITableViewRowAction(style: .normal, title: "View Map", handler:
        {
            action, index in
            print("Map button tapped")
            
            
            
            let row = indexPath.row
            let rowData = (self.getData.dbData?[row])! as NSDictionary
            
            
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            mainDelegate.selectedRestaurant = indexPath.row
            mainDelegate.restName = (rowData["Name"] as? String)!
            mainDelegate.restDesc = (rowData["Description"] as? String)!
            mainDelegate.restDist = (rowData["Distance"] as? String)!
            mainDelegate.restLat = (rowData["latCoord"] as? String)!
            mainDelegate.restLong = (rowData["longCoord"] as? String)!
            
            self.performSegue(withIdentifier: "ChooseSegueToView", sender: nil)
            
            
        }
        )
        map.backgroundColor = .green
        
        
        let reservation = UITableViewRowAction(style: .normal, title: "Reservation", handler:
        {
            action, index in
            print("Reservation button tapped")
        }
        )
        reservation.backgroundColor = .orange
        
        
        
        return [reservation, map]
    }
    
    
    @IBAction func unwindtoTableViewControler(sender: UIStoryboardSegue)
    {
        
    }
    
    func NKPlaceholderImage(image:UIImage?, imageView:UIImageView?,imgUrl:String,compate:@escaping (UIImage?) -> Void){
        
        if image != nil && imageView != nil {
            imageView!.image = image!
        }
        
        var urlcatch = imgUrl.replacingOccurrences(of: "/", with: "#")
        let documentpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        urlcatch = documentpath + "/" + "\(urlcatch)"
        
        let image = UIImage(contentsOfFile:urlcatch)
        if image != nil && imageView != nil
        {
            imageView!.image = image!
            compate(image)
            
        }else{
            
            if let url = URL(string: imgUrl){
                
                DispatchQueue.global(qos: .background).async {
                    () -> Void in
                    let imgdata = NSData(contentsOf: url)
                    DispatchQueue.main.async {
                        () -> Void in
                        imgdata?.write(toFile: urlcatch, atomically: true)
                        let image = UIImage(contentsOfFile:urlcatch)
                        compate(image)
                        if image != nil  {
                            if imageView != nil  {
                                imageView!.image = image!
                            }
                        }
                    }
                }
            }
        }
    }
}
