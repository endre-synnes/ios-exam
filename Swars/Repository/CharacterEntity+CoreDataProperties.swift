//
//  CharacterEntity+CoreDataProperties.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 11/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//
//

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
