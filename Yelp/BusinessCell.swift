//
//  BusinessCellTableViewCell.swift
//  Yelp
//
//  Created by Sandeep Raghunandhan on 2/14/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    // All UI elements
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var ratingsView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    // Set UI elements with values in business model object
    var business : Business! {
        didSet {
            nameLabel.text = business.name
            if business!.imageURL != nil {
                thumbnail.setImageWith(business!.imageURL!)
            }
            ratingsView.setImageWith(business!.ratingImageURL!)
            addressLabel.text = business.address
            cuisineLabel.text = business.categories
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            distanceLabel.text = business.distance
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnail.layer.cornerRadius = 4
        thumbnail.clipsToBounds = true

        // Adjust label size to the max preferred with
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make sure rotation doesn't break anything 
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
