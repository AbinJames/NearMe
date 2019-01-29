//
//  PlaceTableViewCell.swift
//  NearMe
//
//  Created by Admin on 25/01/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

	@IBOutlet weak var placeImageView: UIImageView!
	@IBOutlet weak var placeNameLabel: UILabel!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var priceRangeLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
