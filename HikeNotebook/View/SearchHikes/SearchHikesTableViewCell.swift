//
//  SearchHikesTableViewCell.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 5/8/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import UIKit

class SearchHikesTableViewCell: UITableViewCell {

    @IBOutlet weak var hikeNameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
