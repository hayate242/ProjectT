//
//  CustomBLETableViewCell.swift
//  ThaiProject1
//
//  Created by 中山颯 on 2016/12/05.
//  Copyright © 2016年 中山颯. All rights reserved.
//

import UIKit

class CustomBLETableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var Massagepower: UILabel!
    @IBOutlet weak var pSlider: UISlider!
    @IBAction func powerSlider(_ sender: UISlider) {
        
    }
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
