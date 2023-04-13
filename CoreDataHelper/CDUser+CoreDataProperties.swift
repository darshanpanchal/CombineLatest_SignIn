//
//  CDUser+CoreDataProperties.swift
//  
//
//  Created by Darshan on 13/04/23.
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
