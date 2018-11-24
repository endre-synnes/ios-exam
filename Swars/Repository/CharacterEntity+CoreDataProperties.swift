//
//  CharacterEntity+CoreDataProperties.swift
//  Swars

import Foundation
import CoreData


extension CharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var movies: String?

}
