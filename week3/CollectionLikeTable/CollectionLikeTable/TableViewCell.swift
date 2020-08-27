//
//  TableViewCell.swift
//  CollectionLikeTable
//
//  Created by 12dot on 25.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var upperLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageOne.image = UIImage(named: "one")
        lowerLabel.text = randomString(length: randomLength(max: 400))
        upperLabel.text = randomString(length: randomLength(max: 100))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
