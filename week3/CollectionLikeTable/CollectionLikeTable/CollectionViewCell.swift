//
//  CollectionViewCell.swift
//  CollectionLikeTable
//
//  Created by 12dot on 25.08.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelLower: UILabel!
    @IBOutlet weak var labelUpper: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight]
        
        imageView.image = UIImage(named: "one")
        labelLower.text = randomString(length: randomLength(max: 400))
        labelUpper.text = randomString(length: randomLength(max: 100))
        
    }
    override func layoutSubviews() {
     self.layoutIfNeeded()
    }
    
   

}
