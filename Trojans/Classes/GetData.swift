//
//  GetData.swift
//  Trojans
//
//  Created by Xcode User on 2019-11-19.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit

class GetData: NSObject {

    var dbData : [NSDictionary]?
    
   
    let myURL = "http://jahanzeb.dev.fast.sheridanc.on.ca/IOS/trojans.php"
    
    
    
    enum JSONError : String, Error {
        case NoData = "Error: No data"
        case ConversionFailed = "Error: conversion from JSON failed"
        
    }
    
    func JSONParser(){
        let endpoint = URL(string: myURL)
        let request = URLRequest(url: endpoint!)
        
        URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            do{
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                print(datastring!)
                
                
                guard let data = data else{
                    throw JSONError.NoData
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
                    else{
                        throw JSONError.ConversionFailed
                }
                
                print(json)
                self.dbData = json
                
            }
            catch let error as JSONError{
                print(error.rawValue)
            }
            catch let error as NSError{
                print(error.debugDescription)
            }
            
            }.resume()
    }
}
