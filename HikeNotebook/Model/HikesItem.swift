//
//  HikesItem.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 5/15/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import os.log
import UIKit

class Hikes: NSObject, NSCoding {
    
    // MARK: Properties
    
    var hikeName: String
    var hikeNote: String
    var imageData: UIImage?
    var hikeDistance: String
    var rating: Int
    var hikeDifficulty: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("hike_test")
    
    // MARK: Types
    
    struct PropertyKey {
        static let hikeName = "hikeName"
        static let hikeNote = "hikeNote"
        static let imageData = "imageData"
        static let hikeDistance = "hikeDistance"
        static let rating = "rating"
        static let hikeDifficulty = "hikeDifficulty"
    }
    
    // MARK: Initialization
    
    init?(hikeName: String, hikeNote: String, imageData: UIImage?, hikeDistance: String, rating: Int, hikeDifficulty: String) {
        
        guard !hikeName.isEmpty else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.hikeName = hikeName
        self.hikeNote = hikeNote
        self.imageData = imageData
        self.hikeDistance = hikeDistance
        self.rating = rating
        self.hikeDifficulty = hikeDifficulty
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(hikeName, forKey: PropertyKey.hikeName)
        aCoder.encode(hikeNote, forKey: PropertyKey.hikeNote)
        aCoder.encode(imageData, forKey: PropertyKey.imageData)
        aCoder.encode(hikeDistance, forKey: PropertyKey.hikeDistance)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(hikeDifficulty, forKey: PropertyKey.hikeDifficulty)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let hikeName = aDecoder.decodeObject(forKey: PropertyKey.hikeName) as? String else {
            os_log("Unable to decode the name for a Hikes object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let hikeNote = aDecoder.decodeObject(forKey: PropertyKey.hikeNote) as? String else {
            os_log("Unable to decode the note for a Hikes object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let imageData = aDecoder.decodeObject(forKey: PropertyKey.imageData) as? UIImage
        
        guard let hikeDistance = aDecoder.decodeObject(forKey: PropertyKey.hikeDistance) as? String else {
            os_log("Unable to decode the distance for a Hikes object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        guard let hikeDifficulty = aDecoder.decodeObject(forKey: PropertyKey.hikeDifficulty) as? String else {
            os_log("Unable to decode the difficulty for a Hikes object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(hikeName: hikeName, hikeNote: hikeNote, imageData: imageData, hikeDistance: hikeDistance, rating: rating, hikeDifficulty: hikeDifficulty)
    }
}
