//
//  DetailListViewController.swift
//  TestReaddle
//
//  Created by Ivanov Viktor on 13.05.2020.
//  Copyright © 2020 Ivanov Viktor. All rights reserved.
//

import UIKit

class DetailListViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var getName = String()
    var getEmail = String()
    var getImage = String()
    var getStatus = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = getName
        email.text = getEmail
        img.downloaded(from: getImage + "?s=200")
        status.text = getStatus
        
        img.layer.cornerRadius = img.layer.frame.height / 2
        img.layer.masksToBounds = true
    }
}
