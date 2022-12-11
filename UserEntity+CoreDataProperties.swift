//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by mr.root on 12/11/22.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?
    @NSManaged public var avatar: String?
    @NSManaged public var id: String?

}
