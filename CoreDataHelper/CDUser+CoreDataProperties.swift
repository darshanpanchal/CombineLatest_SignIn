//
//  CDUser+CoreDataProperties.swift
//  
//
//  Created by Darshan on 16/04/23.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var password: String?
    @NSManaged public var userToDo: NSSet?

}

// MARK: Generated accessors for userToDo
extension CDUser {

    @objc(addUserToDoObject:)
    @NSManaged public func addToUserToDo(_ value: CDToDo)

    @objc(removeUserToDoObject:)
    @NSManaged public func removeFromUserToDo(_ value: CDToDo)

    @objc(addUserToDo:)
    @NSManaged public func addToUserToDo(_ values: NSSet)

    @objc(removeUserToDo:)
    @NSManaged public func removeFromUserToDo(_ values: NSSet)

}
extension CDUser : Identifiable {

    func getUserFromCDUser()->UserModel{
        var objuser = UserModel()
        objuser.password  = self.password
        objuser.id  = self.id
        objuser.email  = self.email
        return objuser
    }
}
