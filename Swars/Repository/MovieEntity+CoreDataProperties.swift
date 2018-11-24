//
//  MovieEntity+CoreDataProperties.swift
//  Swars


import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var episode_id: Int32
    @NSManaged public var title: String?
    @NSManaged public var url_id: Int32

}
