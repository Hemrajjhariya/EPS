//
//  PropertyListTableViewCell.swift
//  WudStayTMS
//
//  Created by Hemraj Mehra on 17/01/17.
//  Copyright © 2017 Hemraj Mehra. All rights reserved.
//

import UIKit

class DetailViewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblmobilenumber: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
     func setData(array:NSDictionary) {
        
        do {
            lblName.text = array.value(forKey: "name") as? String
            lblmobilenumber.text = array.value(forKey: "mobilenumber") as? String
            lblDOB.text = array.value(forKey: "dob") as? String
            DispatchQueue.global(qos: .userInitiated).async {
                let imageUIImage: UIImage = UIImage(data: array.value(forKey: "photo") as! Data)!
                DispatchQueue.main.async {
                    self.photo.image = imageUIImage
                }
            }
        } catch {
            print("The file could not be loaded")
        }
        
        

    }
    
}
