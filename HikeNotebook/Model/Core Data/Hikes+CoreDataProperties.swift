//
//  Hikes+CoreDataProperties.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 5/14/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//
//

import Foundation
import CoreData


extension Hikes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hikes> {
        return NSFetchRequest<Hikes>(entityName: "Hikes")
    }

    @NSManaged public var hikeName: String?
    @NSManaged public var hikeNote: String?

}
