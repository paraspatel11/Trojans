//
//  MyDataTableViewCell.swift
//  Trojans
//
//  Created by Xcode User on 2019-11-19.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit

class MyDataTableViewCell: UITableViewCell {

    @IBOutlet var myName : UILabel!
    @IBOutlet var myDesc : UILabel!
    @IBOutlet var myDistance : UILabel!
    @IBOutlet var myStars : UIImageView!
    @IBOutlet var myPrice : UIImageView!
    @IBOutlet var myImage : UIImageView!
   
    // Pop Up form
    @IBOutlet var myReservation : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
