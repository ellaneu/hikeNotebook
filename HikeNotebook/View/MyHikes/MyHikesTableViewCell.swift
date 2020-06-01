//
//  MyHikesTableViewCell.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 3/30/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import UIKit

class MyHikesTableViewCell: UITableViewCell {

    @IBOutlet weak var hikesImageView: UIImageView!
    @IBOutlet weak var hikeNameLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hikesImageView.layer.cornerRadius = 20
//        hikesImageView.contentClippingRect
        hikesImageView.layer.borderWidth = 4
        hikesImageView.layer.borderColor = Colors.mainBlue.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with hike: Hikes) {
        hikeNameLabel.text = hike.hikeName
        hikesImageView.image = hike.imageData
        ratingControl.rating = hike.rating
        difficultyLabel.text = hike.hikeDifficulty
        
    }

}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
