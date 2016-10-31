//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Darshan Gowda on 31/10/16.
//  Copyright © 2016 Darshan Gowda. All rights reserved.
//

import Foundation
import CoreData

extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
