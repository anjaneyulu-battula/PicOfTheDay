//
//  PicOfTheDayDB+CoreDataProperties.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 20/03/22.
//
//

import Foundation
import CoreData


extension PicOfTheDayDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PicOfTheDayDB> {
        return NSFetchRequest<PicOfTheDayDB>(entityName: "PicOfTheDayDB")
    }

    @NSManaged public var potdDate: String
    @NSManaged public var explanation: String
    @NSManaged public var fileName: String
    @NSManaged public var isFavourite: Bool
    @NSManaged public var mediaType: String?
    @NSManaged public var serviceVersion: String?
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var title: String
    @NSManaged public var favouritedDate: Date?

}

extension PicOfTheDayDB : Identifiable {

}
