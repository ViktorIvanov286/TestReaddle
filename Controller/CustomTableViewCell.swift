//
//  CustomTableViewCell.swift
//  TestReaddle
//
//  Created by Ivanov Viktor on 13.05.2020.
//  Copyright © 2020 Ivanov Viktor. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var statusColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
