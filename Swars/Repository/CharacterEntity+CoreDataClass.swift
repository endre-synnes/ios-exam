//
//  CharacterEntity+CoreDataClass.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 08/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CharacterEntity)
public class CharacterEntity: NSManagedObject {

    convenience init?(attributes: [String : Any], managedObjectContext: NSManagedObjectContext) {
        
        guard let name = attributes["name"] as? String,
            let url = attributes["url"] as? String else {
                return nil
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "CharacterEntity", in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
        
        self.name = name
        self.url = url
    }
}
