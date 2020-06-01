//
//  Hikes.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 4/14/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import Foundation

struct HikeList: Codable {
    let trails: [HikeListItem]
}

struct HikeListItem: Codable {
    let name: String
    let summary: String
    let location: String
    let length: Double
    let longitude: Double
    let latitude: Double
    
}
