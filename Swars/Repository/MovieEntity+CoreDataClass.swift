//
//  MovieEntity+CoreDataClass.swift
//  Swars

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {

    convenience init?(attributes: [String : Any], managedObjectContext: NSManagedObjectContext) {
        
        guard let title = attributes["title"] as? String,
            let episode_id = attributes["episode_id"] as? Int,
            let url_id = attributes["url_id"] as? Int else {
                return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
        
        self.episode_id = Int32(episode_id)
        self.title = title
        self.url_id = Int32(url_id)
    }
}
